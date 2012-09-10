class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :tposts, :name, :title
  end

  def down
    rename_column :tposts, :title, :name
  end
end
