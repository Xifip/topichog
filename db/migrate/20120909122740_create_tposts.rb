class CreateTposts < ActiveRecord::Migration
  def change
    create_table :tposts do |t|
      t.string :name
      t.string :summary
      t.timestamps
    end
  end
end
