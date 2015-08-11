class HomeworkDocumentsController < ApplicationController
  before_action :stop_submitter_late_edit, only: [:edit, :update]
  
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
    end
  end

  private

    def doc_submitter_params
      params.require(:homework_document)
            .permit(:assignment_id, :content,
                    :ungraded_file, :ungraded_file_source_code)
    end

    def doc_grader_params
      params.require(:homework_document)
            .permit(:grade, :graded_file, :graded_file_source_code)
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
        redirect_to User.find(doc.grader_id)
      else
        flash.now[:error] = "Grading was not submitted"
        render :edit
      end
    end

    def stop_submitter_late_edit
      doc = HomeworkDocument.find(params[:id])
      if (Time.now > doc.assignment.deadline + 1.day) & !current_user?(doc.grader)
        flash[:error] = "You are not allowed to edit this document"
        redirect_to root_path
      end
    end
end
