class ChangeColumsToGroupMembers < ActiveRecord::Migration[6.1]
  def change
    change_column :group_members, :role, :integer, default: 3, null: false # 招待中の状態にデフォルト設定
  end
end
