class RefreshToken < ApplicationRecord
  TOKEN_BYTES = 32
  EXPIRATION = 30.days

  belongs_to :user

  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active, -> { where(revoked_at: nil).where("expires_at > ?", Time.current) }

  def self.digest(token)
    Digest::SHA256.hexdigest(token)
  end

  def self.issue_for!(user)
    raw_token = SecureRandom.urlsafe_base64(TOKEN_BYTES)
    refresh_token = create!(
      user: user,
      token_digest: digest(raw_token),
      expires_at: EXPIRATION.from_now
    )

    [ raw_token, refresh_token ]
  end

  def self.find_active(raw_token)
    active.find_by(token_digest: digest(raw_token))
  end

  def revoke!
    update!(revoked_at: Time.current)
  end
end
