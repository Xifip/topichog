class AddMyBlogToProfiles < ActiveRecord::Migration
  def change
  add_column :profiles, :myblog_url, :string
  end
end
