class CreateRemoveModels < ActiveRecord::Migration
  def change
    drop_table :topicalts 
    drop_table :projectalts
    drop_table :feeds 
  end
end
