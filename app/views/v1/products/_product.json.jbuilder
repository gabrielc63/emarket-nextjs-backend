json.extract! product,
  :id,
  :name,
  :slug,
  :sku,
  :description,
  :price_cents,
  :currency,
  :stock_quantity,
  :status,
  :created_at,
  :updated_at

json.url v1_product_url(product, format: :json)
