require 'hashie'
require 'agilecrm/error'

module AgileCRM
  class Contact < Hashie::Mash

    SYSTEM_PROPERTIES = [:first_name, :last_name, :company, :title, :email]

    def destroy
      self.class.delete(id)
    end

    class << self
      def all
        response = AgileCRM.connection.get 'contacts'
        if response.status == 200
          return response.body.map { |body| new body }
        else
          return response
        end
      end

      def find(id)
        response = AgileCRM.connection.get "contacts/#{id}"
        if response.status == 200
          new response.body
        elsif response.status == 204
          # REST API doesn't currently return 404s for unknown IDs
          fail(AgileCRM::NotFound.new(response))
        end
      end

      def create(options = {})
        payload = parse_contact_fields(options)
        AgileCRM.connection.post 'contacts', payload
      end

      # TODO
      # https://github.com/agilecrm/rest-api/issues/3
      # def update(id, options = {})
      #   payload = parse_contact_fields(options)
      #   AgileCRM.connection.put 'contacts', payload
      # end

      # TODO
      # https://github.com/agilecrm/rest-api/issues/4
      # def add_tags(tags = [], contacts = [])
      #   AgileCRM.connection.post(
      #     'contacts/bulk/tags',
      #     { tags: tags, contacts: contacts }.to_json
      #   )
      # end

      def delete(arg)
        AgileCRM.connection.delete "contacts/#{arg}"
      end

      private

      def parse_contact_fields(options)
        payload = { properties: [] }
        options.each do |key, value|
          if contact_field?(key)
            payload[key] = value
          else
            payload[:properties] << parse_property(key, value)
          end
        end
        payload.to_json
      end

      def parse_property(key, value)
        if system_propety?(key)
          { type: 'SYSTEM', name: key, value: value }
        else
          { type: 'CUSTOM', name: key, value: value }
        end
      end

      def system_propety?(key)
        SYSTEM_PROPERTIES.include?(key)
      end

      def contact_field?(key)
        [:id, :type, :tags, :lead_score, :star_value].include?(key)
      end

      def define_accessor(name)
      end
    end
  end
end
