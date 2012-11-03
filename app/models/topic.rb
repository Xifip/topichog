class Topic < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list, :content, :reference, :image
  
  has_many :posts, as: :postable, :dependent => :destroy
  has_one :topicdraft, dependent: :destroy
  has_many :topicdraftimages, dependent: :destroy
  
  acts_as_taggable_on :tags
  
  mount_uploader :image, TopicdraftimageUploader
  
  default_scope order: 'topics.created_at DESC'  

end
