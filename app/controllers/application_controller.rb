class ApplicationController < ActionController::API

    def authorize_entity
        # return true
        if decoded_auth_token

            unless decoded_auth_token[:entity] == 'User'
                @entity = Guest.find(decoded_auth_token[:auth_entity_id])
            else
                @entity = User.find(decoded_auth_token[:auth_entity_id])
            end

            if @entity
                return @entity
            else
                render json: 'Not found', status: 404
            end
        else
            render json: 'Invalid token', status: :unprocessable_entity
        end
    end

    def decoded_auth_token
        JsonWebToken.decode(http_auth_header)
    end

    def http_auth_header
        if request.headers['Authorization'].present?
            return request.headers['Authorization'].split(' ').last
        else
            render json: 'Missing Token', status: :unprocessable_entity
        end
    end
end
