class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :group_members, dependent: :destroy
  has_many :members, through: :group_members, source: :user

  validates :name, presence: true
end