class RemoveIndexFromProjects < ActiveRecord::Migration
   
   def change
    remove_index :projects, :name => "index_projects_on_user_id_and_created_at"
  end
end
