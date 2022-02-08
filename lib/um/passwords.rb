module UM
  class Passwords

    # Yes, this adds coupling between classes. Let's see if this grows enough to have the need of decoupling
    # TODO: Decouple UM::Users from UM::Passwords
    @users = UM::Users

    class << self
      attr_reader :users

      # Create and assign a password to every user in memory.
      # The users are the last created ones by default.
      def generate_for_users(last_users: true)
        users_with_passwords = {}

        users.select_without_passwords(last_users: last_users).each do |user|
          users_with_passwords[user] = generate_single
        end

        users_with_passwords
      end

      def generate_single
        secure_random = SecureRandom.base64(16).to_s
        owasp_symbols = "!#$%&'()*+,-./:;<=>?@[]^_`{|}~".chars.sample(2).join("")
        numbers       = (1..9).to_a.sample(2).join("")

        (secure_random + owasp_symbols + numbers).chars.shuffle.join("")
      end

    end
  end
end
