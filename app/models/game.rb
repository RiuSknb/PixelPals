class Game < ApplicationRecord
  belongs_to :genre
  has_many :diaries
  has_many :events

  validates :name, presence: true, uniqueness: true
end