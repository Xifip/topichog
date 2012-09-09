class Ppost < ActiveRecord::Base
  attr_accessible :title, :summary
  
  has_many :posts, as: :postable
end
