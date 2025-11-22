class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password
  has_many  :sessions, dependent: :destroy
  has_many  :votes

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def is_guest?
    !admin
  end

  def already_voted?(stage)
    votes.joins(match_candidate: {match: :stage}).where(stage: {id: stage.id}).exists?
  end

  def errors
    super.tap {|errors| errors.delete(:password, :blank) if is_guest? }
  end
end
