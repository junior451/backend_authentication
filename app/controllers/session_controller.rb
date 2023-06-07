class SessionController < ApplicationController

  def login
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)

      render json: { token: token}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def login_params
    params.permit(:username, :password)
  end
end
