require 'agilecrm-wrapper/error'
require 'hashie'

module AgileCRMWrapper
  class Contact < Hashie::Mash
    SYSTEM_PROPERTIES = %w(first_name last_name company title email address phone)
    CONTACT_FIELDS = %w(id type tags lead_score star_value contact_company_id)

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

      def search(query, type="PERSON", page_size=10)
        response = AgileCRMWrapper.connection.get(
          "search?q=#{query}&type=#{type}&page_size=#{page_size}"
        )
        if response.status == 200
          return response.body.map { |body| new body }
        else
          return response
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
        type = system_propety?(key) ? 'SYSTEM' : 'CUSTOM'
        { 'type' => type, 'name' => key.to_s, 'value' => value }
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

    def delete_tags(tags)
      response = AgileCRMWrapper.connection.put(
        'contacts/delete/tags',
        { id: id, tags: tags }
      )

      if response.status == 200
        self.tagsWithTime = response.body
        self.tags = response.body.map { |t| t['tag'] }
      end
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
      arr = properties.select { |a| a['name'] == property_name.to_s }
      if arr.length > 1
        arr.map {|i| i['value'] }
      else
        arr.first['value'] if arr.first
      end
    end

    # Change contact owner
    # https://github.com/agilecrm/rest-api#117-change-contact-owner
    def change_owner(owner_email)
      response = AgileCRMWrapper.connection.post(
        'contacts/change-owner', "owner_email=#{owner_email}&contact_id=#{id}",
        'content-type' => 'application/x-www-form-urlencoded'
      )
      merge!(response.body)

    rescue Faraday::ParsingError => e
      if e.message =~ /Owner with this email does not exist/
        raise AgileCRMWrapper::NotFound.new(response, 'Owner with this email does not exist')
      else
        raise e
      end
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
