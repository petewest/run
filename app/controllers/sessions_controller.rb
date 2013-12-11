class SessionsController < ApplicationController
  before_action :signed_in_user, only: [:index, :destroy]
  
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
      flash.now[:danger]="Authentication failed, please check username and password"
      render 'new'
    end
  end
  
  def destroy
    #allow them to delete other sessions if they want to
    if params[:id]
      #retrieve the session info
      session=Session.find(params[:id])
      user=session.user
      #if the user is an admin, or if the current owner of the session
      if (session && (is_admin? || current_user?(user)))
        #delete it
        session.destroy
        #Tell the user it's gone
        flash[:success]="Session logged off"
        #and redirect.  If it's the current session they'll get redirected to signin :)
        redirect_to user_sessions_path(user)
      end
    else
      #otherwise just sign out the current session
      sign_out
      redirect_to root_url
    end
  end
  
  def index
    if is_admin?
      @sessions=User.find(params[:user_id]).sessions.paginate(page: params[:page])
    else
      @sessions=current_user.sessions.paginate(page: params[:page])
    end
  end
end
