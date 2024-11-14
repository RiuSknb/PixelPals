class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :genre_id
      t.integer :game_id
      t.integer :group_id
      t.string :title
      t.text :body
      t.string :place
      t.datetime :date
      t.string :post_type
      t.boolean :is_deleted, default: false
      t.integer :deleted_by, default: 0
      t.timestamps precision: 6, null: false
    end

    # インデックスの追加
    add_index :posts, :game_id
    add_index :posts, :genre_id
    add_index :posts, :group_id
    add_index :posts, :user_id
  end
end
