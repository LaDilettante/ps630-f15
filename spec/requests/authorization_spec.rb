require 'spec_helper'

describe "Authorization" do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  describe "non-signed in users" do

    describe "in the Users controller" do
      describe "cannot visit edit user page" do
        before { visit edit_user_path(user) }
        it { should have_title "Sign in" }
      end

      describe "cannot submit patch request to users#update" do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to signin_path }
      end
    end
  end

  describe "wrong current user" do
    let(:wrong_user) { FactoryGirl.create(:user) }
    before { sign_in wrong_user }

    describe "cannot see the edit link on profile page" do
      before { visit user_path(user) }
      it { should_not have_link "Edit your profile", href: edit_user_path(user) }
    end

    describe "cannot visit edit page" do
      before { visit edit_user_path(user) }
      it { should have_title "Home" }
    end

    describe "in the UsersController" do
      before { sign_in wrong_user, no_capybara: true }

      describe "cannot submit patch request to users#update" do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to root_path }
      end

      describe "cannot submit delete requiest to users#destroy" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to root_path }
      end
    end
  end
end