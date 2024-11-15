class RenamePostsToDiaries < ActiveRecord::Migration[6.1]
  def change
    rename_table :posts, :diaries
  end
end
