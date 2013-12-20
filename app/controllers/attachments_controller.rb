class AttachmentsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :index]
  before_action :correct_user_or_admin, only: [:destroy]
  def new
    @attachment=Attachment.new
  end
  
  def create
    @attachment=current_user.attachments.create(attachment_params)
    result=@attachment.save
    respond_to do |format|
      format.json do
        if result
          render json: @attachment, only: [:id, :file_file_name], methods: [:file_url_thumb]
        else
          render json: {id: -1}
        end
      end
      format.html do
        if result
          #success!
          flash[:success]="Save complete!"
          redirect_to root_url
        else
          flash[:danger]="Save failed"
          redirect_to root_url
        end
      end
    end
  end
  
  def destroy
    #TODO implement admin deletion here
    @attachment=current_user.attachments.find(params[:id])
    @attachment.destroy unless @attachment.nil?
  end
  
  def index
    @attachments=current_user.attachments.last(20)
    respond_to do |format|
      format.json do
        render json: @attachments, only: [:id, :file_file_name ], methods: [:file_url_thumb]
      end
    end
  end
  
  private
  def correct_user_or_admin
    
  end
  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
