require 'spec_helper'

describe "SigninPage" do
  let(:user) { FactoryGirl.create(:user, email: "foo@bar.com",
                                     password: "foobar",
                                     password_confirmation: "foobar") }

  subject { page }

  describe "signing in" do
    before { visit signin_path }
    it { should have_content 'Sign in' }

    describe "with invalid password" do
      before do
        fill_in "Email"     , with: user.email
        fill_in "Password"  , with: "wrong_password"
        click_button "Sign in"
      end

      it { should have_selector 'div.alert.alert-error'}
    end

    describe "with valid password" do
      before do
        fill_in "Email"     , with: user.email
        fill_in "Password"  , with: user.password_confirmation
        click_button "Sign in"
      end

      describe "redirects to profile page" do
        it { should have_content 'Profile' }
        it { should_not have_link signin_path }
        it { should have_link "Sign out", href: signout_path }
      end

      describe "can then sign out" do
        before { click_link "Sign out" }
        it { should have_title "Home" }
      end
    end
  end
end
