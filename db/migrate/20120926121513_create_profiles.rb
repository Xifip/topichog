class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.text :bio
      t.string :image
      t.string :twitter_url
      t.string :facebook_url
      t.string :linkedin_url
      t.string :mysite_url

      t.timestamps
    end
  end
end
