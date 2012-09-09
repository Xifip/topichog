class CreatePposts < ActiveRecord::Migration
  def change
    create_table :pposts do |t|
      t.string :title
      t.string :summary
      t.timestamps
    end
  end
end
