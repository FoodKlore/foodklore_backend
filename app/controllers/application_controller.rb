# frozen_string_literal: true

# Handles application request
class ApplicationController < ActionController::API
  def authorize_entity
    # return true
    if decoded_auth_token
      @entity = if decoded_auth_token[:entity] == 'User'
                  User.find(decoded_auth_token[:auth_entity_id])
                else
                  Guest.find(decoded_auth_token[:auth_entity_id])
                end
      return @entity if @entity

      render json: 'Not found', status: 404
    else
      render json: 'Invalid token', status: :unprocessable_entity
    end
  end

  def decoded_auth_token
    JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    else
      render json: 'Missing Token', status: :unprocessable_entity
    end
  end

  def encode_message(payload)
    payload["token"] = Rails.application.credentials.secret_key_base
    crypt = ActiveSupport::MessageEncryptor.new generate_key
    crypt.encrypt_and_sign(ActiveSupport::JSON.encode(payload))
  end

  def decrypte_message(token)
    crypt = ActiveSupport::MessageEncryptor.new generate_key
    ActiveSupport::JSON.decode(crypt.decrypt_and_verify(token))
  end

  private

  def generate_key
    key = ActiveSupport::KeyGenerator.new(
      Rails.application.credentials.token[:password]
    ).generate_key(
      Rails.application.credentials.token[:salt], 32
    )
    key
  end
end
