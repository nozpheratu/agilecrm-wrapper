require 'agilecrm/error'
require 'hashie'

module AgileCRM
  class Note < Hashie::Mash
    class << self
      def create(*contacts, subject: '', description: '')
        contacts = contacts.flatten.uniq.map(&:to_s)
        payload = {
          'subject' => subject,
          'description' => description,
          'contact_ids' => contacts
        }
        response = AgileCRM.connection.post('notes', payload)
        new(response.body)
      end

      def add_by_email(email: '', subject: '', description: '')
        payload = {
          'subject' => subject,
          'description' => description
        }
        query = "email=#{email}&note=#{payload.to_json}"
        AgileCRM.connection.post(
          'contacts/email/note/add', query,
          'content-type' => 'application/x-www-form-urlencoded'
        )
      end
    end
  end
end
