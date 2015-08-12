class HomeworkDocumentsController < ApplicationController
  before_action :stop_submitter_late_edit, only: [:edit, :update]
  before_action :force_user_to_sign_in, :turn_away_non_teacher, only: [:index]
  
  def new
    @doc = HomeworkDocument.new(submitter_id: params[:student_id])
    @assignment_options = Assignment
      .open.map{ |a| ["Num #{a.id}, title #{a.title}", a.id] }
  end

  def create
    @doc = HomeworkDocument.new(doc_submitter_params)
    @doc.submitter_id = params[:student_id]
    if @doc.save
      flash[:success] = "Homework submitted"
      redirect_to student_path(@doc.submitter_id)
    else
      flash[:error] = "Homework has not been submitted"
      redirect_to new_student_homework_document_path(student_id: params[:student_id])
    end
  end

  def edit
    @doc = HomeworkDocument.find(params[:id])
  end

  def update
    @doc = HomeworkDocument.find(params[:id])
    @doc.user_id = current_user.id
    if @doc.submitter?(current_user.id)
      submitter_update(@doc)
    elsif @doc.grader?(current_user.id)
      grader_update(@doc)
    elsif current_user.teacher?
      teacher_update(@doc)
    end
  end

  def index
    @homework_documents = HomeworkDocument.all
  end

  private

    def doc_submitter_params
      params.require(:homework_document)
            .permit(:assignment_id, :content,
                    :ungraded_file, :ungraded_file_source_code)
    end

    def doc_grader_params
      # Use fetch to handle when user submit blank forms.
      # In that case, the param won't include the homework_document hash
      # http://stackoverflow.com/questions/31969508/form-for-does-not-pass-the-required-value-when-user-submits-blank-form
      params.fetch(:homework_document, {})
            .permit(:graded_file, :graded_file_source_code)
    end

    def doc_teacher_params
      params.require(:homework_document)
            .permit(:grade)
    end

    def submitter_update(doc)
      if doc.update_attributes(doc_submitter_params)
        flash[:success] = "Changes saved"
        redirect_to User.find(doc.submitter_id)
      else
        flash[:error] = "Changes not saved"
        render :edit
      end
    end

    def grader_update(doc)
      if doc.update_attributes(doc_grader_params)
        flash[:success] = "Grading submitted"
        UserMailer.notify_available_comment(User.find(doc.submitter_id), doc).deliver
        redirect_to current_user
      else
        flash.now[:error] = "Grading was not submitted"
        render :edit
      end
    end

    def teacher_update(doc)
      if doc.update_attributes(doc_teacher_params)
        flash[:success] = "Grading submitted"
        UserMailer.notify_available_grade(User.find(doc.submitter_id), doc).deliver
        redirect_to homework_documents_path
      else
        flash.now[:error] = "Grading was not submitted"
        render :edit
      end
    end

    def stop_submitter_late_edit
      doc = HomeworkDocument.find(params[:id])
      if (Time.now > doc.assignment.deadline + 1.day) && !current_user?(doc.grader) && !current_user.teacher?
        flash[:error] = "You are not allowed to edit this document"
        redirect_to root_path
      end
    end

    def force_user_to_sign_in
      redirect_to signin_path, notice: "Please sign in" unless signed_in?
    end

    def turn_away_non_teacher
      redirect_to root_path, notice: "You are not allowed to access that link" unless current_user.teacher?
    end
end
