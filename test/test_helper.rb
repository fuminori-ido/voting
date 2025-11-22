ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def assert_valid_record(record)
      assert record.valid?, record.errors.full_messages.join(' ')
    end

    def assert_invalid_record(record)
      assert !record.valid?, record.errors.full_messages.join(' ')
    end

    def login(user)
      ENV['VOTING_TEST_USER_CODE']  = user.code
    end

    def logout
      ENV['VOTING_TEST_USER_CODE']  = nil
    end

    def data_test_file(relative_path)
      Rails.root + 'test/data/' + relative_path
    end
  end
end
