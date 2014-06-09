require 'spec_helper'

describe Assignment do
  let(:assignment) { FactoryGirl.create(:assignment) }
  subject { assignment }

  it { should respond_to :deadline }
  it { should respond_to :homework_documents }
  it { should respond_to :grader }

  describe "must have a deadline" do
    before { assignment.deadline = nil }
    it { should be_invalid }
  end

  describe "can be listed as" do
    let(:closed) { FactoryGirl.create(:assignment, deadline: 25.hours.ago) }
    let(:open) { FactoryGirl.create(:assignment, deadline: 23.hours.ago) }

    describe "closed if past deadline for more than a day" do
      specify { expect(Assignment.closed).to include(closed) }
      specify { expect(Assignment.closed).not_to include(open) }
    end

    describe "open if not past deadline for more than a day" do
      specify { expect(Assignment.open).not_to include(closed) }
      specify { expect(Assignment.open).to include(open) }
    end
  end

  describe "must have a pool of grader" do
    let(:submitter) { FactoryGirl.create(:student) }

    before do 
      submitter.submitted_homework_documents.create(assignment_id: assignment.id,
        ungraded_file: File.open(Rails.root + "spec/fixtures/documents/midterm2_360.pdf"))
    end

    let(:non_submitter) { FactoryGirl.create(:student) }

    describe "that includes those who submitted" do
      its(:grader) { should include submitter }
    end

    describe "that does not include those who didn't submit" do
      its(:grader) { should_not include non_submitter }
    end
  end

  describe "can assign graders to homework_documents" do
    let(:submitter_1) { FactoryGirl.create(:student) }    
    let(:submitter_2) { FactoryGirl.create(:student) }
    let(:submitter_3) { FactoryGirl.create(:student) }
    before do
      [submitter_1, submitter_2, submitter_3].each do |submitter|
        submitter.submitted_homework_documents.create(assignment_id: assignment.id,
          ungraded_file: File.open(Rails.root + "spec/fixtures/documents/midterm2_360.pdf"))
      end
    end

    before { assignment.assign_homework_doc_to_grader }

    describe "without a student grading himself" do
      it "is a pending example"
      # its("homework_documents.each") do |hw_doc|
      #   hw_doc.submitter_id should_not eq hw_doc.grader_id
      # end
    end

    describe "with every document having a grader" do
      it "is a pending example"
    end

    describe "and be marked as graded afterward" do
      it { should be_graded }
    end
  end
end
