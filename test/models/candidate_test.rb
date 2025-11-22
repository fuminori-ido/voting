require "test_helper"

class CandidateTest < ActiveSupport::TestCase
  context 'avatar' do
    should 'work' do
      c = Candidate.new(name: 'new candidate with avatar')
      File.open(data_test_file('voting.png')) do |f|
        c.avatar  = f
      end

      c.save!
      assert  c.avatar.url
      assert  c.avatar.current_path
      assert  c.avatar_identifier
      assert !c.avatar.file.nil?

      assert  c.avatar.thumb
      assert  c.avatar.thumb.url

      assert  c.avatar.big_thumb
      assert  c.avatar.big_thumb.url

      assert  c.avatar.bigger_thumb
      assert  c.avatar.bigger_thumb.url
    end
  end
end
