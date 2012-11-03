class AddUserToTopicdraftimages < ActiveRecord::Migration
  def change
    add_column :topicdraftimages, :user_id, :integer
  end
end
