require "test_helper"

class MiscsControllerTest < ActionDispatch::IntegrationTest
  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get miscs_path
      assert_response :success
    end

    should 'destroy all_votes' do
      assert        User.count != User.where(admin: true)
      delete destroy_all_votes_miscs_path

      assert_equal  0, Vote.count
      assert        User.count == User.where(admin: true).count
      assert_redirected_to miscs_path
    end

    teardown do
      logout
    end
  end

  context 'deleted admin' do
    setup do
      login(users(:deleted_admin))
    end

    should 'not get index' do
      get miscs_path
      assert_redirected_to new_session_path
    end

    should 'not destroy all_votes' do
      assert_no_difference('Vote.count') do
        delete destroy_all_votes_miscs_path
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end

  context 'normal user' do
    setup do
      login(users(:voter_a))
    end

    should 'not get index' do
      get miscs_path
      assert_redirected_to new_session_path
    end

    should 'not destroy all_votes' do
      assert_no_difference('Vote.count') do
        delete destroy_all_votes_miscs_path
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
