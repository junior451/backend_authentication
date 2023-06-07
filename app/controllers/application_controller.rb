class ApplicationController < ActionController::API

  private

  def authorise_request!
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    @decoded = JsonWebToken.decode(header)
    @current_user = User.find(@decoded[:user_id])
  end
end
