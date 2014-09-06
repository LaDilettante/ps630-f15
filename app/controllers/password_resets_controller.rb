class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    @user.send_password_reset if @user
    redirect_to root_path
    flash[:notice] = "Instruction to reset password has been sent to your email."
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to root_path
      flash[:error] = "Your password reset link has expired"
    elsif @user.update_attributes(user_params)
        UserMailer.notify_successful_password_reset(@user).deliver!
        flash[:success] = "Your password has been reset"
        redirect_to @user
    else
      flash.now[:error] = "Unable to reset your password"
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
