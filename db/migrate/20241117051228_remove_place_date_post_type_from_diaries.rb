class RemovePlaceDatePostTypeFromDiaries < ActiveRecord::Migration[6.0]
  def change
    remove_column :diaries, :place, :string
    remove_column :diaries, :date, :datetime
    remove_column :diaries, :post_type, :string
  end
end
