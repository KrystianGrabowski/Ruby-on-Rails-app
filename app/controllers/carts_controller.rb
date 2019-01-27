# Kontroler odpowiedzialny za koszyk.
class CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[finalize]
  # Dodaje okruchy i przesyła dane do widoku
  def index
    add_breadcrumb 'Cart', :carts_path
    @cart = current_guest.cart
    @value = @cart.cart_sum_check
  end

  # Finalizuje zamowienie. Wyświetla notkę informacyjną oraz przenosi do produków.
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
