class UsersController < ApplicationController
  def new
    @user = User.new
    @type_options = [['Student', 'Student'], ['Teacher', 'Teacher']]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the TA app"
      redirect_to @user
    else
      flash[:error] = "Something happened"
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:type, :name, :email, 
                                   :password, :password_confirmation)
    end
end
