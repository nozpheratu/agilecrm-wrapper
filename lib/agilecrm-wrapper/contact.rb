require 'agilecrm-wrapper/error'
require 'hashie'

module AgileCRMWrapper
  class Contact < Hashie::Mash
    SYSTEM_PROPERTIES = %w(first_name last_name company title email)
    CONTACT_FIELDS = %w(id type tags lead_score star_value)

    class << self
      def all
        response = AgileCRMWrapper.connection.get('contacts')
        if response.status == 200
          return response.body.map { |body| new body }
        else
          return response
        end
      end

      def find(id)
        response = AgileCRMWrapper.connection.get("contacts/#{id}")
        if response.status == 200
          new(response.body)
        elsif response.status == 204
          fail(AgileCRMWrapper::NotFound.new(response))
        end
      end

      def search_by_email(*emails)
        emails = emails.flatten.compact.uniq
        response = AgileCRMWrapper.connection.post(
          'contacts/search/email', "email_ids=#{emails}",
          'content-type' => 'application/x-www-form-urlencoded'
        )
        if response.body.size > 1
          response.body.reject(&:nil?).map { |body| new body }
        else
          res = new(response.body.first)
          res.empty? ? nil : res
        end
      end

      def create(options = {})
        payload = parse_contact_fields(options)
        response = AgileCRMWrapper.connection.post('contacts', payload)
        if response && response.status == 200
          contact = new(response.body)
        end

        contact
      end

      def delete(arg)
        AgileCRMWrapper.connection.delete("contacts/#{arg}")
      end

      def parse_contact_fields(options)
        payload = { 'properties' => [] }
        options.each do |key, value|
          if contact_field?(key)
            payload[key.to_s] = value
          else
            payload['properties'] << parse_property(key, value)
          end
        end
        payload
      end

      private

      def parse_property(key, value)
        if system_propety?(key)
          { 'type' => 'SYSTEM', 'name' => key.to_s, 'value' => value }
        else
          { 'type' => 'CUSTOM', 'name' => key.to_s, 'value' => value }
        end
      end

      def system_propety?(key)
        SYSTEM_PROPERTIES.include?(key.to_s)
      end

      def contact_field?(key)
        CONTACT_FIELDS.include?(key.to_s)
      end
    end

    def destroy
      self.class.delete(id)
    end

    def notes
      response = AgileCRMWrapper.connection.get("contacts/#{id}/notes")
      response.body.map { |note| AgileCRMWrapper::Note.new(note) }
    end

    def update(options = {})
      payload = self.class.parse_contact_fields(options)
      payload['properties'] = merge_properties(payload['properties'])
      merge!(payload)
      response = AgileCRMWrapper.connection.put('contacts', self)
      merge!(response.body)
    end

    def get_property(property_name)
      return unless respond_to?(:properties)
      prop = properties.select { |a| a['name'] == property_name.to_s }
      OpenStruct.new(*prop).value
    end

    private

    def merge_properties(new_properties)
      properties.map do |h|
        new_properties.delete_if do |h2|
          if h['name'] == h2['name']
            h['value'] = h2['value']
            true
          end
        end
        h
      end + new_properties
    end
  end
end
