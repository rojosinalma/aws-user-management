require 'uri'
require 'securerandom'

module UM
  class Users

    class << self

      # Weed out the ones WITH passwords. You can optionally filter out only the last created users
      def select_without_passwords(last_users: false)
        # TODO:There's probably a better way to do this.
        if last_users
          last_users   = select_email_users.group_by { |item| item[:create_date] }.sort.last.last # Array of hashes containing users.
          no_passwords = last_users.select { |item| !item.has_key?(:password_last_used) }
        else
          no_passwords = select_email_users.select { |item| !item.has_key?(:password_last_used) }
        end

        no_passwords.collect { |user|  user[:user_name] }
      end

      # Filter the user_names that look like emails.
      def select_email_users
        email_regex = URI::MailTo::EMAIL_REGEXP
        list_users.select{ |item| email_regex.match? item[:user_name] }
      end

      # Get all users in AWS.
      def list_users
        UM.client.list_users.to_h[:users] # We like hashes here
      end

    end
  end
end
