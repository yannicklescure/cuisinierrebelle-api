# config/initializers/cors.rb

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   # allow do
#   #   origins '*'
#   #   resource '*', headers: :any, methods: [:get, :post, :patch, :put]
#   # end

#   allow do
#     origins '*'

#     resource  '/api/v1/*',
#       headers: %w(Authorization),
#       methods: :any,
#       expose: %w(Authorization)

#     resource '*', :headers => :any, :methods => [:get, :head, :options]
#     # resource  '*',
#     #           headers: :any,
#     #           methods: [:get, :post, :delete, :put, :patch, :options, :head],
#     #           max_age: 0
#   end
# end

# Rails.application.config.hosts << "cuisinierrebelle.com"

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
  allow do
    origins '*'

    resource '*',
      headers: :any,
      expose: ['authorization', 'access-token', 'refresh-token', 'expire-at'],
      methods: [:get, :post, :delete, :put, :patch, :options, :head]

    # resource  '/api/v1/*',
    #   headers: %w(Authorization),
    #   methods: :any,
    #   expose: %w(Authorization)

    # resource '/cors',
    #   headers: :any,
    #   methods: [:post],
    #   max_age: 0

    # resource '*',
    #   headers: :any,
    #   methods: [:get, :post, :delete, :put, :patch, :options, :head],
    #   max_age: 0
  end
end
