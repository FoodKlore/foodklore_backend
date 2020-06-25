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
        user = User.new(user_params)

        if user.save
            key   = ActiveSupport::KeyGenerator.new(Rails.application.credentials.token[:password]).generate_key(Rails.application.credentials.token[:salt], 32)
            crypt = ActiveSupport::MessageEncryptor.new(key)
            payload = {
                :token => Rails.application.credentials.secret_key_base,
                :user_token => user.user_token,
            }
            encrypted_data = crypt.encrypt_and_sign(ActiveSupport::JSON.encode(payload))
            UserMailer.with(user: user, user_token: encrypted_data).authenticate.deliver_later
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
        key   = ActiveSupport::KeyGenerator.new(Rails.application.credentials.token[:password]).generate_key(Rails.application.credentials.token[:salt], 32)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        token = ActiveSupport::JSON.decode(crypt.decrypt_and_verify(params[:token]))

        if token["token"] != Rails.application.credentials.secret_key_base
            render json: ["Tokens dont match"], status: :unprocessable_entity
            return nil
        else
            return token["user_token"]
        end
    end
end