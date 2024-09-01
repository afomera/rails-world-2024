class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_if_authenticated, only: [ :new ]

  def new
  end

  def create
    if (user = User.authenticate_by(authentication_params))
      login(user)

      redirect_to root_path, notice: "Logged in."
    else
      flash[:error] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout

    redirect_to new_session_path, notice: "Logged out"
  end

  def authentication_params
    { email: params[:email].downcase, password: params[:password] }
  end
end
