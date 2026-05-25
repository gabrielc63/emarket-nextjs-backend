module V1
  class CurrentUsersController < APIController
    before_action :authenticate_user!

    def show
      render json: current_user.public_json
    end

    def update
      if current_user.update(current_user_params)
        render json: current_user.public_json, status: :ok
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_content
      end
    end

    private

    def current_user_params
      params.require(:user).permit(:name, :email)
    end
  end
end
