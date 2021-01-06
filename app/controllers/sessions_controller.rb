class SessionsController < ApplicationController

  def new; end

  def create
    byebug
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    else
      flash.now[:alert] = 'Wrong login details'
      render 'new'
    end
  end

  def destroy; end
end
