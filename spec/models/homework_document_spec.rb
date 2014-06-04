require 'spec_helper'

describe HomeworkDocument do
  before { @hwrk = HomeworkDocument.new(grader_id: 1, submitter_id: 2, grade: 90) }
  subject { @hwrk }

  it { should respond_to :grader }
  it { should respond_to :submitter }
end
