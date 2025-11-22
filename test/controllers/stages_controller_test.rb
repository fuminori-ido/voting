require "test_helper"

class StagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stage = stages(:stage_a)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get stages_url
      assert_response :success
    end

    should 'get new' do
      get new_stage_url
      assert_response :success
    end

    should 'create stage' do
      assert_difference("Stage.count") do
        post stages_url, params: { stage: {
              name:         '5th',
              weight:       -99,
            }}
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_stage_url(@stage)
      assert_response :success
    end

    should 'update stage' do
      patch stage_url(@stage), params: { stage: {
            name:       'updated',
            available:  false} }
      assert_redirected_to url_for(action: 'index')
      assert_equal 'updated', assigns(:rec).name
      assert                 !assigns(:rec).available
    end

    should 'destroy stage' do
      assert_difference("Stage.not_deleted.count", -1) do
        delete stage_url(@stage)
      end

      assert_redirected_to stages_url
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
      get stages_url
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_stage_url
      assert_redirected_to new_session_path
    end

    should 'not create stage' do
      assert_no_difference("Stage.count") do
        post stages_url, params: { stage: {name: '99', match_id:   matches(:fest_2025_1_a).id} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_stage_url(@stage)
      assert_redirected_to new_session_path
    end

    should 'not update stage' do
      patch stage_url(@stage), params: { stage: {
            name:       'updated',
            available:  false} }
      assert_redirected_to new_session_path
      assert_equal 'stage_a', @stage.reload.name
      assert                  @stage.available
    end

    should 'not destroy stage' do
      assert_no_difference("Stage.not_deleted.count") do
        delete stage_url(@stage)
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
      get stages_url
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_stage_url
      assert_redirected_to new_session_path
    end

    should 'not create stage' do
      assert_no_difference("Stage.count") do
        post stages_url, params: { stage: {name: '99', match_id:   matches(:fest_2025_1_a).id} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_stage_url(@stage)
      assert_redirected_to new_session_path
    end

    should 'not update stage' do
      patch stage_url(@stage), params: { stage: {
            name:       'updated',
            available:  false} }
      assert_redirected_to new_session_path
      assert_equal 'stage_a', @stage.reload.name
      assert                  @stage.available
    end

    should 'not destroy stage' do
      assert_no_difference("Stage.not_deleted.count") do
        delete stage_url(@stage)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
