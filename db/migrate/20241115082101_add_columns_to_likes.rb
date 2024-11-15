class AddColumnsToLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :likes, :user_id, :integer, null: false
    add_column :likes, :likeable_id, :bigint, null: false
    add_column :likes, :likeable_type, :string, null: false

    add_index :likes, [:likeable_type, :likeable_id], name: 'index_likes_on_likeable_type_and_likeable_id'
    add_index :likes, [:user_id, :likeable_id, :likeable_type], unique: true, name: 'index_likes_on_user_id_and_likeable_id_and_likeable_type'
    add_index :likes, :user_id, name: 'index_likes_on_user_id'
  end
end