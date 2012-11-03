class AddProjectIdToProjectdraftimages < ActiveRecord::Migration
 def change
    add_column :projectdraftimages, :project_id, :integer
  end
end
