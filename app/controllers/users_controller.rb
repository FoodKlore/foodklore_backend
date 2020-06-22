class UsersController < ApplicationController

    before_action :set_user, only: [:edit, :update, :show, :destroy]

    def index
        @users = User.all
        render json: @users
    end

    def authenticate
        if authenticate_params
            user = User.where(user_token: authenticate_params).first
            if !user
                return render json: ["Not found"], status: 404
            end
            user.email_confirmed = true
            if user.save
                return render json: user, status: :ok
            else
                return render json: ["Unprocessable entity"], status: :unprocessable_entity
            end
        end
    end

    def create
        # I could also do
        # SecureRandom.random_number(9e5).to_i
        # To validate email
        user = User.new(user_params)

        if user.save
            UserMailer.with(user: user).authenticate.deliver_later
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

    def authenticate_params
        # Send encripted security code
        # TODO: A single token will be passed and we need to decrypte it and separete it into token and guest token
        if params[:token] != Rails.application.credentials.secret_key_base
            render json: ["Invalid application token"], status: :unprocessable_entity
            return nil
        else
            return params[:user_token]
        end
    end
end