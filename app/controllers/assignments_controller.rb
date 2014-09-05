class AssignmentsController < ApplicationController
  before_action :turn_away_non_teacher, only: [:new, :edit, :update, :destroy]

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.deadline = DateTime.strptime(params[:assignment][:deadline] + " Eastern Time (US & Canada)", "%m/%d/%Y %H:%M %Z").in_time_zone
    if @assignment.save
      flash[:success] = "Assignment posted"
      redirect_to @assignment
    else
      flash[:error] = "Homework has not been submitted"
      render :new
    end
  end

  def show
    @assignment = Assignment.find(params[:id])
  end

  def index
    @assignments = Assignment.all
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    @assignment.deadline = DateTime.strptime(params[:assignment][:deadline] + " Eastern Time (US & Canada)", "%m/%d/%Y %H:%M %Z").in_time_zone
    if @assignment.update_attributes(assignment_params)
      flash[:success] = "Assignment updated"
      redirect_to @assignment
    else
      flash.now[:error] = "Unable to save changes"
      render :edit
    end
  end

  def destroy
    Assignment.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_path
  end

  private

    def assignment_params
      params.require(:assignment)
            .permit(:title, :body,
                    :max_grade, :document, :source_code)
    end

    def turn_away_non_teacher
      redirect_to user_path(current_user), notice: "You are not allowed to do that" unless current_user.teacher?
    end
end
