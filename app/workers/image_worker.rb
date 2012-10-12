class ImageWorker
  include Sidekiq::Worker
   
  def perform(id, key)
    painting = Painting.find(id)
    painting.key = key
    painting.remote_image_url = painting.image.direct_fog_url(with_path: true)
    painting.save!
    painting.update_column(:image_processed, true)
  end
end
