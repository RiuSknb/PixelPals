class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, dependent: :destroy

  validates :body, presence: true, length: { maximum: 50 }
  validates :user, presence: true
end