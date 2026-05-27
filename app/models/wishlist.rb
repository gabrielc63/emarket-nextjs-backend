class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_items, dependent: :delete_all
  has_many :products, through: :wishlist_items

  validates :name, presence: true, length: { maximum: 80 }
  validates :name, uniqueness: { scope: :user_id }
end
