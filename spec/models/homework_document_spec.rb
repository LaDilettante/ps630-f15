require 'spec_helper'

describe HomeworkDocument do
  let(:assignment) { FactoryGirl.create(:assignment) }
  let(:hw) { assignment.homework_documents.create }

  subject { hw }

  it { should respond_to :grader }
  it { should respond_to :submitter }
  it { should respond_to :assignment }
  it { should respond_to :grade }
  it { should respond_to :content }

  describe "must have an associated assignment" do
    before { hw.assignment = nil }
    it { should be_invalid }
  end

  describe "submission" do
    describe "on time submission" do
      before do
        assignment.update_attributes(deadline: Time.now)
        hw.update_attributes(created_at: 2.hours.ago)
      end
      its(:penalty) { should eq 0 }
    end

    describe "late submission within a day" do
      before do
        assignment.update_attributes(deadline: Time.now)
        hw.update_attributes(created_at: 5.hours.from_now)
      end
      its(:penalty) { should eq 0.1 }
    end

    describe "late submission more than a day" do
      before do
        assignment.update_attributes(deadline: Time.now)
        hw.update_attributes(created_at: 2.days.from_now)
      end
      its(:penalty) { should eq 1 }
    end
  end
end
