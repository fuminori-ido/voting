# README

This app 'Voting' is inspired from https://github.com/dockersamples/example-voting-app
and re-written by 'ruby' to:

* vote several candidates via web page.
* admin candidates, avator, stage, etc.

## Sample page

* Admin page:
  ![Admin page](/voting/blob/main/doc/admin-candidates-page-2.png?raw=true)
* Voting page:
  ![Voting page](/voting/blob/main/doc/voting-page-2.png?raw=true)

# Prerequisites

* Ruby 3.4.5, but may run with older.
* Rails 8.0.2

# Build development environment

Legend

* '$'       - bash prompt
* '>'       - mysql prompt
* [...]     - variable parameter. e.g. [HOST] means actual hostname.

1. git clone
   1. goto your working directory (e.g. ~/temp/)
   1. git clone
      ```
      $ git clone [URL-of-this-repo]
      $ cd voting
      ```
1. bundle install
   ```
   $ bundle install
   ```
1. Database preparation for development env:
   1. create user and database:
      ```
      $ mysql -h [HOST] -u root -p
      ```
      where, [HOST] may be 127.0.0.1 or any other appropreate hostname.
      ```
      > create user voting identified by "voting";
      > create database voting_dev;
      > grant all on voting_dev.* to voting;
      > create database voting_test;
      > grant all on voting_test.* to voting;
      > flush privileges;
      ```
   1. (sample) create development data from test fixtures:
      ```
      $ bundle exec rails db:fixtures:load
      ```
   1. create avator of candidates from sample photo
      1. prepare image files at a directory [IMAGE_DIR] by #{name}.png
      1. run rake task:
         ```
         $ bundle exec rake voting:load_photo IMAGE_DIR=[IMAGE_DIR]
         ```
1. run development server
   ```
   $ bin/dev
   ```
1. access http://127.0.0.1:3000 from browser.
   Admin user login id & password is defined at [test/fixtures/users.yml](test/fixtures/users.yml).

* How to run the test suite
  ```
  $ bundle exec rake test
  ```
  would run, but in my case
  ```
  $ PARALLEL_WORKERS=1 bundle exec rake test
  ```
  run.

# Deployment instructions

1. create config/deploy.rb and config/deploy/*.rb from *.example files.
1. use 'capistrano' as:
   ```
   $ bundle exec cap staging     deploy    # for staging env.
   $ bundle exec cap performance deploy    # for performance test env.
   $ bundle exec cap production  deploy    # for production
   ```

# Performance test result

I did a performance test by jmeter.  The result is [/test/jmeter/](/test/jmeter/).
