# Can you feel the adrenaline hit.
# Do you feel the rush of not using gems?
# That's pure Ruby babey. Who needs ActionMailer anyway
require 'net/smtp'

module UM
  class Mail

    class << self

      def send_email!(email, pw)
        from_email      = ENV.fetch("UM_FROM_EMAIL", "UM_SMTP_USER")
        email_name      = email.split("@")[0]
        name, last_name = email_name.split(".")

        message         = <<-MESSAGE_END
From: #{ENV['UM_FROM_NAME']} <#{from_email}>
To: #{name} #{last_name.nil? ? "" : last_name} <#{email}>
Subject: Your AWS Credentials

Hey there,

You got a brand new AWS account!
Here's the information you need:

  * Username: #{email}
  * Password: #{pw}
  * URL: https://xepelin.signin.aws.amazon.com/console

  You'll be asked to change your password after your first login.

Your dearly DevOps team.

MESSAGE_END

        smtp_server     = ENV.fetch("UM_SMTP_SERVER")
        smtp_port       = ENV.fetch("UM_SMTP_PORT")
        smtp_user       = ENV.fetch("UM_SMTP_USER", "")
        smtp_password   = ENV.fetch("UM_SMTP_PASSWORD", "")
        smtp_helo       = ENV.fetch("UM_SMTP_HELO", "localhost")

        Logger.info "Sending email to <#{email}>"
        begin
          # Net::SMTP.start(smtp_server, smtp_port, smtp_helo) do |smtp| # In case you wanna use it without AUTH.
          Net::SMTP.start(smtp_server, smtp_port, smtp_helo, smtp_user, smtp_password, :login) do |smtp|
            smtp.send_message(message, from_email, email)
          end
        rescue => e
          Logger.error "Mail could not be sent:\n#{e.full_message}"
          return false
        end

      end
    end
  end
end
