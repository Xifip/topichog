class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index :posts, [:postable_id, :postable_type]
  end
end
