# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_paranoid

  # Rank
  include RankedModel
  ranks :row_order, with_same: :list_id

  # Relations
  belongs_to :list
  has_many :users

  # Validates
  validates :title, presence: true

  PRIORITY = {
    critical: 1,
    high: 2,
    medium: 3,
    low: 4
  }.freeze
  enum priority: PRIORITY
end
