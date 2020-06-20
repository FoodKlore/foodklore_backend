class UsersController < ApplicationController

    before_action :set_user, only: [:edit, :update, :show, :destroy]

    def index
        @users = User.all
        render json: @users
    end

    def create
        # I could also do
        # SecureRandom.random_number(9e5).to_i
        # To validate email
        end
        user = User.new(user_params)

        if user.save
            render json: user, status: :created
        else
            render json: user.errors, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :username, :nickname)
    end

    def set_user
        User.find_by_email(user_params[:email])
    end
end