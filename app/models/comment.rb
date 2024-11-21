class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, dependent: :destroy

  validates :body, presence: true, length: { maximum: 100 } # コメント本文は必須で500文字以内に制限
  validates :user, presence: true
end