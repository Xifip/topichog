class AddReferenceToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :reference, :text
  end
end
