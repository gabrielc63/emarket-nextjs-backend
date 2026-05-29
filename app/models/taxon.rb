class Taxon < ApplicationRecord
  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  belongs_to :taxonomy
  belongs_to :parent, class_name: "Taxon", optional: true
  has_many :children, -> { order(position: :asc, name: :asc) },
    class_name: "Taxon",
    foreign_key: :parent_id,
    dependent: :destroy,
    inverse_of: :parent
  has_many :product_taxons, dependent: :delete_all
  has_many :products, through: :product_taxons

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :parent_belongs_to_same_taxonomy

  scope :roots, -> { where(parent_id: nil).order(position: :asc, name: :asc) }

  private

  def set_slug
    base_slug = parent ? "#{parent.slug}-#{name}" : name
    self.slug = base_slug.parameterize
  end

  def parent_belongs_to_same_taxonomy
    return if parent.blank? || taxonomy.blank? || parent.taxonomy_id == taxonomy_id

    errors.add(:parent, "must belong to the same taxonomy")
  end
end
