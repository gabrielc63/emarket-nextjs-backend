class Taxonomy < ApplicationRecord
  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  has_many :taxons, dependent: :delete_all

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  private

  def set_slug
    self.slug = name.parameterize
  end
end
