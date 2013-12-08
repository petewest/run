class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index]
  before_action :correct_user_or_admin, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #This (might) handle creating users as admin without logging the admin out?
      #it seems to! although we need some more logic to make the screens make sense
      if signed_in?
        flash[:success]="New user (#{@user.name}) created by #{current_user.name}"
      else
        sign_in @user
        flash[:success]="Welcome to the site, #{@user.name}!"
      end
        
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def update
    if @user.update_attributes(edit_user_params)
      flash[:success]="Profile edited"
      redirect_to @user
    else
      flash.now[:error]="Error saving profile"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted."
    redirect_to users_url
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :gravatar_email)
  end
  #Paramaters we're allowed to change through edit (without requiring password confirmation)
  def edit_user_params
    params.require(:user).permit(:name, :email, :gravatar_email)
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless (current_user?(@user))
  end
  def correct_user_or_admin
    @user = User.find(params[:id])
    redirect_to(root_url) unless (is_admin? || current_user?(@user))
  end
  def admin_user
    redirect_to(root_url) unless is_admin?
  end
end
