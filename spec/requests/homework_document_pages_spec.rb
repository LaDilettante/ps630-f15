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
        pending("no idea how to do this yet, since @doc is needed in 
          the edit page but is not available here")
      end
    end

    describe "as grader" do
      before { sign_in grader }
      describe "after deadline" do
        pending("no idea how to do this yet, since @doc is needed in 
          the edit page but is not available here")
      end
    end
  end
end
