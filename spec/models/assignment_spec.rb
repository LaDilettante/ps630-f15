require 'spec_helper'

describe Assignment do
  let(:assignment) { FactoryGirl.create(:assignment) }
  subject { assignment }

  it { should respond_to :deadline }
  it { should respond_to :homework_documents }

  describe "must have a deadline" do
    before { assignment.deadline = nil }
    it { should be_invalid }
  end
end
