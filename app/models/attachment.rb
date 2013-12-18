class Attachment < ActiveRecord::Base
  has_attached_file :file, styles: {
    medium:"300x300>",
    large:"600x600>",
    thumb:"100x100>"
  }
  
  belongs_to :user
  
  #set the default sort order 
  default_scope -> { order('created_at DESC')}
  
  #retrieve the URL from the file (used in json: renders)
  def file_url_thumb
    file.url(:thumb)
  end
end
