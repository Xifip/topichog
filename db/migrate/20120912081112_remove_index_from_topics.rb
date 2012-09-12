class RemoveIndexFromTopics < ActiveRecord::Migration
   def change
    remove_index :topics, :name => "index_topics_on_user_id_and_created_at"

  end

end
