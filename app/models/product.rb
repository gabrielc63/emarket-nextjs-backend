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

  scope :active, -> { where(status: "active") }

  private

  def normalize_currency
    self.currency = currency.to_s.upcase if currency.present?
  end

  def set_slug
    self.slug = name.parameterize
  end
end
