require 'agilecrm-wrapper/error'
require 'hashie'

module AgileCRMWrapper
  class Note < Hashie::Mash
    class << self
      def create(*contacts, subject: '', description: '')
        contacts = contacts.flatten.uniq.map(&:to_s)
        payload = {
          'subject' => subject,
          'description' => description,
          'contact_ids' => contacts
        }
        response = AgileCRMWrapper.connection.post('notes', payload)
        new(response.body)
      end

      def add_by_email(email: '', subject: '', description: '')
        payload = {
          'subject' => subject,
          'description' => description
        }
        query = "email=#{email}&note=#{payload.to_json}"
        AgileCRMWrapper.connection.post(
          'contacts/email/note/add', query,
          'content-type' => 'application/x-www-form-urlencoded'
        )
      end
    end
  end
end
