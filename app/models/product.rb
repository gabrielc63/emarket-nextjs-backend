class Product < ApplicationRecord
  STATUSES = %w[draft active archived].freeze

  before_validation :normalize_currency
  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :sku, uniqueness: true, allow_blank: true
  validates :description, length: { maximum: 2_000 }, allow_blank: true
  validates :price_cents,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :currency, presence: true, length: { is: 3 }
  validates :stock_quantity,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }

  has_many :wishlist_items, dependent: :delete_all
  has_many :product_taxons, dependent: :delete_all
  has_many :taxons, through: :product_taxons

  scope :active, -> { where(status: "active") }
  scope :for_taxon_slug, ->(taxon_slug) {
    taxon_ids = Taxon.self_and_descendant_ids_for_slug(taxon_slug)

    taxon_ids.any? ? joins(:product_taxons).where(product_taxons: { taxon_id: taxon_ids }).distinct : none
  }

  private

  def normalize_currency
    self.currency = currency.to_s.upcase if currency.present?
  end

  def set_slug
    self.slug = name.parameterize
  end
end
