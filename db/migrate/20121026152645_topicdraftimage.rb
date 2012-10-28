class Topicdraftimage < ActiveRecord::Migration
  def change
    create_table :topicdraftimages do |t|
      t.string :image
      t.integer :topicdraft_id
      
      t.timestamps
    end
  end
end
