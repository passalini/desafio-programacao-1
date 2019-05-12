#​​ foobar-importer
This importer will give you the total gross income from your reports. You just need to sign-in as you like, **oauth with facebook included**, and create a new report with a file of TAB-separated files, with the following columns:
  - purchaser name
  - item description
  - item price
  - purchase count
  - merchant address
  - merchant name

Your file needs to have a first line with the coloumns above, but you can put in any order. With you want to use other order, remember to use the same order in the other lines!

# How to run
First you need to check and install the core dependences:
  - postgresql
  - ruby 2.5.1
  - bunbler

After that you need to install the project dependences and create the db:

`bundle install && rails db:create db:migrate`

If you want to use the Facebook login you need to run the server with ID and SECRET:

`FACEBOOK_APP_ID=YOUR_ID FACEBOOK_APP_SECRET=YOUR_SECRET rails s`

To run the tests:

`rails test`
