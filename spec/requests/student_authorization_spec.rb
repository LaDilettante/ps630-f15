require 'spec_helper'

describe "Student" do
  let(:student) { FactoryGirl.create(:student) }
  let(:assignment) { FactoryGirl.create(:assignment) }
  before { sign_in student }

  subject { page }

  describe "cannot create assignment" do
    describe "via website" do
      before { visit new_assignment_path }
      it { should_not have_title("New assignment") }
      it { should have_content(student.name) }
    end

    describe "via a GET request to the Assignments#new action" do
      before { sign_in student, no_capybara: true }
      before { get edit_assignment_path(assignment) }
      specify { expect(response).to redirect_to(user_path(student)) }
    end
  end

  describe "cannot edit assignment" do
    describe "via website" do
      before { visit edit_assignment_path(assignment) }
      it { should_not have_title "Edit assignment" }
      it { should have_content(student.name) }
    end

    describe "via a PATCH request to the Assignments#update action" do
      before { sign_in student, no_capybara: true }
      before { patch assignment_path(assignment) }
      specify { expect(response).to redirect_to(user_path(student)) }
    end
  end
end
