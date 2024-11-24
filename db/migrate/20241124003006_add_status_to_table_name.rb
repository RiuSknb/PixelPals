class AddStatusToTableName < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :status, :string
  end
end
