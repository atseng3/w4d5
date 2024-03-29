class UsersController < ApplicationController

  def new
    render :new
  end

  def create
    @user = User.new(params[:user])
    @user.reset_session_token!
    session[:session_token] = @user.session_token
    if @user.save
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages.first
      render :new
    end
  end
end