class HomeworkDocumentsController < ApplicationController
  def new
    @doc = HomeworkDocument.new(submitter_id: params[:student_id])
    @assignment_options = Assignment
      .all.map{ |a| ["Num #{a.id}, title #{a.title}", a.id] }
  end

  def create
    @doc = HomeworkDocument.new(doc_params)
    @doc.submitter_id = params[:student_id]
    if @doc.save
      flash[:success] = "Homework submitted"
      redirect_to student_path(@doc.submitter_id)
    else
      flash[:error] = "Homework has not been submitted"
      redirect_to new_student_homework_document_path(student_id: params[:student_id])
    end
  end

  private

    def doc_params
      params.require(:homework_document).permit(:assignment_id, :content)
    end
end
