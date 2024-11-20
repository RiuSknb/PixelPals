class ChangeDeletedByToEnumInDiaries < ActiveRecord::Migration[6.0]
  def change
    # deleted_reasonカラムを追加
    add_column :diaries, :deleted_reason, :string

    # deleted_byカラムを削除
    remove_column :diaries, :deleted_by, :integer
  end
end