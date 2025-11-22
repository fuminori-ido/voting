require_relative  '../../../lib/wtech.rb'

if ENV['RAILS_ENV'] == 'development'
  gem     'foreman'
  package 'watchman'
end

include_recipe    '../cookbooks/base.rb'
