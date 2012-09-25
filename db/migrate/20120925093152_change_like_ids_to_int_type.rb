class ChangeLikeIdsToIntType < ActiveRecord::Migration
  def change
    change_column :likes, :liker_id, :integer
    change_column :likes, :liked_id, :integer
  end

end
