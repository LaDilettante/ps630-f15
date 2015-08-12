require 'spec_helper'

describe "HomeworkDocumentPages" do
  let(:assignment) { FactoryGirl.create(:assignment) }
  let(:submitter) { FactoryGirl.create(:student) }
  let(:grader) { FactoryGirl.create(:student) }
  let(:hw) do
    submitter.submitted_homework_documents.new(assignment_id: assignment.id, 
      ungraded_file: File.open(Rails.root + "spec/fixtures/documents/lab1.pdf"),
      ungraded_file_source_code: File.open(Rails.root + "spec/fixtures/documents/lab1.Rnw"),
      grader_id: grader.id)
  end

  subject { page }

  describe "update" do
    before { hw.save! }

    describe "as grader" do
      before do 
        sign_in grader
        visit edit_student_homework_document_path(student_id: submitter, id: hw)
      end

      describe "after deadline" do
        pending("no idea how to do this yet, since @doc is needed in 
          the edit page but is not available here")
      end

      describe "invalid without graded file" do
        before do
          # fill_in "Grade", with: assignment.max_grade
          click_button "Submit grading"
        end
        it { should have_title "Edit homework document" }
        it { should have_selector('div.alert.alert-error') }
      end

      describe "valid with graded file" do
        before do
          # fill_in "Grade",                       with: assignment.max_grade
          attach_file "Graded file",             Rails.root + "spec/fixtures/documents/lab1.pdf"
          attach_file "Graded file source code", Rails.root + "spec/fixtures/documents/lab1.Rnw"
          click_button "Submit grading"
        end
        it { should have_title "Profile" }
        it { should have_selector 'div.alert.alert-success' }
      end
    end

    describe "as submitter" do
      before { sign_in grader }
      describe "after deadline" do
        pending("no idea how to do this yet, since @doc is needed in 
          the edit page but is not available here")
      end
    end
  end
end
