
module Auth
    class JwtController < ApplicationController
        before_action :authorize_entity
        def create
            @auth_entity = auth_entity
            if @auth_entity.is_a? User
                token = JsonWebToken.encode(auth_entity_id: @auth_entity.id, entity: 'User')
                render json: { token: token }, status: :ok
            elsif @auth_entity.is_a? Guest
                token = JsonWebToken.encode(auth_entity_id: @auth_entity.id, entity: 'Guest')
                render json: { token: token }, status: :ok
            else
                render json: 'Account not authorize correctly', status: :unauthorized
            end
        end

        def logout

        end

        def is_logged_in?
            if authorize_entity[:response]
                render json: authorize_entity[:entity]
            end

            render json: @entity
        end

        private

        def jwt_params
            params.require(:auth_entity).permit(:username, :authenticable, :password)
        end

        def auth_entity
            if jwt_params[:authenticable].is_a? Integer
                guest = Guest.where(id: jwt_params[:authenticable], authenticated: true).first
                return guest if guest && guest.authenticate_security_code(jwt_params[:password])
            else
                user = User.find_by_email(jwt_params[:authenticable])
                return user if user && user.authenticate(jwt_params[:password])
            end
        end
    end
end