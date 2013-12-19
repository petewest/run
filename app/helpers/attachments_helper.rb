module AttachmentsHelper
  
  def attachment_image(id, size= :large)
    begin
      attachment=Attachment.find(id)
    rescue ActiveRecord::RecordNotFound => e
      return ""
    end
    %Q{<img src="#{attachment.file.url(size)}" />}
  end
end
