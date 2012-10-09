class Avatar < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.integer :user_id
      t.string :image
  
      t.timestamps
    end
  end
end
