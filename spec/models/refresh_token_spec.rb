require "rails_helper"

RSpec.describe RefreshToken, type: :model do
  it "stores a digest instead of the raw token" do
    user = create(:user)

    raw_token, refresh_token = described_class.issue_for!(user)

    expect(refresh_token.token_digest).not_to eq(raw_token)
    expect(described_class.find_active(raw_token)).to eq(refresh_token)
  end

  it "does not find revoked tokens" do
    user = create(:user)
    raw_token, refresh_token = described_class.issue_for!(user)

    refresh_token.revoke!

    expect(described_class.find_active(raw_token)).to be_nil
  end
end
