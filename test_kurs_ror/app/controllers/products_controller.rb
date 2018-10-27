class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, except: [:index, :show]
  private

    def product_params
      params.require(:product).permit(:name, :price, :description, :category, :amount)
    end
end

