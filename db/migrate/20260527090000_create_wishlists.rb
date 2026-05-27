class CreateWishlists < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlists do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false, default: "Wishlist"

      t.timestamps
    end

    add_index :wishlists, [ :user_id, :name ], unique: true
  end
end
