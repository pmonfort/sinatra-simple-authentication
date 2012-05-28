# Sinatra::Simple::Authentication

Basic authentication gem with support for Datamapper and ActiveRecord


## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-simple-authentication'

Or install it yourself as:

    $ gem install sinatra-simple-authentication


## Usage

Require sinatra-simple-authentication, setup your database connection
then register Sinatra::SimpleAuthentication

```ruby
require 'sinatra/simple-authentication'

class Index < Sinatra::Base
  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/example.db")

  register Sinatra::SimpleAuthentication

  get '/' do
    login_required
    haml :'/home'
  end
end
```


## Custom options

* Password confirmation
  Set to true if need to you password confirmation

* Min password length
  Set to change the default min length(4)

* Max password length
  Set to change the default max length(16)

* Change default messages

  MESSAGES                                          | DEFAULT
  taken_email_message                               | Email is already been taken.
  missing_email_message                             | Email can't be blank.
  invalid_email_message                             | Email invalid format.
  missing_password_message                          | Password can't be blank.
  short_password_message                            | Password is too short, must be between X and X characters long.
  long_password_message                             | Password is too long, must be between X and X characters long.
  missing_password_confirmation_message             | Password confirmation can't be blank.
  password_confirmation_dont_match_password_message | Password confirmation don't match password.
  login_wrong_email_message                         | The email you entered is incorrect.
  login_wrong_password_message                      | The password you entered is incorrect.
  login_successful_message                          | Login successful.

  Example
  ```ruby
    Sinatra::SimpleAuthentication.configure do |c|
      c.use_password_confirmation = true
      c.min_password_length = 4
      c.max_password_length = 16
      c.taken_email_message = "Custom taken email"
      c.missing_email_message = "Custom missing email"
      c.invalid_email_message = "Custom invalid email"
      c.missing_password_message = "Custom missing password"
      c.short_password_message = "Custom short password"
      c.long_password_message = "Custom long password"
      c.missing_password_confirmation_message = "Custom missing password confirmation"
      c.password_confirmation_dont_match_password_message = "Custom don't match password and confirmation"
      c.login_wrong_email_message = "Custom wrong email"
      c.login_wrong_password_message = "Custom wrong password"
      c.login_successful_message = "Custom Login successful"
    end
  ```


## Routes

* get/post 'login'
* get/post 'signup'
* get 'logout'


## Helpers

Placed at the begining of a route, will check if there's a logged in user otherwise will redirect to /login
login_required

logged_in?

current_user


## Requirements

* sinatra
* haml


## Flash messages

Place this before register sinatra-simple-authentication
```ruby
require 'rack-flash'

use Rack::Flash, :sweep => true
```

The error and notice messages will be available through flash[:error] and flash[:notice]


## Override default views

Default views
* signup.haml
* login.haml

To override them you only need to place the file with the same name on yours /views folder
Example: /myapp/views/signup.haml


## Override default model

On your custom model you need to require 'sinatra/simple-authentication'
and you must include the following code on your model class

```ruby

Sinatra::SimpleAuthentication.require_adapter

include Sinatra::SimpleAuthentication::Models::DataMapper::Adapter
```

Require your model class before register sinatra-simple-authentication

Note:

For ActiveRecords you would must 3 basic attributes strings email, hashed_password and salt
Example

```ruby
unless ::ActiveRecord::Base.connection.table_exists?("users")
  class CreateUsers < ::ActiveRecord::Migration
    def self.up
      create_table :users do |t|
        #basic attributes
        t.string :email
        t.string :hashed_password
        t.string :salt


      end

      add_index :users, :email, :unique => true
    end

    def self.down
      remove_index :users, :email
      drop_table :users
    end
  end

  CreateUsers.up
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
