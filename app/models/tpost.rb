class Tpost < ActiveRecord::Base
  attr_accessible :name, :summary
  
  has_many :posts, as: :postable
end
