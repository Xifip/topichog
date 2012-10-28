class AddImageToTopicdrafts < ActiveRecord::Migration
  def change
    add_column :topicdrafts, :image, :string
  end
end
