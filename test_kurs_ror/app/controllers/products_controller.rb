class ProductsController < InheritedResources::Base
  before_action :authenticate_admin_user!, only: [:new]
  private

    def product_params
      params.require(:product).permit(:name, :price, :description, :category, :amount)
    end
end

