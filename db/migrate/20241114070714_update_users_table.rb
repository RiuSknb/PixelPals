class UpdateUsersTable < ActiveRecord::Migration[6.1]
  def change
      add_column :users, :name, :string, null: false
      add_column :users, :is_active, :boolean, default: true
      add_column :users, :status_reason, :text
  end
end
