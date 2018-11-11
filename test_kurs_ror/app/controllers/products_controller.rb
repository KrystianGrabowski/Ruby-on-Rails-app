class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: %i[index show down reservation]

  def show
    @product = Product.find(params[:id])
    @comments = Comment.new(product: @product)
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :category, :amount)
  end

  def down
    @product = Product.find(params[:id])
    if @product.amount.positive?
      @product.update(amount: @product.amount - 1)
      redirect_to @product
      flash[:notice] = 'Pomyślnie zarezerwowano produkt!'
    else
      redirect_to @product
      flash[:notice] = 'Nie można tego zrobić'
    end
  end
end
