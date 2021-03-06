class Topicdraft < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list, :content, :reference,:draft_ahead, :image, :image_id
  
  acts_as_taggable_on :tags
    
  belongs_to :topic
  belongs_to :user
  has_many :topicdraftimages, dependent: :destroy
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 140 }
  validate :validate_tags#, :on => :create
  
  mount_uploader :image, TopicdraftimageUploader
  attr_accessor :image_id
  default_scope order: 'topicdrafts.created_at DESC' 

  def self.topicdrafts_unpublished_from(user)
    where("(user_id = :user_id) AND (draft_ahead = true)", user_id: user.id)
  end
  
  def validate_tags
    #debugger
    tags_number = self.tag_list.count
    errors.add(:tag_lists, 'you must include at least two tags') unless tags_number > 1
  end 
  
end
