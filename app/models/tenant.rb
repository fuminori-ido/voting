class Tenant < ApplicationRecord
  has_many  :events,  -> { not_deleted }

  validates_presence_of   :name
  validates_uniqueness_of :name
end
