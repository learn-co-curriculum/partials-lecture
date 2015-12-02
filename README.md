Generate a New Rails App
`rails new playlister-app -T`

add development and testing gems

```ruby
group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'terminal-notifier-guard'
  gem 'factory_girl'
  gem 'simplecov'
  gem 'database_cleaner'
  gem 'guard', '>=2.1.0'
  gem 'guard-rspec'
end
```

Install RSpec
`rails g rspec:install`

Configure our spec_helper

  1. Add SimpleCov
  ```ruby
  require 'simplecov'
  SimpleCov.start 'rails'
  ```

  2. Comment on Fixtures as we'll use factory_girl
  ```ruby
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  ```

  3. Turn off Transactional Fixtures
  ```ruby
  config.use_transactional_fixtures = false
  ```

  4. Add in Database Cleaner
  ```ruby
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  ```

Create feature_helper.rb in spec

```ruby
require 'spec_helper'
require 'capybara/rails'
```

Get Guard Working (what a pain...)
```ruby
  gem 'guard', '>=2.1.0'
  gem 'guard-rspec'
```

Guardfile
```ruby
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

end
```


<a href='https://learn.co/lessons/playlister-rails' data-visibility='hidden'>View this lesson on Learn.co</a>
