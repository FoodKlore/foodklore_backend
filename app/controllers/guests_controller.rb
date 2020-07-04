# frozen_string_literal: true

# Handles guests requests
class GuestsController < ApplicationController
  before_action :set_guest, only: %i[show update destroy]

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
    security_code = SecureRandom.random_number(9e5).to_i.to_s # .to_s is needed for secure password
    @guest.security_code = security_code
    if @guest.save
      encrypted_data = encode_message({ guest_token: @guest.guest_token })
      GuestMailer.with(guest: @guest, security_code: security_code,
                       token: encrypted_data).authenticate.deliver_later
      render json: @guest, status: :created, location: @guest
    else
      render json: @guest.errors, status: :unprocessable_entity
    end
  end

  def authenticate
    return unless authenticate_params

    guest = Guest.where(guest_token: authenticate_params).first
    return render json: ['Not found'], status: 404 unless guest

    guest.authenticated = true
    return render json: guest, status: :ok if guest.save

    render json: ['Unprocessable entity'], status: :unprocessable_entity
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
    token = decrypte_message params[:token]
    unless token['token'] != Rails.application.credentials.secret_key_base
      return token['guest_token']
    end

    render json: ['Tokens dont match'], status: :unprocessable_entity
    nil
  end
end
