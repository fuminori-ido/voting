class Event < ApplicationRecord
  belongs_to  :tenant
  has_many    :matches, -> { not_deleted }

  validates_presence_of   :name
  validates_uniqueness_of :name
end
