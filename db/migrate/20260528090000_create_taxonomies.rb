class CreateTaxonomies < ActiveRecord::Migration[8.0]
  def change
    create_table :taxonomies do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :taxonomies, :slug, unique: true
  end
end
