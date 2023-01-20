class ApplicationController < ActionController::API
    def encode_token(payload, exp=15.minutes.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, 'secret')
    end

    def decode_token
        auth_header = request.headers['Authorization']
        if auth_header
            token  = auth_header.split(' ')[1]
            begin
                JWT.decode(token, 'secret', true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def authorized_user
        decoded_token = decode_token()
        if decoded_token
            user_id = decode_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorize
        render json: {message: "You have to log in."}, status: :unauthorized unless
        authorized_user 
    end
end
