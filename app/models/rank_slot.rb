class RankSlot < ApplicationRecord
  has_many  :ranks,       -> { not_deleted }
  has_many  :matches,     -> { not_deleted }
end
