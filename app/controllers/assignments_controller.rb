class AssignmentsController < ApplicationController
  before_action :turn_away_non_teacher, only: [:new, :edit, :update, :destroy]

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.deadline = parse_time_with_correct_zone(params[:assignment][:deadline])
    if @assignment.save
      User.all.active.each do |user|
        UserMailer.notify_new_assignment(@assignment, user).deliver!
      end
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
    @assignment.deadline = parse_time_with_correct_zone(params[:assignment][:deadline])
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
                    :max_grade, :document, :source_code,
                    :solution, :solution_source_code)
    end

    def turn_away_non_teacher
      redirect_to user_path(current_user), notice: "You are not allowed to do that" unless current_user.teacher?
    end
end
