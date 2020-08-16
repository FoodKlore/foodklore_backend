# frozen_string_literal: true

# Handles all user requests
class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]

  def index
    @users = User.all
    render json: @users
  end

  def authenticate
    return unless authenticate_params

    user = User.where(user_token: authenticate_params).first
    return render json: ['Not found'], status: 404 unless user

    user.email_confirmed = true
    unless user.save
      return render json: ['Unprocessable entity'], status: :unprocessable_entity
    end

    render json: user, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      encrypted_data = encode_message({ user_token: user.user_token })
      UserMailer.with(
        user: user, user_token: encrypted_data, redirect_url: redirectUrl_params[:path]
      ).authenticate.deliver_later
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
    token = CGI.unescape params[:token]
    token = decrypte_message token
    unless token['token'] != Rails.application.credentials.secret_key_base
      return token['user_token']
    end

    render json: ['Tokens dont match'], status: :unprocessable_entity
    nil
  end
end
