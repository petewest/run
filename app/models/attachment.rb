class Attachment < ActiveRecord::Base
  has_attached_file :file, styles: {
    medium:"300x300>",
    large:"600x600>"
  }
end
