require 'spec_helper'

describe "AssignmentPages" do
  
  subject { page }

  let(:assignment) { FactoryGirl.create(:assignment, title: "Sample assignment") }
  let(:student) { FactoryGirl.create(:student) }
  let(:teacher) { FactoryGirl.create(:teacher) }

  before { sign_in student }

  describe "show" do
    before do
      visit assignment_path(assignment)
    end

    describe "page" do
      it { should have_title(assignment.title) }
      it { should have_content(assignment.title) }
      it { should have_content(assignment.body) }

      describe "have link for students to submit" do
        it { should have_link('Submit your work') }
      end

      describe "have link for teacher to edit" do
        before do 
          sign_in teacher
          visit assignment_path(assignment)
        end
        it { should have_link('Edit assignment') }
      end
    end
  end

  describe "index" do
    before do
      FactoryGirl.create(:assignment, title: "Assignment 1")
      FactoryGirl.create(:assignment, title: "Assignment 2")
      visit assignments_path
    end

    it { should have_title('All assignments') }
    it { should have_content('All assignments') }

    it "should list each assignment" do
      Assignment.all.each do |assignment|
        expect(page).to have_selector('td', text: assignment.title)
      end
    end
  end

  describe "edit" do
    before do
      sign_in teacher
      visit edit_assignment_path(assignment)
    end

    describe "page" do
      it { should have_content("Edit assignment") }
      it { should have_title("Edit assignment") }
    end

    describe "with invalid information" do
      before do
        fill_in "Title", with: ""
        fill_in "Deadline", with: "03/22/2014" # Deadline is correct
        click_button "Save changes"
      end
      it { should have_content('error') }
    end
  end
end
