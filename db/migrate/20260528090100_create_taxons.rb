class CreateTaxons < ActiveRecord::Migration[8.0]
  def change
    create_table :taxons do |t|
      t.references :taxonomy, null: false, foreign_key: { on_delete: :cascade }
      t.references :parent, foreign_key: { to_table: :taxons, on_delete: :cascade }
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :taxons, :slug, unique: true
    add_index :taxons, [ :taxonomy_id, :parent_id, :position ]
  end
end
