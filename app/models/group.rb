class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :genre, optional: true
  belongs_to :game, optional: true
  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members, source: :user
  has_many :group_messages, dependent: :destroy

  before_validation :set_genre_id

  validates :name, presence: true, unless: :is_deleted, length: { maximum: 30 }
  validates :body, presence: true, unless: :is_deleted, length: { maximum: 1000 }
  validates :game_id, presence: true

  private

  def set_genre_id
    self.genre_id = game.genre_id if game.present? # gameに関連するgenre_idを設定
  end
end