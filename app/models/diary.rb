class Diary < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable

  belongs_to :user
  belongs_to :genre, optional: true
  belongs_to :game, optional: true
  belongs_to :group, optional: true
  # optional: true ...この関連が必須でない

  before_validation :set_genre_id

  validates :game_id, presence: true
  validates :title, presence: true, unless: :is_deleted, length: { maximum: 30 }
  validates :body, presence: true, unless: :is_deleted, length: { maximum: 1000 }


  scope :active, -> { where(is_deleted: false) } # 論理削除されていない投稿のみを取得

  # # メソッド例(削除実行者 (by) と削除理由 (reason) を記録するメソッド)
  # def mark_as_deleted(by:, reason: nil)
  #   update(is_deleted: true, deleted_by: by, deleted_reason: reason)
  # end

  private

  def set_genre_id
    self.genre_id = game.genre_id if game.present? # gameに関連するgenre_idを設定
  end
end
