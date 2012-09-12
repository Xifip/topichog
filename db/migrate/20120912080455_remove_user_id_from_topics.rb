class RemoveUserIdFromTopics < ActiveRecord::Migration
 def change
    remove_column :topics, :user_id, :integer
  end
end
