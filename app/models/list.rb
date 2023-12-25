class List < ApplicationRecord

  # Rank
  include RankedModel
  ranks :row_order

  # Relations
  belongs_to :project
  has_many :tasks

  # Validates
  validates :title, presence: true
end
