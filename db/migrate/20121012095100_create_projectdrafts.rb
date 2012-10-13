class CreateProjectdrafts < ActiveRecord::Migration
  def change
    create_table :projectdrafts do |t|
      t.string   "title"
      t.string   "summary"
      t.integer  "user_id"
      t.text     "content"
      t.text     "reference"
      t.integer  "project_id"
      
      t.timestamps
    end
  end
end


