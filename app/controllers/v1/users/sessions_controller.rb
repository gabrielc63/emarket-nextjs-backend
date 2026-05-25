module V1
  module Users
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_signed_out_user, only: :destroy

      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource, store: false)
        issue_refresh_token_cookie(resource)
        render json: resource.public_json, status: :ok
      end

      def destroy
        raw_token = refresh_token_from_cookie
        RefreshToken.find_active(raw_token)&.revoke! if raw_token.present?
        clear_refresh_token_cookie
        head :no_content
      end
    end
  end
end
