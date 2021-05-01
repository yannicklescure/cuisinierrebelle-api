class CreateUnsplashImagesJsonCacheJob < ApplicationJob
  queue_as :default

  def perform(*_args)

    @unsplash_images = UnsplashImage.all
    @unsplash_images.each do |image|
      image.destroy
    end

    @unsplash = Unsplash::Photo.search("cooking").sample
    @unsplash_image = UnsplashImage.new(
      image_id: @unsplash.id,
      image_urls_raw: @unsplash.urls.raw,
      image_links_download: @unsplash.links.download,
      image_user_name: @unsplash.user.name,
      image_user_username: @unsplash.user.username
    )
    @unsplash_image.save

    Rails.cache.fetch(UnsplashImage.cache_key(UnsplashImage.all), expires_in: 12.hours) do
      # recipes.to_json(include: :user, :comments)
      MultiJson.dump({
        data: {
          bannerImage: {
            id: @unsplash_image.image_id,
            url: @unsplash_image.image_urls_raw,
            link: {
              download: @unsplash_image.image_links_download,
            },
            user: {
              name: @unsplash_image.image_user_name,
              username: @unsplash_image.image_user_username,
            }
          }
        }
      })
    end
  end
end
