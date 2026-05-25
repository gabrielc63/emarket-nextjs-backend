module V1
  class RefreshTokensController < APIController
    def create
      raw_token = refresh_token_from_cookie
      refresh_token = raw_token.present? ? RefreshToken.find_active(raw_token) : nil

      return render json: { error: "Invalid refresh token" }, status: :unauthorized unless refresh_token

      user = refresh_token.user
      refresh_token.revoke!
      issue_refresh_token_cookie(user)

      sign_in(:user, user, store: false)
      render json: user.public_json, status: :ok
    end
  end
end
