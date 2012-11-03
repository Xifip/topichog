class Projectdraftimage < ActiveRecord::Base
  attr_accessible :image, :projectdraft_id
  mount_uploader :image, ProjectdraftimageUploader
  
  belongs_to :user
  belongs_to :projectdraft
  belongs_to :project
  def self.projectdraftimage_for_projectdraft(projectdraft)
    where("(projectdraft_id = :projectdraft_id)", projectdraft_id: projectdraft.id)
  end
  
  def self.projectdraftimage_for_project(project)
    where("(project_id = :project_id)", project_id: project.id)
  end
  #before_create :default_name
  
  #def default_name
  #  self.name ||= File.basename(image.filename, '.*').titleize if image
  #end  
end
