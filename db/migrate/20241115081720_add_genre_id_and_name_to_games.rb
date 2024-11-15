class AddGenreIdAndNameToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :genre_id, :integer, null: false
    add_column :games, :name, :string, null: false

    add_index :games, :genre_id
  end
end