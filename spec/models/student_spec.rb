require 'spec_helper'

describe Student do
  before { @student = Student.new(name: "Anh", email: "anh@gmail.com") }
  subject { @student }

  it { should respond_to :name }
  it { should respond_to :email }
end
