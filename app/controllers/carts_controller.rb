class CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[finalize]
  def index
    @cart = current_guest.cart
    @value = cart_sum_check
  end

  def cart_sum_check
    s = 0
    current_guest.cart.order_items.each do |item|
      s += item.product.price if item.product.amount.positive?
    end
    s
  end

  def finalize
    s = current_guest.cart.cart_check
    current_guest.cart.order_items.each do |item|
      CreateBooking.run(user: current_user, product: item.product)
      item.destroy
    end
    flash[:notice] = s
    redirect_to '/products'
  end
end
