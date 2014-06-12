require 'spec_helper'

describe "SignupPage" do

  before { visit signup_path }
  subject { page }

  it { should have_content 'Sign up' }

  describe "succesful sign up a student" do
    before do
      select "Student", from: "user[type]"
      fill_in "Name"                 , with: "abc"
      fill_in "Email"                , with: "abc@example.com"
      fill_in "Password"             , with: "foobar"
      fill_in "Confirmation", with: "foobar"
      click_button "Create account"
    end

    # it "should save that student" do
    #   expect( click_button "Sign up").to change(Student, :count).by(1)
    # end

    describe "saves that student to the database" do
      specify { expect(Student.where(name: "abc", email: "abc@example.com")).to exist }
    end

    describe "redirects to that student profile page" do
      it { should have_content "Profile" }
    end
  end

  describe "unsuccessful signup of a student" do
    before do
      select "Student", from: "user[type]"
      click_button "Create account"
    end

    describe "pops up a flash error message" do
      it { should have_selector "div.alert.alert-error" }
    end

    describe "redirects to the sign up form" do
      it { should have_content "Sign up" }
    end
  end
end
