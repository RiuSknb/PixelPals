class AddColumnsToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :owner_id, :integer, null: false
    add_column :groups, :genre_id, :integer
    add_column :groups, :game_id, :integer
    add_column :groups, :name, :string, null: false
    add_column :groups, :body, :text
    add_column :groups, :is_public, :boolean, default: true
    add_column :groups, :is_deleted, :boolean, default: false
    add_column :groups, :deleted_by, :string

    add_index :groups, :game_id
    add_index :groups, :genre_id
    add_index :groups, :owner_id
  end
end
