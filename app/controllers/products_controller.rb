class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: %i[index show show_picture down show_price reservation add_to_cart]
  add_breadcrumb 'Products', :products_path
  helper_method :category_link, :cat

  def new
    add_breadcrumb 'New', :new_product_path
    super
  end

  def edit
    @product = Product.find(params[:id])
    add_breadcrumb @product.name.to_s, product_path
    add_breadcrumb 'Edit', :edit_product_path
    super
  end

  def index
    @products = ProductsProvider.new(params[:key]).results
    # @caption = 'Nasze produkty:'
    @products = Product.all.where(category: params[:category]) unless params[:category].nil? # umyślnie wszystko
    @products = Product.all if params[:category] == 'wszystkie'
    @products = @products.page(params[:page]).per(5)
    @view_model = HomePageViewModel.new
  end

  def show
    @product = Product.find(params[:id])
    add_breadcrumb @product.name.to_s, product_path
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

  def category_link(base_path, new_category, other_params)
    url_params = { category: new_category }.merge(other_params)
    url = "#{base_path}?#{url_params.to_query}"
    "<a href='#{url}'>#{new_category}</a> <br>".html_safe
  end

  def cat # do naprawienia
    tab = []
    @products.each do |p|
      tab += [p.category] unless tab.include?(p.category)
    end
    tab.each do |elem|
      category_link(products_path, elem, {})
    end
  end
end
