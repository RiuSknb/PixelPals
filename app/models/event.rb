class Event < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  
  belongs_to :user
  belongs_to :genre, optional: true
  belongs_to :game, optional: true
  belongs_to :group, optional: true

  before_validation :set_genre_id

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 1000 }
  validates :place, presence: true, length: { maximum: 255 }
  validates :date, presence: true
  validates :game_id, presence: true

  private

  def set_genre_id
    self.genre_id = game.genre_id if game.present? # gameに関連するgenre_idを設定
  end
  
end