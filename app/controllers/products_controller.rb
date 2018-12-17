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

  def category_check
    if !params[:category].nil?
      @products.where(category: params[:category])
    elsif (params[:category] == 'all') || (params[:category] == 'wszystkie')
      @products.all
    end
  end

  def index
    @products_all = Product.all # debbuging - nie ruszać
    @products = ProductsProvider.new(params[:key]).results
    @caption = 'Nasze produkty:'
    category_check

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

  def cat
    tab = []
    @products.each do |p|
      tab += [p] if tab.include?(p)
    end
    category_link(products_path, 'wszystkie', {})
    tab.each do |p|
      category_link(products_path, p, {})
    end
  end
end
