class RemovePostTypeFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :post_type, :string
  end
end
