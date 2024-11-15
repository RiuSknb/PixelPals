class AddColumnsToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :user_id, :integer, null: false
    add_column :events, :genre_id, :integer
    add_column :events, :game_id, :integer
    add_column :events, :group_id, :integer
    add_column :events, :title, :string
    add_column :events, :body, :text
    add_column :events, :place, :string
    add_column :events, :date, :datetime
    add_column :events, :post_type, :string
    add_column :events, :is_deleted, :boolean, default: false
    add_column :events, :deleted_by, :integer, default: 0

    add_index :events, :user_id
    add_index :events, :genre_id
    add_index :events, :game_id
    add_index :events, :group_id
  end
end