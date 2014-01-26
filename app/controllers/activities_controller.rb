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
  
  def graph
    begin
      @activity=Activity.find(params[:id]);
    rescue ActiveRecord::RecordNotFound => e
      return
    end
    max_points=200
    scale_factor=1

    @series={}

    if @activity.simple_elevation || @activity.elevation_series
    	@series[:elevation]={
    		color: '#666666',
    		name: "Elevation",
    		unit: "metres"
    	}
    	if  @activity.simple_elevation
    		@series[:elevation][:input]=@activity.simple_elevation.map{|e| e.round(2) if e }
    	else
    		@series[:elevation][:input]=JSON::parse(@activity.elevation_series).map{|e| e.round(2) if e }
    	end
    end

    if @activity.simple_hr || @activity.hr_series
    	@series[:hr]={
    		color: '#dd2222',
    		name: "Heart rate",
    		unit: "bpm"
    	}
    	if @activity.simple_hr
    		@series[:hr][:input]=@activity.simple_hr
    	else
    		@series[:hr][:input]=JSON::parse(@activity.hr_series)
    	end
    end

    @x_axis={}

    if @activity.simple_distance || @activity.distance_series
    	@x_axis[:title]='Distance'
    	@x_axis[:type]='linear'
    	if @activity.simple_distance
    		@x_axis[:series]=@activity.simple_distance.map{|d| d.to_i if d}
    	else
    		@x_axis[:series]=JSON::parse(@activity.distance_series).map{|d| d.to_i if d}
    	end
    else	
    	@x_axis[:title]='Time'
    	@x_axis[:type]='datetime'
    	if @activity.simple_time
    		@x_axis[:series]=@activity.simple_time
    	else
    		@x_axis[:series]=JSON::parse(@activity.time_series).map{ |d| DateTime.parse(d).strftime("%Q").to_i }
    	end
    end

    scale_factor=[@x_axis[:series].count/max_points,1].max.to_i

    # Join each input up to the time_series array using zip to get our plottable array
    # but only when the item itself isn't nil
    @series.each_value do |spec|
    	spec[:graph]=@x_axis[:series].zip(spec[:input]).select.with_index{|item,index| index%scale_factor==0 && item[0] && item[1]}
    end

    respond_to do |format|
      format.js do
        render
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
    #check if the user has uploaded this activity already
    answer=[]
    if params[:batch]
      JSON::parse(params[:batch]).each do |a|
        activity=current_user.activities.find_by(start_time: a["start_time"])
        if (activity)
          answer.push({id: activity.id, start_time: activity.start_time, internal_id: a["internal_id"]})
        else
          answer.push({id: -1, internal_id: a["internal_id"]})
        end
      end
    end
    respond_to do |format|
      format.json do
        render json: answer
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
    :hr_series, :pace_series, :gpx, :lat_long_series, :time_series, :distance_series)
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
