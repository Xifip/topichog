class CreateProjectdraftimages < ActiveRecord::Migration
  def change
    create_table :projectdraftimages do |t|
      t.string :image
      t.integer :projectdraft_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
