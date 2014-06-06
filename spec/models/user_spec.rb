require 'spec_helper'

describe User do
  
  let(:user) { FactoryGirl.build(:user, password: "foobar",
                                        password_confirmation: "foobar") }
  subject { user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :authenticate }

  describe "type differentiation" do
    let(:student) { FactoryGirl.create(:student) }
    let(:teacher) { FactoryGirl.create(:teacher) }
    specify { expect(student.student?).to eq true }
    specify { expect(teacher.teacher?).to eq true }
  end

  describe "authentication" do
    
    describe "password must be present" do
      before do
        user.password = " "
        user.password_confirmation = " "
      end
      it { should be_invalid }
    end

    describe "password must be at least 6 characters long" do
      before do
        user.password = "a" * 5
        user.password_confirmation = "a" * 5
      end
      it { should be_invalid }
    end

    describe "password confirmation must match" do
      before do
        user.password = "foo"
        user.password_confirmation = "bar"
      end
      it { should be_invalid }
    end

    describe "password authentication" do
      before { user.save }
      let(:user_attempt_signin) { User.find_by(email: user.email) }

      describe "can be authenticated with password" do
        it { should eq user_attempt_signin.authenticate(user.password) }
      end

      describe "cannot be authenticated with wrong password" do
        it { should_not eq user_attempt_signin.authenticate("wrong_password") }
        specify { expect(user_attempt_signin.authenticate("wrong_password")).to be_false }
      end
    end
  end
end
