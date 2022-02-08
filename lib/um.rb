# Stands for User Management
module UM

  def self.client
    @@client ||= ::Aws::IAM::Client.new
  end

  require_relative 'um/users'
  require_relative 'um/passwords'
  require_relative 'um/mail'
  require_relative 'um/logger'

  # TODO:
  # - Refactor the methods here to be more DRY.
  class << self

    # Assigns the generated password + an AWS::IAM::LoginProfile (https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/IAM/LoginProfile.html)
    # NOTE: A user may have a LoginProfile and no password, this is an edge case.
    # It happens when someone manually deleted the password for the user after it already had it. (i.e: deactivated users)
    # This doesn't handle the update of the LoginProfile, but instead we just skip it and log it for manual handling.
    def assign_and_email!
      users_passwords = Passwords.generate_for_users(last_users: true)
      lp              = Aws::IAM::LoginProfile
      users_sent      = []

      Logger.error("Users/Passwords list is empty, aborting password assignment") and return if users_passwords.empty?

      users_passwords.each do |username, password|
        user_lp = lp.new(username)

        if login_profile_exists?(user_lp) # Let's make sure the user doesn't have a LP
          Logger.warn("Problem with Login Profile for username #{user_lp.user_name}, skipping.")
          next
        end

        user_lp.create(password: password, password_reset_required: true)
        Mail.send_email!(username, password) # More coupling YAY
        users_sent << username
      end

      Logger.info("DONE! Sent email to users: #{users_sent.join(", ")}") unless users_sent.empty?
      return true
    end

    # WARNING: This will overwrite the current user password with a new random one.
    def reset_and_email!(username: )
      password = Passwords.generate_single
      lp       = Aws::IAM::LoginProfile
      user_lp  = lp.new(username)

      user_lp.update(password: password, password_reset_required: true)
      Mail.send_email!(username, password)

      Logger.info("DONE! Sent email to #{username}")
      return true
    end

    # There used to be an #exists? method for LoginProfile, idk why AWS decided to ditch it.
    # # *sigh* AWS makes me check for errors instead of booleans.
    def login_profile_exists?(login_profile)
      begin
        login_profile.load.data
        return true
      rescue => e
        Logger.debug(e)
        Logger.info("If you see an Aws::IAM::Errors::NoSuchEntity error, this is \"good\", it means the user doesn't have a LoginProfile, which is expected")
        return false
      end
    end
  end
end
