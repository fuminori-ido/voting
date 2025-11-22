require "test_helper"

class RankSlotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rank_slot = rank_slots(:soft)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get rank_slots_url
      assert_response :success
    end

    should 'get new' do
      get new_rank_slot_url
      assert_response :success
    end

    should 'create rank_slot' do
      assert_difference("RankSlot.count") do
        post rank_slots_url, params: { rank_slot: {name: 'mild'} }
      end
      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_rank_slot_url(@rank_slot)
      assert_response :success
    end

    should 'update rank_slot' do
      patch rank_slot_url(@rank_slot), params: { rank_slot: {name: 'softer'} }
      assert_redirected_to url_for(action: 'index')
    end

    should 'destroy rank_slot' do
      assert_no_difference('RankSlot.count') do
        assert_difference("RankSlot.not_deleted.count", -1) do
          delete rank_slot_url(@rank_slot)
        end
      end
      assert_redirected_to rank_slots_url
    end
  end

  context 'deleted admin' do
    setup do
      login(users(:deleted_admin))
    end

    should 'not get index' do
      get rank_slots_url
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_rank_slot_url
      assert_redirected_to new_session_path
    end

    should 'not create rank_slot' do
      assert_no_difference("Rank.count") do
        post rank_slots_url, params: { rank: {name: '99', match_id:   matches(:fest_2025_1_a).id} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_rank_slot_url(@rank_slot)
      assert_redirected_to new_session_path
    end

    should 'not update rank_slot' do
      patch rank_slot_url(@rank_slot), params: { rank_slot: {name: '99'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy rank_slot' do
      assert_no_difference("Rank.not_deleted.count") do
        delete rank_slot_url(@rank_slot)
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
      get rank_slots_url
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_rank_slot_url
      assert_redirected_to new_session_path
    end

    should 'not create rank_slot' do
      assert_no_difference("Rank.count") do
        post rank_slots_url, params: { rank_slot: {name: '99', match_id:   matches(:fest_2025_1_a).id} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_rank_slot_url(@rank_slot)
      assert_redirected_to new_session_path
    end

    should 'not update rank_slot' do
      patch rank_slot_url(@rank_slot), params: { rank_slot: {name: '99'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy rank_slot' do
      assert_no_difference("Rank.not_deleted.count") do
        delete rank_slot_url(@rank_slot)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
