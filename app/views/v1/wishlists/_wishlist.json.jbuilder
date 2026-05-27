json.extract! wishlist, :id, :name, :created_at, :updated_at

json.items wishlist.wishlist_items do |wishlist_item|
  json.extract! wishlist_item, :id, :created_at, :updated_at
  json.product do
    json.partial! "v1/products/product", product: wishlist_item.product
  end
end
