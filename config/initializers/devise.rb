Devise.setup do |config|
  config.mailer_sender = "no-reply@emarket.local"

  require "devise/orm/active_record"

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth, :params_auth ]
  config.navigational_formats = []

  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", Rails.application.secret_key_base)
    jwt.dispatch_requests = [
      [ "POST", %r{^/v1/users$} ],
      [ "POST", %r{^/v1/users/sign_in$} ],
      [ "POST", %r{^/v1/refresh$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/v1/users/sign_out$} ]
    ]
    jwt.expiration_time = 15.minutes.to_i
  end
end
