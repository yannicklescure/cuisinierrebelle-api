class CreateUsersJsonCacheJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    users = User.all.includes([:follower_relationships, :followers, :following])
    Rails.cache.fetch(User.cache_key(users)) do
      MultiJson.dump({
        data: {
          users: users.map { |user| {
              id: user.id,
              slug: user.slug,
              name: user.name,
              checked: user.checked,
              followers: {
                count: user.followers.length,
                data: user.followers.map { |f| {
                    name: f.name,
                    slug: f.slug,
                    checked: f.checked,
                    image: {
                      thumb: {
                        url: f.image.url(:thumb)
                      }
                    }
                  }
                },
              },
              following: {
                count: user.following.length,
                data: user.following.map { |f| {
                    name: f.name,
                    slug: f.slug,
                    checked: f.checked,
                    image: {
                      thumb: {
                        url: f.image.url(:thumb)
                      }
                    }
                  }
                },
              },
              image: {
                full: {
                  url: user.image.url(:full)
                },
                preview: {
                  url: user.image.url(:preview)
                },
                openGraph: {
                  url: user.image.url(:open_graph)
                },
                thumb: {
                  url: user.image.url(:thumb)
                }
              },
            }
          }
        }
      })
    end
  end
end
