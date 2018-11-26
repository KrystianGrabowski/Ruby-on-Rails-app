class CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[confirm]
  def index
    @cart = current_guest.cart
  end

  def confirm
    cart = current_guest.cart
    cart.update status: Order::PENDING_ORDER_STATUS

    redirect_to user_panel_order_path(cart)
  end
end
