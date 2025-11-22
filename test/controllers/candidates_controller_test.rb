require "test_helper"

class CandidatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @candidate = candidates(:mr_a)
  end

  context 'admin' do
    setup do
      login(users(:admin))
    end

    should 'get index' do
      get candidates_url
      assert_response :success

      assert assigns(:list).where(id: candidates(:deleted).id).empty?
    end

    should 'get new' do
      get new_candidate_url
      assert_response :success
    end

    should 'create candidate' do
      assert_difference("Candidate.count") do
        File.open(data_test_file('voting.png')) do |f|
          post candidates_url, params: { candidate: {
                name:   'c-new',
                avatar: f,
              }}
        end
      end

      assert_redirected_to url_for(action: 'index')
    end

    should 'get edit' do
      get edit_candidate_url(@candidate)
      assert_response :success
    end

    should 'update candidate' do
      patch candidate_url(@candidate), params: { candidate: {name: 'c2'} }
      assert_redirected_to url_for(action: 'index')
    end

    should 'destroy candidate' do
      assert_difference("Candidate.not_deleted.count", -1) do
        delete candidate_url(@candidate)
      end

      assert_redirected_to candidates_url
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
      get candidates_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_candidate_url
      assert_redirected_to new_session_path
    end

    should 'not create candidate' do
      assert_no_difference("Candidate.count") do
        post candidates_url, params: { candidate: {name: 'c-new'} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_candidate_url(@candidate)
      assert_redirected_to new_session_path
    end

    should 'not update candidate' do
      patch candidate_url(@candidate), params: { candidate: {name: 'c2'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy candidate' do
      assert_no_difference("Candidate.not_deleted.count") do
        delete candidate_url(@candidate)
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
      get candidates_url
      assert_nil assigns(:list)
      assert_redirected_to new_session_path
    end

    should 'not get new' do
      get new_candidate_url
      assert_redirected_to new_session_path
    end

    should 'not create candidate' do
      assert_no_difference("Candidate.count") do
        post candidates_url, params: { candidate: {name: 'c-new'} }
      end
      assert_redirected_to new_session_path
    end

    should 'not get edit' do
      get edit_candidate_url(@candidate)
      assert_redirected_to new_session_path
    end

    should 'not update candidate' do
      patch candidate_url(@candidate), params: { candidate: {name: 'c2'} }
      assert_redirected_to new_session_path
    end

    should 'not destroy candidate' do
      assert_no_difference("Candidate.not_deleted.count") do
        delete candidate_url(@candidate)
      end
      assert_redirected_to new_session_path
    end

    # thumb *can* be get by anonymous
    should 'get thumb' do
      File.open(data_test_file('voting.png')) do |f|
        @candidate.avatar = f; @candidate.save!

        get thumb_candidate_url(@candidate)
        assert_response :success
      end
    end

    # big_thumb *can* be get by anonymous
    should 'get big_thumb' do
      File.open(data_test_file('voting.png')) do |f|
        @candidate.avatar = f; @candidate.save!

        get big_thumb_candidate_url(@candidate)
        assert_response :success
      end
    end

    teardown do
      logout
    end
  end
end
