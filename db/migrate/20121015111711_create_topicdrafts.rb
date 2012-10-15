class CreateTopicdrafts < ActiveRecord::Migration
  def change
    create_table :topicdrafts do |t|
      t.string   "title"
      t.string   "summary"
      t.integer  "user_id"
      t.text     "content"
      t.text     "reference"
      t.integer  "topic_id"
      t.boolean  "draft_ahead"
      
      t.timestamps
    end
  end
end
