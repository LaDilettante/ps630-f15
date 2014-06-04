require 'spec_helper'

describe HomeworkDocument do
  let(:hw) { FactoryGirl.create(:homework_document) }
  subject { hw }

  it { should respond_to :grader }
  it { should respond_to :submitter }
  it { should respond_to :assignment }
  it { should respond_to :grade }
  it { should respond_to :content }

  describe "homework submission" do
    let(:assignment) { FactoryGirl.create(:assignment, deadline: 2.hours.ago) }
    before do 
      assignment.homework_documents.create(created_at: 1.hour.ago)
    end
    it "can be submitted even after deadline" do
      expect(assignment.homework_documents.count).to eq 1
    end
  end
end
