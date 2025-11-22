require "test_helper"

class RanksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rank = ranks(:rank_1)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get ranks_url
      assert_response :success
    end

    should 'get new' do
      get new_rank_url
      assert_response :success
    end

    should 'create rank' do
      assert_difference("Rank.count") do
        post ranks_url, params: { rank: {
              rank_slot_id: rank_slots(:soft).id,
              name:         '5th',
              weight:       -99,
            }}
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_rank_url(@rank)
      assert_response :success
    end

    should 'update rank' do
      patch rank_url(@rank), params: { rank: {weight: 9999} }
      assert_redirected_to url_for(action: 'index')
      assert_equal 9999, assigns(:rec).weight
    end

    should 'destroy rank' do
      assert_difference("Rank.not_deleted.count", -1) do
        delete rank_url(@rank)
      end

      assert_redirected_to ranks_url
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
      get ranks_url
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_rank_url
      assert_redirected_to new_session_path
    end

    should 'not create rank' do
      assert_no_difference("Rank.count") do
        post ranks_url, params: { rank: {name: '99', match_id:   matches(:fest_2025_1_a).id} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_rank_url(@rank)
      assert_redirected_to new_session_path
    end

    should 'not update rank' do
      patch rank_url(@rank), params: { rank: {name: '99'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy rank' do
      assert_no_difference("Rank.not_deleted.count") do
        delete rank_url(@rank)
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
      get ranks_url
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_rank_url
      assert_redirected_to new_session_path
    end

    should 'not create rank' do
      assert_no_difference("Rank.count") do
        post ranks_url, params: { rank: {name: '99', match_id:   matches(:fest_2025_1_a).id} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_rank_url(@rank)
      assert_redirected_to new_session_path
    end

    should 'not update rank' do
      patch rank_url(@rank), params: { rank: {name: '99'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy rank' do
      assert_no_difference("Rank.not_deleted.count") do
        delete rank_url(@rank)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
