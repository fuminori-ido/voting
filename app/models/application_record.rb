class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :not_deleted, ->{ where(deleted_at: nil) }

  def deleted?
    !deleted_at.nil?
  end
end
