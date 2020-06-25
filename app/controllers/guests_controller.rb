class GuestsController < ApplicationController
    before_action :set_guest, only: [:show, :update, :destroy]

    # GET /guests
    def index
        @guests = Guest.all

        render json: @guests
    end

    # GET /guests/1
    def show
        render json: @guest
    end

    # POST /guests
    def create
        # @guest = Guest.last
        @guest = Guest.new(guest_params)
        # # It has to be string because Int doesnt have emtpy method
        security_code = SecureRandom.random_number(9e5).to_i.to_s
        @guest.security_code = security_code
        if @guest.save
            # dispatch job sending an email
            key   = ActiveSupport::KeyGenerator.new(Rails.application.credentials.token[:password]).generate_key(Rails.application.credentials.token[:salt], 32)
            crypt = ActiveSupport::MessageEncryptor.new(key)
            payload = {
                :token => Rails.application.credentials.secret_key_base,
                :guest_token => @guest.guest_token,
            }
            encrypted_data = crypt.encrypt_and_sign(ActiveSupport::JSON.encode(payload))

            GuestMailer.with(guest: @guest, security_code: security_code, token: encrypted_data).authenticate.deliver_later
            # TODO: FE will then shows a "paste your security code here"
            # This will be the password
            render json: @guest, status: :created, location: @guest
        else
            render json: @guest.errors, status: :unprocessable_entity
        end
    end

    def authenticate
        if authenticate_params
            guest = Guest.where(guest_token: authenticate_params).first
            if !guest
                return render json: ["Not found"], status: 404
            end
            guest.authenticated = true
            if guest.save
                return render json: guest, status: :ok
            else
                return render json: ["Unprocessable entity"], status: :unprocessable_entity
            end
        end
    end

    # PATCH/PUT /guests/1
    def update
        if @guest.update(guest_params)
            render json: @guest
        else
            render json: @guest.errors, status: :unprocessable_entity
        end
    end

    # DELETE /guests/1
    def destroy
        @guest.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
        @guest = Guest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def guest_params
        params.require(:guest).permit(:email, :name)
    end

    def authenticate_params
        key   = ActiveSupport::KeyGenerator.new(Rails.application.credentials.token[:password]).generate_key(Rails.application.credentials.token[:salt], 32)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        token = ActiveSupport::JSON.decode(crypt.decrypt_and_verify(params[:token]))

        if token["token"] != Rails.application.credentials.secret_key_base
            render json: ["Tokens dont match"], status: :unprocessable_entity
            return nil
        else
            return token["guest_token"]
        end
    end
end
