class ActivitiesController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :index]
  before_action :correct_user_or_admin, only: [:destroy, :show, :edit, :update]
  
  def new
    @activity=Activity.new
  end
  
  def create
    respond_to do |format|
      format.json do
        @activity.new(new_activity_params)
        if @activity.save
          render json: {id: @activity.id, start_time: @activity.start_time, internal_id: params[:internal_id]}
        else
          #flash.now[:danger]="Error saving activity"
          render json: {id: -1, internal_id: params[:internal_id]}
        end
      end
    end
  end
  
  def destroy
    @activity.destroy
    flash[:success]="Activity deleted"
    redirect_to root_url
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @activity.update_attributes(edit_activity_params)
      flash[:success]="Activity updated"
    else
      flash.now[:danger]="Error updating activity"
    end
  end
  
  def index
    if params[:user_id] && is_admin?
      @activities=User.find(params[:user_id]).activities.paginate(page: params[:page])
    else
      @activities=current_user.activities.paginate(page: params[:page])
    end
  end
  
  def check_upload
    #TODO allow requests for multiple start times
    #check if the user has uploaded this activity already
    @activity=current_user.activities.find_by_start_time(params[:start_time])
    respond_to do |format|
      format.json do
        render json: {id: @activity.id, start_time: @activity.start_time, internal_id: params[:internal_id]} unless @activity.nil?
        render json: {id: -1, internal_id: params[:internal_id]} if @activity.nil?
      end
    end
  end
  
  private
  def new_activity_params
    params.require(:activity).permit(:distance, :duration, :start_time, :height_gain, :polyline, :time_series, :elevation_series,
    :hr_series, :pace_series, :gpx, :activity_type_id, :user_id)
  end
  def edit_activity_params
    params.require(:activity).permit(:activity_type_id)
  end
  def correct_user_or_admin
    if is_admin?
      @activity=Activity.find(params[:id])
    else
      @activity=current_user.activies.find(params[:id])
    end
    redirect_to root_url if @activity.nil?
  end
end
