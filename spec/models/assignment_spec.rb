require 'spec_helper'

describe Assignment do
  before { @assignment = FactoryGirl.create(:assignment) }
  subject { @assignment }

  it { should respond_to :deadline }
  it { should respond_to :homework_documents }
end
