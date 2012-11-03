class Topicdraftimage < ActiveRecord::Base
  attr_accessible :image, :topicdraft_id
  mount_uploader :image, TopicdraftimageUploader
  
  belongs_to :user
  belongs_to :topicdraft
  belongs_to :topic
  def self.topicdraftimage_for_topicdraft(topicdraft)
    where("(topicdraft_id = :topicdraft_id)", topicdraft_id: topicdraft.id)
  end
  
  def self.topicdraftimage_for_topic(topic)
    where("(topic_id = :topic_id)", topic_id: topic.id)
  end
  #before_create :default_name
  
  #def default_name
  #  self.name ||= File.basename(image.filename, '.*').titleize if image
  #end  
end
