class RenameMessagesToGroupMessages < ActiveRecord::Migration[6.0]
  def change
    rename_table :messages, :group_messages
  end
end
