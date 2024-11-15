class AddColumnsToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :user_id, :integer, null: false
    add_column :comments, :commentable_id, :bigint, null: false
    add_column :comments, :commentable_type, :string, null: false
    add_column :comments, :body, :text, null: false
    add_column :comments, :is_deleted, :boolean, default: false
    add_column :comments, :deleted_by, :string
    add_column :comments, :deleted_reason, :text

    add_index :comments, [:commentable_type, :commentable_id], name: 'index_comments_on_commentable_type_and_commentable_id'
    add_index :comments, :user_id
  end
end
