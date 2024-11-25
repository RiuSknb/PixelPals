class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum role: { 開設者: 0, モデレーター: 1, メンバー: 2, 招待中: 3, 参加希望中:4 }
  enum status: { 承認待ち: 0, 承認済み: 1, 退会: 2, BAN: 3 , 了承待ち: 4}
end