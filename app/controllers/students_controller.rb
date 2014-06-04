class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      flash[:success] = "Welcome to the TA app"
      redirect_to @student
    else
      flash[:error] = "Something happened"
      render :new
    end
  end

  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
    @submissions = @student.submitted_homework_documents
    @returns = @student.returned_homework_documents
  end

  private

    def student_params
      params.require(:student).permit(:name, :email)
    end
end
