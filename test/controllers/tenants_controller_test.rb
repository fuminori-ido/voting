require "test_helper"

class TenantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:a)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get tenants_url
      assert_response :success

      assert assigns(:list).where(id: tenants(:deleted).id).empty?
    end

    should 'get new' do
      get new_tenant_url
      assert_response :success
    end

    should 'create tenant' do
      assert_difference("Tenant.count") do
        post tenants_url, params: { tenant: {name: 't'} }
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_tenant_url(@tenant)
      assert_response :success
    end

    should 'update tenant' do
      patch tenant_url(@tenant), params: { tenant: {name: 't2'} }
      assert_redirected_to url_for(action: 'index')
    end

    should 'destroy tenant' do
      assert_difference("Tenant.not_deleted.count", -1) do
        delete tenant_url(@tenant)
      end

      assert_redirected_to tenants_url
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
      get tenants_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_tenant_url
      assert_redirected_to new_session_path
    end

    should 'not create tenant' do
      assert_no_difference("Tenant.count") do
        post tenants_url, params: { tenant: {name: 't'} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_tenant_url(@tenant)
      assert_redirected_to new_session_path
    end

    should 'not update tenant' do
      patch tenant_url(@tenant), params: { tenant: {name: 't2'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy tenant' do
      assert_no_difference("Tenant.not_deleted.count") do
        delete tenant_url(@tenant)
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
      get tenants_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_tenant_url
      assert_redirected_to new_session_path
    end

    should 'not create tenant' do
      assert_no_difference("Tenant.count") do
        post tenants_url, params: { tenant: {name: 't'} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_tenant_url(@tenant)
      assert_redirected_to new_session_path
    end

    should 'not update tenant' do
      patch tenant_url(@tenant), params: { tenant: {name: 't2'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy tenant' do
      assert_no_difference("Tenant.not_deleted.count") do
        delete tenant_url(@tenant)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
