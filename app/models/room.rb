# frozen_string_literal: true

class Room < ApplicationRecord
  # validation: room's name could not recurring and create public room
  validates :name, presence: true, uniqueness: true
  scope :public_rooms, -> { where(is_private: false) }
  # after_create_commit { broadcast_append_to 'rooms' }
  after_create_commit { broadcast_if_public }
  has_many :messages
  has_many :participants, dependent: :destroy

  def broadcast_if_public
    broadcast_append_to 'rooms' unless is_private
  end

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end
    single_room
  end
end
