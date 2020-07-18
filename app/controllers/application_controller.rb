# frozen_string_literal: true

# Handles application request
class ApplicationController < ActionController::API
  def authorize_entity
    if decoded_auth_token
      @entity = if decoded_auth_token[:entity] == 'User'
                  User.find(decoded_auth_token[:auth_entity_id])
                else
                  Guest.find(decoded_auth_token[:auth_entity_id])
                end
      return {
        response: true,
        entity: @entity
      } if @entity

      raise ActionController::RoutingError.new('Not Found')
    else
      # BadRequest, InvalidAuthenticityToken, InvalidCrossOriginRequest, MethodNotAllowed, MissingFile, RenderError, RoutingError, SessionOverflowError, UnknownController, UnknownFormat, UnknownHttpMethod
      # 656444
      raise ActionController::InvalidAuthenticityToken.new("Invalid Token")
    end
  end

  def decoded_auth_token
    JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    else
      raise ActionController::InvalidAuthenticityToken.new("Missing Token")
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

  def checkout_params
    params.require(:checkout).permit(:email, :name)
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
