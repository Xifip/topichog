class AddImageToProjectdrafts < ActiveRecord::Migration
  def change
    add_column :projectdrafts, :image, :string
  end
end
