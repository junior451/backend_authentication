class ApplicationController < ActionController::API

  private

  def authorise_request!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue JWT::VerificationError, ActiveRecord::RecordNotFound
      render json: { error: 'request denied' }, status: :unauthorized
    end
  end
end
