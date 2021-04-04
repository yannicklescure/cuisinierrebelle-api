require 'digest'
require "i18n"

class User < ApplicationRecord
  # acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         # :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
         # :omniauthable, omniauth_providers: %i[facebook]

  # validates :first_name, presence: true
  # validates :last_name, presence: true
  validates :name, presence: true
  validates :email, presence: true

  has_many :recipes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :reply_likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_one :about, dependent: :destroy
  # has_many :socials, dependent: :destroy

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  def self.cache_key(users)
    {
      serializer: 'users',
      stat_record: users.maximum(:updated_at)
    }
  end

  mount_uploader :image, ImageUploader

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  def is_following?(user_id)
    relationship = Follow.find_by(follower_id: id, following_id: user_id)
    return true if relationship
  end

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    self.locale = I18n.default_locale
    # self.locale = :fr
    async_update
    self.save
    send_welcome_email
  end

  # after_commit :create_default_image
  # after_commit :async_update # Run on create & update
  before_commit :facebook, on: [:create]
  before_commit :sanitize_user_slug, :sanitize_user_image, on: [:create, :update]
  before_commit :flush_cache!
  after_commit :reindex_user
  after_save :create_json_cache
  after_destroy :create_json_cache

  extend FriendlyId
  friendly_id :name, use: :slugged

  # api_guard_associations refresh_token: 'refresh_tokens'
  # api_guard_associations blacklisted_token: 'blacklisted_tokens'
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  # include PgSearch::Model
  # # PgSearch.multisearch_options = {
  #   # using: [:tsearch, :trigram],
  #   # ignoring: :accents
  # # }
  # multisearchable against: [:name, :first_name, :last_name]

  searchkick

  # has_secure_password
  # API Guard authentication with Devise
  # See https://github.com/Gokul595/api_guard/wiki/Using-API-Guard-with-Devise
  def authenticate(password)
    valid_password?(password)
  end

  private

  def reindex_user
    User.reindex
  end

  def facebook
    self.skip_confirmation! unless self.provider.nil?
  end

  def flush_cache!
    puts 'flushing the cache...'
    Rails.cache.delete User.cache_key(User.all)
    # Rails.cache.delete 'all_employees'
    # Rails.cache.delete "employees_#{gender}"
  end

  def create_json_cache
    CreateUsersJsonCacheJob.perform_later
  end

  def sanitize_user_slug
    # binding.pry
    # if self.slug.match?(/\W/)
      # binding.pry
      # unless User.find_by(slug: self.slug).nil?
      # self.slug.gsub!(/\W/,'')
      # binding.pry
      self.slug = I18n.transliterate("#{ first_name }#{ last_name }".downcase)
      if slug_exists?
        # self.slug = "#{self.slug}#{Digest::SHA256.hexdigest(DateTime.now.strftime('%Q'))[0..32]}"
        # binding.pry
        arr = User.where("(lower(first_name) = ?) AND (lower(last_name) = ?)", first_name.downcase, last_name.downcase)
        arr = arr.sort_by { |e| e.created_at }
        position = arr.index(self) + 1
        self.slug = "#{slug}#{position}"
      end
      puts slug
      # binding.pry
      # self.save
    # end
  end

  def slug_exists?
    tmp = User.find_by(slug: slug)
    if tmp.nil?
      false
    elsif tmp.id === id
      false
    else
      true
    end
  end

  def sanitize_user_image
    # binding.pry
    if self.image.file.nil?
      self.remote_image_url = 'https://media.cuisinierrebelle.com/profile/default.jpg'
      self.save
    end
  end

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end

  def async_update
    MailchimpSubscribeUser.perform_later(self)
    self.mailchimp = true
    # self.save
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.name = auth.info.name   # assuming the user model has a name
  #     name = Namae::Name.parse(user.name)
  #     user.first_name = name.given
  #     user.last_name = name.family
  #     # user.image = auth.info.image # assuming the user model has an image
  #     user.remote_image_url = "http://graph.facebook.com/#{user.uid}/picture?type=normal"
  #     # If you are using confirmable and the provider(s) you use validate emails,
  #     # uncomment the line below to skip the confirmation emails.
  #     user.skip_confirmation!
  #   end
  # end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
  #       user.email = data["email"] if user.email.blank?
  #     end
  #   end
  # end
end
