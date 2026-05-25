class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  ROLES = %w[customer seller admin].freeze

  devise :database_authenticatable,
    :registerable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: self

  has_many :allowlisted_jwts, dependent: :delete_all
  has_many :refresh_tokens, dependent: :delete_all

  validates :name, presence: true
  validates :role, inclusion: { in: ROLES }

  def public_json
    {
      id: id,
      name: name,
      email: email,
      role: role,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
