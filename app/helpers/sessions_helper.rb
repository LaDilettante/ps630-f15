module SessionsHelper
  def sign_in(user)
    aha_token = User.new_raw_token
    user.update_attribute(:hashed_token, User.digest(aha_token))
    cookies.permanent[:remember_token] = aha_token
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    hashed_remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(hashed_token: hashed_remember_token)
  end

  def sign_out
    current_user.update_attribute(:hashed_token, User.digest(User.new_raw_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def signed_in?
    !current_user.nil?
  end
end
