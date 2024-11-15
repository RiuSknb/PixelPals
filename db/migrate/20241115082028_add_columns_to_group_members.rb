class AddColumnsToGroupMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :group_members, :group_id, :integer, null: false
    add_column :group_members, :user_id, :integer, null: false
    add_column :group_members, :role, :string, default: "member", null: false

    add_index :group_members, [:group_id, :user_id], unique: true, name: 'index_group_members_on_group_id_and_user_id'
    add_index :group_members, :group_id, name: 'index_group_members_on_group_id'
    add_index :group_members, :user_id, name: 'index_group_members_on_user_id'
  end
end