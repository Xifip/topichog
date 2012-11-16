class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.boolean :mail_on_liker
      t.boolean :mail_on_follower_post
      t.boolean :mail_on_follower
      t.boolean :mail_monthly_update
      t.boolean :mail_new_features
      t.integer :user_id
      
      t.timestamps
    end
  end
end
