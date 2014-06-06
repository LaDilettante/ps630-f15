class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:sessions][:email])
    if user && user.authenticate(params[:sessions][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = "Email or Password is invalid"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
