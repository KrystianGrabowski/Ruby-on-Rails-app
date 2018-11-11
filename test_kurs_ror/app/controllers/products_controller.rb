class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: %i[index show down_amount rezerwacja]

  def show
    @product = Product.find(params[:id])
    @comments = Comment.new(product: @product)
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :category, :amount)
  end

  def down_amount
    @comment = Product.find(params[:id])
    @comment.update(amount: params[:amount])
    puts 'coś'
    redirect_to comment.post
  end
end
