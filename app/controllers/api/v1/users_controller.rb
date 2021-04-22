class Api::V1::UsersController < Api::V1::BaseController
  # before_action :authenticate_and_set_user, only: [ :follow, :unfollow, :followers, :following ]
  before_action :authenticate_and_set_user, except: [ :index, :show, :followers, :following, :is_authenticated ]
  before_action :process_token, only: :is_authenticated
  # before_action :authenticate_user!, except: [ :index, :show, :followers, :following ]
  before_action :set_user, only: [ :follow, :unfollow, :followers, :following ]

  def index
    @users = policy_scope(User).includes([:followers, :following])
    # @device = DeviceDetector.new(request.user_agent).device_type
    json = Rails.cache.fetch(User.cache_key(@users)) do
      MultiJson.dump({
        data: {
          users: @users.map { |user| {
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
                }.sort_by { |hsh| hsh[:data][:createdAt] },
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
                },
              }.sort_by { |hsh| hsh[:data][:createdAt] },
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
    render json: json
  end

  def show
    # @users = policy_scope(User).includes([:followers, :following])
    # @device = DeviceDetector.new(request.user_agent).device_type
    @user = User.find_by(slug: params[:id])
    authorize @user
    json = MultiJson.dump({
      data: {
          id: @user.id,
          slug: @user.slug,
          name: @user.name,
          checked: @user.checked,
          followers: {
            count: @user.followers.length,
            data: @user.followers.map { |f| {
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
            }.sort_by { |hsh| hsh[:data][:createdAt] },
          },
          following: {
            count: @user.following.length,
            data: @user.following.map { |f| {
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
            }.sort_by { |hsh| hsh[:data][:createdAt] },
          },
          image: {
            full: {
              url: @user.image.url(:full)
            },
            preview: {
              url: @user.image.url(:preview)
            },
            openGraph: {
              url: @user.image.url(:open_graph)
            },
            thumb: {
              url: @user.image.url(:thumb)
            }
          },
          createdAt: (@user.created_at.to_f * 1000).to_i
        }
      })
    render json: json
  end

  def follow
    # binding.pry
    if current_user.follow(@user.id)
      render json: MultiJson.dump({
        user: {
          name: @user.name,
          slug: @user.slug,
          checked: @user.checked,
          image: {
            thumb: {
              url: @user.image.url(:thumb)
            }
          }
        }
      })
    end
  end

  def unfollow
    # binding.pry
    if current_user.unfollow(@user.id)
      render json: {}
    end
  end

  def followers
    # binding.pry
    json = MultiJson.dump({
      data: {
        users: @user.followers.map { |f| {
            name: f.name,
            slug: f.slug,
            checked: f.checked,
            image: {
              thumb: {
                url: f.image.url(:thumb)
              }
            }
          }
        }
      }
    })
    render json: json
  end

  def following
    # binding.pry
    json = MultiJson.dump({
      data: {
        users: @user.following.map { |f| {
            name: f.name,
            slug: f.slug,
            checked: f.checked,
            image: {
              thumb: {
                url: f.image.url(:thumb)
              }
            }
          }
        }
      }
    })
    render json: json
  end

  def is_authenticated
    # process_token
    # binding.pry
    render json: {
      isAuthenticated: user_signed_in?
    }
  end

  def current
    # binding.pry
    resource = current_user
    authorize resource
    render json: MultiJson.dump({
      # facebookAuth: @facebookAuth,
      facebookAuth: nil,
      id: resource.id,
      email: resource.email,
      slug: resource.slug,
      first_name: resource.first_name,
      last_name: resource.last_name,
      name: resource.name,
      admin: resource.admin,
      authentication_token: resource.authentication_token,
      image: resource.image,
      checked: resource.checked,
      mailchimp: resource.mailchimp,
      notification: resource.notification,
      locale: resource.locale,
      moderator: resource.moderator,
      freemium: resource.freemium,
      likes: Like.where(user_id: resource.id),
      commentLikes: CommentLike.where(user_id: resource.id).map { |r| r.comment_id },
      replyLikes: ReplyLike.where(user_id: resource.id).map { |r| r.reply_id },
      bookmarks: Bookmark.where(user_id: resource.id),
      followers: {
        count: resource.followers.length,
        data: resource.followers.map { |f| {
            name: f.name,
            slug: f.slug,
            checked: f.checked,
            image: {
              thumb: {
                url: f.image.url(:thumb)
              }
            }
          }
        }
      },
      following: {
        count: resource.following.length,
        data: resource.following.map { |f| {
            name: f.name,
            slug: f.slug,
            checked: f.checked,
            image: {
              thumb: {
                url: f.image.url(:thumb)
              }
            }
          }
        }
      }
    })
  end

  private

  def set_user
    # binding.pry
    @user = User.find_by(slug: params[:user_slug])
    authorize @user  # For Pundit
    # binding.pry
  end

end
