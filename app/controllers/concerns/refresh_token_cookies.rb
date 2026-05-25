module RefreshTokenCookies
  extend ActiveSupport::Concern

  REFRESH_TOKEN_COOKIE = :emarket_refresh_token

  private

  def issue_refresh_token_cookie(user)
    raw_token, = RefreshToken.issue_for!(user)

    cookies[REFRESH_TOKEN_COOKIE] = {
      value: raw_token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: RefreshToken::EXPIRATION.from_now
    }
  end

  def refresh_token_from_cookie
    cookies[REFRESH_TOKEN_COOKIE]
  end

  def clear_refresh_token_cookie
    cookies.delete(
      REFRESH_TOKEN_COOKIE,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    )
  end
end
