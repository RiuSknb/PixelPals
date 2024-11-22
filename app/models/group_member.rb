class GroupMember < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :role, inclusion: { in: %w[owner moderator member] }
end
