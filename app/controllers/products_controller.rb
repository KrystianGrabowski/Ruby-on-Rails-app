class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: %i[index show show_picture down show_price reservation add_to_cart]

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

  def add_to_cart
    product = Product.find(params[:id])
    outcome = AddToCart.run(guest: current_guest, product: product)

    flash[:notice] = if outcome.valid?
                       'Dodano do koszyka'
                     else
                       outcome.errors.full_messages
                     end

    redirect_to products_path
  end
end
