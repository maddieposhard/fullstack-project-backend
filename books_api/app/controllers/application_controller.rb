class ApplicationController < ActionController::API
    def authenticate_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header

        if token.blank?
            return render json: { errors: 'Unauthorized' }, status: :unauthorized
        end

        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base).first
          @current_user = User.find(decoded['user_id'])
        rescue ActiveRecord::RecordNotFound
            render json: { error: 'User not found' }, status: :unauthorized
        rescue JWT::ExpiredSignature
          render json: { error: 'Token has expired' }, status: :unauthorized
        rescue JWT::DecodeError
          render json: { errors: 'Unauthorized' }, status: :unauthorized
        end
    end
end
