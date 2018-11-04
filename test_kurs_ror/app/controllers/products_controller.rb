class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: %i[index show]

  def show
    @product = Product.find(params[:id])
    @comments = Comment.new(product: @product)
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :category, :amount)
  end
end
