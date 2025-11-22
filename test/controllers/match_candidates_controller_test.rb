require "test_helper"

class MatchCandidatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match_candidate = match_candidates(:fest_2025_1_a_mr_a)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get match_candidates_url
      assert_response :success

      assert assigns(:list).where(id: match_candidates(:fest_2025_1_a_deleted).id).empty?
      assert assigns(:list).where(id: match_candidates(:deleted).id).empty?
      assert assigns(:list).where(id: match_candidates(:deleted_mr_a).id).empty?
    end

    should 'get new' do
      get new_match_candidate_url
      assert_response :success
    end

    should 'create match' do
      assert_difference("MatchCandidate.count") do
        post match_candidates_url, params: { match_candidate: {
              match_id:     matches(:fest_2025_1_a).id,
              candidate_id: candidates(:mr_a).id,
            }}
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_match_candidate_url(@match_candidate)
      assert_response :success
    end

    should 'update match' do
      patch match_candidate_url(@match_candidate), params: { match_candidate: {
              match_id:     matches(:fest_2025_1_a).id,
              candidate_id: candidates(:mrs_b).id,
            }}
      assert_redirected_to url_for(action: 'index')
    end

    should 'destroy match' do
      assert_difference("MatchCandidate.not_deleted.count", -1) do
        delete match_candidate_url(@match_candidate)
      end

      assert_redirected_to match_candidates_url
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
      get match_candidates_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_match_candidate_url
      assert_redirected_to new_session_path
    end

    should 'not create match' do
      assert_no_difference("MatchCandidate.count") do
        post match_candidates_url, params: { match_candidate: {
              match_id:     matches(:fest_2025_1_a).id,
              candidate_id: candidates(:mr_a).id,
            }}
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_match_candidate_url(@match_candidate)
      assert_redirected_to new_session_path
    end

    should 'not update match' do
      patch match_candidate_url(@match_candidate), params: { match_candidate: {
              match_id:     matches(:fest_2025_1_a).id,
              candidate_id: candidates(:mrs_b).id,
            }}
      assert_redirected_to new_session_path
    end

    should 'not destroy match' do
      assert_no_difference("MatchCandidate.not_deleted.count") do
        delete match_candidate_url(@match_candidate)
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
      get match_candidates_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_match_candidate_url
      assert_redirected_to new_session_path
    end

    should 'not create match' do
      assert_no_difference("MatchCandidate.count") do
        post match_candidates_url, params: { match_candidate: {
              match_id:     matches(:fest_2025_1_a).id,
              candidate_id: candidates(:mr_a).id,
            }}
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_match_candidate_url(@match_candidate)
      assert_redirected_to new_session_path
    end

    should 'not update match' do
      patch match_candidate_url(@match_candidate), params: { match_candidate: {
              match_id:     matches(:fest_2025_1_a).id,
              candidate_id: candidates(:mrs_b).id,
            }}
      assert_redirected_to new_session_path
    end

    should 'not destroy match' do
      assert_no_difference("MatchCandidate.not_deleted.count") do
        delete match_candidate_url(@match_candidate)
      end
      assert_redirected_to new_session_path
    end

    teardown do
      logout
    end
  end
end
