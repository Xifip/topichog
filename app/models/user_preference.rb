class UserPreference < ActiveRecord::Base
   attr_accessible :mail_on_follower_post, :mail_on_follower, 
                     :mail_monthly_update, :mail_new_features, :mail_on_liker
    
    belongs_to :user                 
    validates :user_id, :presence => true                 
end
