class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: %i[index show show_picture down show_price reservation]

  def index
    @products = Product.all
    @view_model = HomePageViewModel.new
  end

  def show
    @product = Product.find(params[:id])
    @comments = Comment.new(product: @product)
    @bookings = Booking.new(product: @product)
  end

  def product_params
    params.require(:product).permit(:name, :remove_picture, :picture, :price, :description, :category, :amount)
  end
end
