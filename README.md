aws-users-management
---

Mail AWS users a random securely generated password. 

NOTE: You have to create the user through other means (i.e: Terraform)

## Requirements:

* Ruby 3+

## Usage:

1. Duplicate and fill `.env.example` with it's corresponding variables to a `.env` file.

2. Set up
```
bundle install
bin/console
```

3. Play
```ruby
# Check the candidates
UM::Users.select_without_passwords

# Check their to-be passwords passwords:
UM::Passwords.generate_for_users

# WARNING: Send the assigned passwords to users by email
UM.assign_and_email!
```

4. There's also a Dockerfile in case you don't want to do the entire Ruby/Bundle dance:

```
make build
make run
```

### Coding Rationale:

All classes have just class methods, no instances or weird metaprogramming stuff that nobody understands. The idea is to be as straightforward in the process as possible.

This **is not** a wrapper of the AWS API or the aws-sdk, the idea is to manage `Users`, their `Passwords` and `Mail` them when necessary. Oh yeah, you also have a `Logger` in case you want to output some stuff.


