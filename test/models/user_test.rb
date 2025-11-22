require "test_helper"

class UserTest < ActiveSupport::TestCase
  context 'already_voted?' do
    should 'work' do
      voter_a = users(:voter_a)
      voter_b = users(:voter_b)
      voter_c = users(:voter_c)

      stage_a = stages(:stage_a)
      stage_x = stages(:stage_x)

      assert  voter_a.already_voted?(stage_a)
      assert !voter_a.already_voted?(stage_x)

      assert  voter_b.already_voted?(stage_a)
      assert !voter_b.already_voted?(stage_x)

      assert !voter_c.already_voted?(stage_a)
      assert !voter_c.already_voted?(stage_x)
    end
  end

  context 'authenticate' do
    should 'check wrong email or password' do
      assert_nil User.authenticate_by(email_address: 'dummy', password: 'hello')
    end

    should 'check wrong password' do
      assert_nil User.authenticate_by(email_address: 'admin@example.com', password: 'hello')
    end

    should 'check wrong email' do
      assert_nil User.authenticate_by(email_address: 'dummy@example.com', password: 'password')
    end

    should 'check correct email and password' do
      assert_equal users(:admin),
                   User.authenticate_by(email_address: 'admin@example.com', password: 'password')
    end
  end
end
