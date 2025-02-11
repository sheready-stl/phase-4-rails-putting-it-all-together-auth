class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :handle_blank_field

    def index
        render json: User.all, status: :ok
    end

    def create
        def create
            user = User.create!(user_params)
            if user.valid?
                session[:user_id] = user.id
                render json: user, status: :created
            else
                render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    def show
        user = User.find_by(id: session[:user_id])

        if user
            render json: user, status: :created
        else
            render json: { error: "Not authorized" }, status: :unauthorized
        end
    end


    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def handle_blank_field(invalid)
        render json: {error: invalid.record.errors}, status: :unprocessable_entity
    end
end
