class ActivitiesController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :index, :check_upload]
  before_action :correct_user_or_admin, only: [:destroy, :edit, :update]
  
  def new
    @activity=Activity.new
  end

  def show
    begin
      @activity=Activity.find(params[:id]);
    rescue ActiveRecord::RecordNotFound => e
      return
    end
    respond_to do |format|
      format.json do
        render json: @activity, only: [:id, :polyline]
      end
    end
  end
  
  def create
    respond_to do |format|
      format.json do
        activity_type=ActivityType.find_by_identifier(params[:activity_type])
        #time_series=JSON::parse(params[:time_series])
        #allow all the safe ones from new_activity_params, and add the activity id from the lookup
        constructed_params=new_activity_params.merge({activity_type_id: activity_type.id})
        @activity=current_user.activities.build(constructed_params)
        #@activity.time_series=time_series
        if @activity.save
          render json: {id: @activity.id, start_time: @activity.start_time, internal_id: params[:internal_id]}
        else
          #flash.now[:danger]="Error saving activity"
          render json: {id: -1, errors: @activity.errors.full_messages, internal_id: params[:internal_id]}
        end
      end
    end
  end
  
  def destroy
    @activity.destroy
    flash[:success]="Activity deleted"
    redirect_to root_url
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
  
  #Only function on this controller that's open to everyone
  def map
    @activity=Activity.find(params[:id])
  end
  
  private
  def new_activity_params
    params.permit(:distance, :duration, :start_time, :height_gain, :polyline, :elevation_series,
    :hr_series, :pace_series, :gpx, :lat_long_series, :time_series)
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
