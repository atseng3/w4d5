module SessionsHelper

  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    return false if current_user.nil?
    session[:session_token] == current_user.session_token
  end

end