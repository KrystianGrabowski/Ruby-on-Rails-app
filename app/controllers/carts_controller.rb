class CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[confirm]
  def index
    @cart = current_guest.cart
  end

  def confirm
    # do usunięcia?
  end

  def finalize
    cart = current_guest.cart
    cart.update status: Order::PENDING_ORDER_STATUS
    s = 'Rezerwacja: '
    s2 = ' Brak na stanie: '
    cart.order_items.each do |item|
      product = item.product
      outcome = CreateBooking.run(user: current_user, product: product)
      flash[:notice] = if outcome.valid?
                       s += "#{item.product.name}, "
                     else 
                       s2 += "#{item.product.name}, "
                     end
      item.destroy
    end
    flash[:notice] = s.chomp(', ')   + s2.chomp(', ')
    redirect_to '/products'
  end
end
