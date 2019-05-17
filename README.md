# foobar-importer
This importer will give you the total gross income from your reports. You just need to sign-in as you like, **oauth with facebook included**, and create a new report with a file of TAB-separated files, with the following columns:
  - purchaser name
  - item description
  - item price
  - purchase count
  - merchant address
  - merchant name

Your file needs to have a first line with the coloumns above, but you can put in any order. With you want to use other order, remember to use the same order in the other lines!

## Features
  - login with Facebook
  - process report in background (ActiveJob + Sidekiq)
  - remote report income refresh at index and show (ActionCable)
  - remote report insertion at index (ActionCable)
  - remote pagination (Ajax)

# How to run
First you need to check and install the core dependences:
  - redis
  - postgresql
  - ruby 2.5.1
  - bunbler

After that you need to install the project dependences, create the db and set the env variables:

```shell
bundle install && rails db:setup

# If you want to use the Facebook login you need to run the server with ID and SECRET
export FACEBOOK_APP_ID='YOUR_ID'
export FACEBOOK_APP_SECRET='YOUR_SECRET'
export REDIS_URL='redis://localhost:6379/0/cache'
```

To run the server app you need to run the sidekiq service:

```shell
sidekiq -d -L log/sidekiq.log -e development
rails s
```

To run the tests:

`rails test`
