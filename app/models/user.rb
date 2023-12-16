# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 使用軟刪除套件
  acts_as_paranoid
  
  # Relationship
  has_many :events

  #validation for room,name is unique and couldn't talk to youself 
  validates_uniqueness_of :name
  scope :all_except, ->(user) { where.not(id: user) }
end
