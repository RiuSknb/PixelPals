class AddColumsToGroupMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :group_members, :status, :integer, default: 0, null: false
    change_column :group_members, :role, :integer, default: 2, null: false
  end
end
