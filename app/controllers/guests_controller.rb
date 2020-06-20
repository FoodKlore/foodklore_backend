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
        @guest = Guest.new(guest_params)
        # It has to be string because Int doesnt have emtpy method
        security_code = SecureRandom.random_number(9e5).to_i.to_s
        @guest.security_code = security_code
        if @guest.save
        # dispatch job sending an email
        GuestMailer.with(guest: @guest, security_code: security_code).authenticate.deliver_later
        # TODO: FE will then shows a "paste your security code here"
            render json: @guest, status: :created, location: @guest
        else
            render json: @guest.errors, status: :unprocessable_entity
        end
    end

    def authenticate
        bo = BasicObject.new(guest_params)
        if bo.authenticated
            guest = Guest.find(bo.guest_id)
            if guest.save(:authenticated => true)
                render json: guest, status: :created
            else
                render json: guest.errors, status: :unprocessable_entity
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
        # Send encripted security code
        params.require(:authenticable_payload).permit(:guest_id, :authenticated)
    end
end
