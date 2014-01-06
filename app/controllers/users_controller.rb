class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :change_password]
  before_action :correct_user_or_admin, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    if current_user?(@user)
      @user_posts = @user.posts.includes(:user).paginate(page: params[:page])
    else
      @user_posts = @user.posts.not_draft.includes(:user).paginate(page: params[:page])
    end
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
    #Nothing needs to happen here because it's already getting the user id 
    #from signed_in_user
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def update
    # Exit point
    exit='edit'
    if params[:user][:password]
      exit='change_password'
      if !current_user.authenticate(params[:user][:old_password])
        flash.now[:danger]="Old password is incorrect"
        render 'change_password'
        return
      end
    end
    if @user.update_attributes(edit_user_params)
      flash[:success]="Profile changed"
      redirect_to @user
    else
      flash.now[:danger]="Error saving profile"
      render exit
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted."
    redirect_to users_url
  end
  
  def change_password
  end
  
  private  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :gravatar_email)
  end
  #Paramaters we're allowed to change through edit
  def edit_user_params
    params.require(:user).permit(:name, :email, :gravatar_email, :facebook_id, :google_plus, :password, :password_confirmation)
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless (current_user?(@user))
  end
  def correct_user_or_admin
    @user = User.find(params[:id])
    redirect_to(root_url) unless (is_admin? || current_user?(@user))
  end
end
