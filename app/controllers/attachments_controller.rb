class AttachmentsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy, :index]
  def new
    @attachment=Attachment.new
  end
  
  def create
  end
  
  def destroy
  end
  
  def index
    @attachments=Attachment.paginate(page: params[:page])
  end
end
