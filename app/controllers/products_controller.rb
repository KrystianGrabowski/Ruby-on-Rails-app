# Kontroler odpowiedzialny za produkty i akcje z nimi związanymi
class ProductsController < InheritedResources::Base
  # Autoryzacja admina przed akcjami administracyjnymi
  before_action :authenticate_admin_user!, except: %i[index show show_picture down show_price reservation add_to_cart]

  # Dodanie okruszków
  add_breadcrumb 'Products', :products_path

  # Metody pomocnicze
  helper_method :category_link, :cat

  # Akcja utworzenia nowego produktu
  def new
    add_breadcrumb 'New', :new_product_path
    super
  end

  # Edytowanie produktu
  def edit
    @product = Product.find(params[:id])
    add_breadcrumb @product.name.to_s, product_path
    add_breadcrumb 'Edit', :edit_product_path
    super
  end

  # Funkcja pomocnicza do index (w celach obejścia rubocopa)
  def index_rubcop_help
    @products = @products.where(category: params[:category]) unless params[:category].nil?
    @products_all = @products
    @products = @products.page(params[:page]).per(5)
    @view_model = HomePageViewModel.new
  end

  # Listowanie wszystkich produktów wraz z paginacją i sortowaniem
  def index
    @products = ProductsProvider.new(params[:key]).results
    index_rubcop_help
    sort
  end

  # Szczegóły danego produktu (wraz z komentarzami)
  def show
    @product = Product.find(params[:id])
    add_breadcrumb @product.name.to_s, product_path
    @comments = Comment.new(product: @product)
    @bookings = Booking.new(product: @product)
  end

  # Funkcja pomocnicza - Zwraca parametry produktu
  def product_params
    params.require(:product).permit(:name, :remove_picture, :picture, :price, :description, :category, :amount)
  end

  # Metoda umożliwiająca dodanie produktu do koszyka
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

  # Zwraca parametr do sortowania (z url)
  def sorting
    params[:sort_by]
  end

  # Sortowanie produktu względem parametru w urlu
  def sort
    @products = @products.reorder(sorting) if sorting.in? ['created_at desc', 'created_at asc']
  end

  # Metoda tworząca odnośniki do sortowania względem wszystkich kategorii
  def cat(_path, other_params)
    @string = '' # + path.to_s + '<br>' + other_params.to_s + '<br>'
    tab = []
    # Product.all.each do |p| #Uwzględnia wszystkie kategorie, nie tylko te wyszukane
    @products_all.each do |p| # Uwzględnia tylko te wyszukane
      next if tab.include?(p.category)

      tab += [p.category]
      url_params = { category: p.category }.merge(other_params)
      url = "#{products_path}?#{url_params.to_query}"
      @string += "<a href='#{url}'>#{p.category}</a> <br>".html_safe
    end
    @string.html_safe
  end
end
