class Game < ApplicationRecord
  belongs_to :genre
  has_many :diaries
  has_many :events

  validates :name, presence: { message: 'ゲーム名を空欄にすることはできません' }
  validates :name, uniqueness: { scope: :genre_id, message: '入力されたゲーム名は、既にそのジャンルで登録されています' }
end