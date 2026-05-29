class CreateProductTaxons < ActiveRecord::Migration[8.0]
  def change
    create_table :product_taxons do |t|
      t.references :product, null: false, foreign_key: { on_delete: :cascade }
      t.references :taxon, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :product_taxons, [ :product_id, :taxon_id ], unique: true
  end
end
