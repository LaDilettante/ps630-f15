include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # sign in without using capybara by directly modifying cookie
    raw_token = User.new_raw_token
    cookies[:remember_token] = raw_token
    user.update_attribute(:hashed_token, User.digest(raw_token))
  else
    visit signin_path
    fill_in "Email"       , with: user.email
    fill_in "Password"    , with: user.password
    click_button "Sign in"
  end
end