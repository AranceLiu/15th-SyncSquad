# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  enum role: { staff: 0, hr: 1 }
  # Relationship
  belongs_to :company, optional: true
  has_many :events
  has_many :project_members, dependent: :destroy
  has_many :affiliated_projects, through: :project_members, source: :project
  has_many :tasks

  # Chatroom
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }
  has_many :messages

  # Others
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }
end
