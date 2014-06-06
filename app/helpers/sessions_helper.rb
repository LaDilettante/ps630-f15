module SessionsHelper
  def sign_in(user)
    raw_token = User.new_raw_token
    user.update_attribute(:hashed_token, User.digest(raw_token))
    cookies.permanent[:remember_token] = raw_token
    self.current_user = user 
    # the last line can be commented out, since we redirect after signing in
    # and since we check current_user after each redirection, current_user is set correctly
    # this line make sure that current_user is set to user if we sign in without redirecting though
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    hashed_remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(hashed_token: hashed_remember_token)
    # @current_user ||= can also be commented out
    # because we can always find the current_user correctly based on the cookie's remember_token
  end

  def sign_out
    current_user.update_attribute(:hashed_token, User.digest(User.new_raw_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    current_user == user
  end
end
