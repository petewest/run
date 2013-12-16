module AttachmentsHelper
  
  def attachment_image(id)
    begin
      attachment=Attachment.find(id)
    rescue ActiveRecord::RecordNotFound => e
      return ""
    end
    %Q{<img src="#{attachment.file.url(:large)}" />}
  end
end
