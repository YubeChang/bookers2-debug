class AddIndexToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_index :favorites, [:user_id, :book_id], unique: true
  end
end
