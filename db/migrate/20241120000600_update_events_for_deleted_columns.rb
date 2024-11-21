class UpdateEventsForDeletedColumns < ActiveRecord::Migration[6.0]
  def change
    # deleted_byカラムを削除
    remove_column :events, :deleted_by, :integer

    # deleted_reasonカラムを追加
    add_column :events, :deleted_reason, :string
  end
end

