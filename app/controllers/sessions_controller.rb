class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if !!@user
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      @user.save!
      redirect_to cats_url
    else
      flash.now[:errors] = "Enter the right credentails!"
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    current_user.save!
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
