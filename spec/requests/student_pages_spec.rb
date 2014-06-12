require 'spec_helper'

describe "StudentPages" do
  let(:first_student) { FactoryGirl.create(:student) }
  let(:student) { FactoryGirl.create(:student) }

  subject { page }

  describe "edit" do
    before do 
      sign_in student
      visit edit_user_path(student)
    end

    describe "page" do
      it { should have_content "Update your profile" }
      it { should have_title "Edit user" }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_title "Edit user" }
      it { should have_selector('div.alert.alert-error') }
    end

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new_email@example.com" }
      before do
        fill_in "Name"             , with: new_name
        fill_in "Email"            , with: new_email
        fill_in "Password"         , with: student.password
        fill_in "Confirmation"     , with: student.password
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_title "Profile" }
      specify { expect(student.reload.name).to eq new_name }
      specify { expect(student.reload.email).to eq new_email }
    end
  end
end