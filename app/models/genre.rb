class Genre < ApplicationRecord
  has_many :posts
  has_many :events
  has_many :games, dependent: :destroy

  validates :name, presence: { message: 'ジャンル名を空欄にすることはできません' }
  validates :name, uniqueness: { message: '入力されたジャンル名は、既に登録されています' }
end