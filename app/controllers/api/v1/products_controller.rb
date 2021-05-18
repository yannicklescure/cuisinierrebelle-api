class Api::V1::ProductsController < Api::V1::BaseController
  before_action :authenticate_and_set_user, except: :index

  def index
    @products = policy_scope(Product)

    cache_key_with_version = "products/#{@products.last.id}-#{(@products.last.updated_at.to_f * 1000).to_i}"
    json = Rails.cache.fetch("#{cache_key_with_version}/index2") do
      MultiJson.dump(@products.map { |product| {
        title: product.title,
        description: product.description,
        image: product.image,
        url: product.url,
        provider: product.provider,
        country: product.country
      }
    })
    end
    render json: json
  end

  def create
    # binding.pry
    # params[:product] = {
    #   title: clean_params(params[:title]),
    #   content: clean_params(params[:content]),
    #   locale: clean_params(params[:locale]),
    # }

    # @product = Page.new(product_params)
    # authorize @product  # For Pundit
    # if @product.save
    #   render json:  MultiJson.dump({
    #     id: @product.id,
    #     slug: @product.slug,
    #     title: @product.title,
    #     content: @product.content,
    #     locale: @product.locale,
    #   })
    # end
  end

  def update
    # binding.pry
    # @product = Page.find_by(id: params[:id])
    # authorize @product  # For Pundit
    # params[:product] = {
    #   title: clean_params(params[:title]),
    #   content: clean_params(params[:content]),
    #   locale: clean_params(params[:locale]),
    # }

    # if @product.update(product_params)
    #   # binding.pry
    #   render json:  MultiJson.dump({
    #     id: @product.id,
    #     slug: @product.slug,
    #     title: @product.title,
    #     content: @product.content,
    #     locale: @product.locale,
    #   })
    # end
  end

  private

  def clean_params(param)
    param === "null" ? nil : param
  end

  def product_params
    # binding.pry
    params.require(:product).permit(:title, :content, :locale)
  end

end
