class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::MimeResponds
  include RefreshTokenCookies
end
