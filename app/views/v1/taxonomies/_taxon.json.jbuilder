json.extract! taxon, :id, :name, :slug, :position, :created_at, :updated_at

json.children taxon.children do |child|
  json.partial! "v1/taxonomies/taxon", taxon: child
end
