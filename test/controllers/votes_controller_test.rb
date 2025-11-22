require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  context 'any user' do
    setup do
      @user = User.create!(code: 'test-dummy-' + SecureRandom.hex)
      login(@user)
    end

    context 'available stage' do
      setup do
        @stage  = stages(:stage_a)
      end

      should 'get new' do
        get new_vote_url(key: @stage.key)
        assert_response :success
        assert_no_match @controller.send(:v_i18n, 'alreay_voted_thankyou'), response.body
      end

      should 'create vote' do
        Vote.delete_all
        assert_difference("Vote.count", 3 * 2) do
          post votes_url, params: {
              key: @stage.key,
              votes: {
                matches(:fest_2025_1_a).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_a_miss_c).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_a_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_a_mrs_b).id,
                },
                matches(:fest_2025_1_b).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_b_esq_d).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_b_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_b_mrs_b).id,
                },
              }}
        end
        assert_redirected_to voted_votes_url
        assert_equal(I18n.t('text.voted'),
                     flash[:notice])
        check_score

        # show 'alreay voted' on voting again
        get new_vote_url(key: @stage.key)
        assert_response :success
        assert_match @controller.send(:v_i18n, 'alreay_voted_thankyou'), response.body

        # should not vote twice on the same match_candidate
        assert_no_difference("Vote.count") do
          post votes_url, params: {
              key: @stage.key,
              votes: {
                matches(:fest_2025_1_a).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_a_miss_c).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_a_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_a_mrs_b).id,
                },
                matches(:fest_2025_1_b).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_b_esq_d).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_b_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_b_mrs_b).id,
                },
              }}
        end
        assert_redirected_to voted_votes_url
        assert flash[:alert].present?
        check_score
      end

      should 'get voted' do
        get voted_votes_url
        assert_response :success
      end
    end

    context 'unavailable stage' do
      setup do
        @stage  = stages(:stage_unavailable)
      end

      should 'not get new' do
        get new_vote_url(key: @stage.key)
        assert_response :not_found
      end

      should 'not create vote' do
        Vote.delete_all
        assert_no_difference("Vote.count") do
          post votes_url, params: {
              key: @stage.key,
              votes: {
                matches(:fest_2025_1_a).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_a_miss_c).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_a_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_a_mrs_b).id,
                },
                matches(:fest_2025_1_b).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_b_esq_d).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_b_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_b_mrs_b).id,
                },
              }}
        end
        assert_response 404
      end
    end

    context 'empty key' do
      should 'not get new' do
        get new_vote_url
        assert_response :not_found
      end

      should 'not create vote' do
        Vote.delete_all
        assert_no_difference("Vote.count") do
          post votes_url, params: {
              votes: {
                matches(:fest_2025_1_a).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_a_miss_c).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_a_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_a_mrs_b).id,
                },
                matches(:fest_2025_1_b).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_b_esq_d).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_b_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_b_mrs_b).id,
                },
              }}
        end
        assert_response 404
      end
    end

    context 'deleted stage' do
      setup do
        @stage  = stages(:deleted)
      end

      should 'not get new' do
        get new_vote_url(key: @stage.key)
        assert_response :not_found
      end

      should 'not create vote' do
        Vote.delete_all
        assert_no_difference("Vote.count") do
          post votes_url, params: {
              key: @stage.key,
              votes: {
                matches(:fest_2025_1_a).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_a_miss_c).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_a_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_a_mrs_b).id,
                },
                matches(:fest_2025_1_b).id => {
                  ranks(:rank_1).id => match_candidates(:fest_2025_1_b_esq_d).id,
                  ranks(:rank_2).id => match_candidates(:fest_2025_1_b_mr_a).id,
                  ranks(:rank_3).id => match_candidates(:fest_2025_1_b_mrs_b).id,
                },
              }}
        end
        assert_response 404
      end
    end

    teardown do
      logout
    end
  end

  private

  def check_score
    assert_equal(
        [ ["1st match court-a", "Miss.c", 10],
          ["1st match court-a", "Mr.a",    5],
          ["1st match court-a", "Mrs.b",   3]],
        Vote.score.where(matches: {id: matches(:fest_2025_1_a).id}).
            order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

    assert_equal(
        [ ["1st match court-b", "Esq.d",  10],
          ["1st match court-b", "Mr.a",    5],
          ["1st match court-b", "Mrs.b",   3]],
        Vote.score.where(matches: {id: matches(:fest_2025_1_b).id}).
            order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})
  end
end
