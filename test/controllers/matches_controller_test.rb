require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match = matches(:fest_2025_1_a)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get matches_url
      assert_response :success

      assert assigns(:list).where(id: matches(:deleted).id).empty?
    end

    should 'get new' do
      get new_match_url
      assert_response :success
    end

    should 'create match' do
      assert_difference("Match.count") do
        post matches_url, params: { match: {
              event_id:     events(:fest_2025).id,
              stage_id:     stages(:stage_a).id,
              rank_slot_id: rank_slots(:soft).id,
              name:         'match-a'
            }}
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_match_url(@match)
      assert_response :success
    end

    should 'update match' do
      patch match_url(@match), params: { match: {name: 'match-A2'} }
      assert_redirected_to url_for(action: 'index')
    end

    should 'get show' do
      get match_url(@match)
      assert_response :success
    end

    should 'destroy match' do
      assert_difference("Match.not_deleted.count", -1) do
        delete match_url(@match)
      end

      assert_redirected_to matches_url
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
      get matches_url

      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_match_url
      assert_redirected_to new_session_path
    end

    should 'not create match' do
      assert_no_difference("Match.count") do
        post matches_url, params: { match: {
              event_id: events('fest_2025').id,
              name:     'match-a'
            }}
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_match_url(@match)
      assert_redirected_to new_session_path
    end

    should 'not update match' do
      patch match_url(@match), params: { match: {name: 'match-A2'} }
      assert_redirected_to new_session_path
    end

    should 'not get show' do
      get match_url(@match)
      assert_redirected_to new_session_path
    end

    should 'not destroy match' do
      assert_no_difference("Match.not_deleted.count") do
        delete match_url(@match)
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
      get matches_url

      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_match_url
      assert_redirected_to new_session_path
    end

    should 'not create match' do
      assert_no_difference("Match.count") do
        post matches_url, params: { match: {
              event_id: events('fest_2025').id,
              name:     'match-a'
            }}
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_match_url(@match)
      assert_redirected_to new_session_path
    end

    should 'not update match' do
      patch match_url(@match), params: { match: {name: 'match-A2'} }
      assert_redirected_to new_session_path
    end

    should 'not get show' do
      get match_url(@match)
      assert_redirected_to new_session_path
    end

    should 'not destroy match' do
      assert_no_difference("Match.not_deleted.count") do
        delete match_url(@match)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
