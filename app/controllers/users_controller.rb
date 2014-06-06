class UsersController < ApplicationController
  before_action :force_user_to_sign_in, only: [:edit, :update, :index, :destroy]
  before_action :turn_away_wrong_user, only: [:edit, :update, :destroy]
  before_action :turn_away_non_teacher, only: [:destroy]
  
  def new
    @user = User.new
    @type_options = [['Student', 'Student'], ['Teacher', 'Teacher']]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the TA app"
      sign_in @user
      redirect_to @user
    else
      flash[:error] = "Something happened"
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile has been updated"
      redirect_to @user
    else
      flash.now[:error] = "Unable to save changes"
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:type, :name, :email, 
                                   :password, :password_confirmation)
    end

    def force_user_to_sign_in
      redirect_to signin_path, notice: "Please sign in" unless signed_in?
    end

    def turn_away_wrong_user
      @correct_user = User.find(params[:id])
      redirect_to root_path, notice: "You are not allowed to do that" unless current_user?(@correct_user) || current_user.teacher?
    end

    def turn_away_non_teacher
      redirect_to root_path, notice: "You are not allowed to do that" unless current_user.teacher?
    end
end
