class Topicdraftimage < ActiveRecord::Base
  attr_accessible :image, :topicdraft_id
  mount_uploader :image, TopicdraftimageUploader
  
  #before_create :default_name
  
  #def default_name
  #  self.name ||= File.basename(image.filename, '.*').titleize if image
  #end  
end
