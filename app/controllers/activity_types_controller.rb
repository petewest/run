class ActivityTypesController < ApplicationController
  before_action :admin_user
  before_action :get_activity_type_from_params, only: [:edit, :update, :destroy]
  
  def index
    @activity_types=ActivityType.all
  end
    
  def edit
    
  end
  
  def create
    @activity_type=ActivityType.new(activity_type_params)
    if @activity_type.save
      flash[:success]="New activity type #{@activity_type.name} created"
      redirect_to activity_types_path
    else
      flash.now[:danger]="Error creating activity type"
      render 'new'
    end
  end
  
  def destroy
  end
  
  def update
    if @activity_type.update_attributes(activity_type_params)
      flash[:success]="Activity updated"
      redirect_to activity_types_path
    else
      flash.now[:danger]="Error updating #{@activity_type.name}"
      render 'edit'
    end
  end
  
  def new
    @activity_type=ActivityType.new
  end
  
  private
  def get_activity_type_from_params
    @activity_type=ActivityType.find(params[:id])
  end
  def activity_type_params
    params.require(:activity_type).permit(:name, :identifier)
  end
end
