# Development Environment Setup

1. [Install asdf](https://mac.install.guide/ruby/5.html)

2. [Install Ruby](https://mac.install.guide/ruby/6.html)

3. [Update Gems](https://mac.install.guide/ruby/7.html)

4. [Install Node and Rails](https://gorails.com/setup/macos/14-sonoma)

To start the app, run:

1. `rails db:create`
2. `rails db:migrate`
3. `rails server`

App should be running in the `localhost:3000`

- To run linter: `bundle exec rubocop -l`
- To run tests: `rails test`