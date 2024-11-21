class Event < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  
  belongs_to :user
  belongs_to :genre, optional: true
  belongs_to :game, optional: true
  belongs_to :group, optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 1000 }
  validates :place, presence: true, length: { maximum: 255 }
  validates :date, presence: true
end