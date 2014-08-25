require 'spec_helper'

describe HomeworkDocument do
  let(:assignment) { FactoryGirl.create(:assignment) }
  let(:submitter) { FactoryGirl.create(:student) }
  let(:hw) do
    submitter.submitted_homework_documents.new(assignment_id: assignment.id, 
      ungraded_file: File.open(Rails.root + "spec/fixtures/documents/lab1.pdf"))
  end

  subject { hw }

  it { should respond_to :grader }
  it { should respond_to :submitter }
  it { should respond_to :assignment }
  it { should respond_to :grade }
  it { should respond_to :content }
  it { should respond_to :ungraded_file }
  it { should respond_to :graded_file }

  describe "must have an associated assignment" do
    before { hw.assignment = nil }
    it { should be_invalid }
  end

  describe "must have an associated submitter" do
    before { hw.submitter_id = nil }
    it { should be_invalid }
  end

  describe "must have an uploaded ungraded file" do
    before { hw.ungraded_file = nil }
    it { should be_invalid }
  end

  describe "must only have uploads of .doc, .pdf, and .tex" do
    it "is a pending example" do
    end
  end

  describe "submission" do
    describe "on time submission" do
      before do
        assignment.deadline = Time.now
        assignment.save!
        hw.created_at = 2.hours.ago
        hw.save!
      end
      
      specify { expect(hw.reload.penalty).to eq 0 }
    end

    describe "late submission within a day" do
      before do
        assignment.deadline = Time.now
        assignment.save!
        hw.created_at = 5.hours.from_now
        hw.save!
      end

      specify { expect(hw.reload.penalty).to eq 0.1 }
    end

    describe "late submission more than a day" do
      before do
        assignment.deadline = Time.now
        assignment.save!
        hw.created_at = 2.days.from_now
        hw.save!
      end

      specify { expect(hw.reload.penalty).to eq 1 }
    end
  end

  describe "edit can't be made past deadline" do
    before do
      assignment.deadline = Time.now
      assignment.save!
      hw.updated_at = assignment.deadline + 1.second
    end
    it { should be_invalid }
  end
end
