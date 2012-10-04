class AddReferenceToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :reference, :text
  end
end
