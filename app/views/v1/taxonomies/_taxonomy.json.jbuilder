json.extract! taxonomy, :id, :name, :slug, :created_at, :updated_at

json.taxons taxonomy.taxons.roots do |taxon|
  json.partial! "v1/taxonomies/taxon", taxon: taxon
end
