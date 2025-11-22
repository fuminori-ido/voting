require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:voter_a)
  end

  context 'admin' do
    setup do
      @user = users(:admin2)
      login(users(:admin))
    end

    should 'get index' do
      get users_url
      assert_response :success

      assert assigns(:list).where(id: match_candidates(:deleted).id).empty?
    end

    should 'get new' do
      get new_user_url
      assert_response :success
    end

    should 'create user' do
      assert_difference("User.count") do
        post users_url, params: { user: {code: 'new-user'} }
      end

      assert_redirected_to users_url
    end

    should 'get edit' do
      get edit_user_url(@user)
      assert_response :success
    end

    should 'update user' do
      patch user_url(@user), params: { user: {admin: true} }
      assert_redirected_to users_url
    end

    should 'destroy user' do
      assert_difference("User.not_deleted.count", -1) do
        delete user_url(@user)
      end

      assert_redirected_to users_url
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
      get users_url
      assert_nil assigns(:list)
    end

    should 'not get new' do
      get new_user_url
      assert_redirected_to new_session_path
    end

    should 'not create user' do
      # normal user is created because the admin is deleted (not exist)
      # so that is why assert_no_difference is not checked.
      post users_url, params: { user: {code: 'new-user'} }
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_user_url(@user)
      assert_redirected_to new_session_path
    end

    should 'not update user' do
      patch user_url(@user), params: { user: {admin: true} }
      assert_redirected_to new_session_path
    end

    should 'not destroy user' do
      assert_no_difference("User.not_deleted.where(code: '#{@user.code}').count") do
        delete user_url(@user)
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
      get users_url
      assert_nil assigns(:list)
    end

    should 'not get new' do
      get new_user_url
      assert_redirected_to new_session_path
    end

    should 'not create user' do
      assert_no_difference("User.count") do
        post users_url, params: { user: {code: 'new-user'} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_user_url(@user)
      assert_redirected_to new_session_path
    end

    should 'not update user' do
      patch user_url(@user), params: { user: {admin: true} }
      assert_redirected_to new_session_path
    end

    should 'not destroy user' do
      assert_no_difference("User.not_deleted.count") do
        delete user_url(@user)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
