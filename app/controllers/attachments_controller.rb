class AttachmentsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create]
  before_action :correct_user_or_admin, only: [:index, :destroy]
  def new
    @attachment=Attachment.new
  end
  
  def create
    @attachment=current_user.attachments.create(attachment_params)
    if @attachment.save
      #success!
      #just a placeholder as we'll switch to JSON uploading later
      flash[:success]="Save complete!"
      redirect_to root_url
    else
      flash[:danger]="Save failed"
      redirect_to root_url
    end
  end
  
  def destroy
    #TODO implement admin deletion here
    @attachment=current_user.attachments.find(params[:id])
    @attachment.destroy unless @attachment.nil?
  end
  
  def index
    #TODO, handle indexing differently for admin/non
    @attachments=Attachment.paginate(page: params[:page])
  end
  
  private
  def correct_user_or_admin
    
  end
  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
