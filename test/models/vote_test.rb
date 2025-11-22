require "test_helper"

# == Terms
# MC::  match candidate
class VoteTest < ActiveSupport::TestCase
  context 'validation' do
    context 'uniqueness' do
      should 'be uniqa on voter x rank x MC' do
        vote  = Vote.new(user:            users(:voter_a),
                         point:           ranks(:rank_1).weight,
                         match_candidate: match_candidates(:fest_2025_1_a_mr_a))
        assert_invalid_record(vote)
      end

      should 'work on the same MC x another rank' do
        vote  = Vote.new(user:            users(:voter_a),
                         point:           ranks(:rank_2).weight,
                         match_candidate: match_candidates(:fest_2025_1_a_mr_a))
        assert_invalid_record(vote)
      end

      should 'be ok on the same match-candidate x rank by another user' do
        vote  = Vote.new(user:            users(:admin),
                         point:           ranks(:rank_1).weight,
                         match_candidate: match_candidates(:fest_2025_1_a_mr_a))
        assert_valid_record(vote)
      end

      context 'on create' do
      end
    end
  end

  context 'match availability' do
    setup do
      @match  = matches(:fest_2025_1_a)
     #@match.update_attribute!(:available, false)
    end

    should 'work' do
      vote!(:voter_b, :rank_1, :fest_2025_1_a_mr_a)
      assert true
    end
  end

  context 'score' do
    should 'work' do
      assert_equal(
          # match                   candidate   score
          [ ['1st match court-a',    'Mrs.b',   15],
            ['1st match court-a',    'Mr.a',    10],
            ['1st match court-a',    'Miss.c',   5],
          ],
          Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})
    end

    context 'reset' do
      setup do
        Vote.destroy_all
      end

      should 'work' do
        assert_equal(
            # match                   candidate   score
            [],
            Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_a,     :rank_1,    :fest_2025_1_a_mr_a)
        assert_equal(
            # match                   candidate   score
            [ ['1st match court-a',    'Mr.a',    10],
            ],
            Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_b,     :rank_1,    :fest_2025_1_a_mr_a)
        assert_equal(
            # match                   candidate   score
            [ ['1st match court-a',    'Mr.a',    20],
            ],
            Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_a,     :rank_2,    :fest_2025_1_a_mrs_b)
        assert_equal(
            # match                   candidate   score
            [ ['1st match court-a',    'Mr.a',    20],
              ['1st match court-a',    'Mrs.b',    5],
            ],
            Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_b,     :rank_3,    :fest_2025_1_a_miss_c)
        assert_equal(
            # match                   candidate   score
            [ ['1st match court-a',    'Mr.a',    20],
              ['1st match court-a',    'Mrs.b',    5],
              ['1st match court-a',    'Miss.c',   3],
            ],
            Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        # admin, admin2, voter-c, votes Miss.c as rank-1
        vote!(:admin,       :rank_1,    :fest_2025_1_a_miss_c)
        vote!(:admin2,      :rank_1,    :fest_2025_1_a_miss_c)
        vote!(:voter_c,     :rank_1,    :fest_2025_1_a_miss_c)
        assert_equal(
            final_1st_match_court_a,
            Vote.score.order(score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        # cannot vote twice!
        assert_raise(ActiveRecord::RecordInvalid) do
          vote!(:voter_a,   :rank_1,    :fest_2025_1_a_mr_a)
        end

        # == vote on c_fest_2025_a at the same time
        # === voter_a votes [Miss.c, Mrs.b, Mr.a] on c_fest_2025_a
        vote!(:voter_a,     :hard_rank_1, :c_fest_2025_a_miss_c)
        assert_equal(final_1st_match_court_a +
            # match                   candidate   score
            [ ['c match-a',           'Miss.c',   100], ],
            Vote.score.order(m: 'ASC', score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_a,     :hard_rank_2, :c_fest_2025_a_mrs_b)
        assert_equal(final_1st_match_court_a +
            # match                   candidate   score
            [ ['c match-a',           'Miss.c',   100],
              ['c match-a',           'Mrs.b',     10], ],
            Vote.score.order(m: 'ASC', score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_a,     :hard_rank_3, :c_fest_2025_a_mr_a)
        assert_equal(final_1st_match_court_a +
            # match                   candidate   score
            [ ['c match-a',           'Miss.c',   100],
              ['c match-a',           'Mrs.b',     10],
              ['c match-a',           'Mr.a',       1], ],
            Vote.score.order(m: 'ASC', score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        # === voter_b votes [Mrs.b, Mr.a, Miss.c] on c_fest_2025_a
        vote!(:voter_b,     :hard_rank_1, :c_fest_2025_a_mrs_b)
        assert_equal(final_1st_match_court_a +
            # match                   candidate   score
            [ ['c match-a',           'Mrs.b',    110],
              ['c match-a',           'Miss.c',   100],
              ['c match-a',           'Mr.a',       1], ],
            Vote.score.order(m: 'ASC', score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_b,     :hard_rank_2, :c_fest_2025_a_mr_a)
        assert_equal(final_1st_match_court_a +
            # match                   candidate   score
            [ ['c match-a',           'Mrs.b',    110],
              ['c match-a',           'Miss.c',   100],
              ['c match-a',           'Mr.a',      11], ],
            Vote.score.order(m: 'ASC', score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        vote!(:voter_b,     :hard_rank_3, :c_fest_2025_a_miss_c)
        assert_equal(final_1st_match_court_a +
            # match                   candidate   score
            [ ['c match-a',           'Mrs.b',    110],
              ['c match-a',           'Miss.c',   101],
              ['c match-a',           'Mr.a',      11], ],
            Vote.score.order(m: 'ASC', score: 'DESC', c: 'ASC').map{|v| [v.m, v.c, v.score]})

        # cannot vote twice!
        assert_raise(ActiveRecord::RecordInvalid) do
          vote!(:voter_a,     :hard_rank_1, :c_fest_2025_a_miss_c)
        end

        # cannot change vote!
        assert_raise(ActiveRecord::RecordInvalid) do
          vote!(:voter_a,     :hard_rank_1, :c_fest_2025_a_mrs_b)
        end
      end
    end
  end

  private

  def vote!(user_sym, rank_sym, match_candidate_sym)
    Vote.create!(user:            users(user_sym),
                 point:           ranks(rank_sym).weight,
                 match_candidate: match_candidates(match_candidate_sym))
  end

  def final_1st_match_court_a
    # match                   candidate   score
    [ ['1st match court-a',    'Miss.c',  33],
      ['1st match court-a',    'Mr.a',    20],
      ['1st match court-a',    'Mrs.b',    5],
    ]
  end
end
