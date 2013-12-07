class SessionsController < ApplicationController
  
  def new
    @user=User.new
  end
  
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if (user && user.authenticate(params[:session][:password]))
      flash[:success]="Welcome back #{user.name}"
      sign_in(user, (params[:session][:remember].to_i==1))
      redirect_back_or user
    else
      flash.now[:error]="Authentication failed, please check username and password"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
