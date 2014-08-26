require 'spec_helper'

describe "HomeworkDocumentPages" do
  let(:assignment) { FactoryGirl.create(:assignment) }
  let(:submitter) { FactoryGirl.create(:student) }
  let(:grader) { FactoryGirl.create(:student) }
  let(:hw) do
    submitter.submitted_homework_documents.new(assignment_id: assignment.id, 
      ungraded_file: File.open(Rails.root + "spec/fixtures/documents/lab1.pdf"),
      grader_id: grader.id)
  end

  subject { page }

  describe "edit" do

    describe "as submitter" do
      before { sign_in submitter }
      describe "after deadline" do
        before do
          assignment.deadline = Time.now - 2.day
          assignment.save!
          visit edit_student_homework_document_path(
                        student_id: submitter.id, 
                        id: hw.id)
        end
        it { should_not have_title('Edit homework document') }
      end
    end

    describe "as grader" do
      before { sign_in grader }
      describe "after deadline" do
        before do
          assignment.deadline = Time.now - 2.day
          assignment.save!
          visit edit_student_homework_document_path(
                        student_id: submitter.id, 
                        id: hw.id)
        end
        it { should have_title("Edit homework document") }
      end
    end
  end
end
