class AddTopicIdToTopicdraftimages < ActiveRecord::Migration
  def change
    add_column :topicdraftimages, :topic_id, :integer  
  end
end
