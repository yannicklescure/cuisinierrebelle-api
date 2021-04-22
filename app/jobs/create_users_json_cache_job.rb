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
                    },
                    createdAt: (user.follower_relationships.find_by(following_id: user.id, follower_id: f.id).created_at.to_f * 1000).to_i
                  }
                }.compact.sort_by { |hsh| hsh[:createdAt] }
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
                    },
                    createdAt: (user.following_relationships.find_by(following_id: f.id, follower_id: user.id).created_at.to_f * 1000).to_i
                  }
                }.compact.sort_by { |hsh| hsh[:createdAt] }
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
