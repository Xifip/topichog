class AddLikesColumns < ActiveRecord::Migration
  def change
    add_column :likes, :liker_id, :integer
    add_column :likes, :liked_id, :integer
  end
end
