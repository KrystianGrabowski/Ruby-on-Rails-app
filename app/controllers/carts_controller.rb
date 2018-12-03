class CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[confirm]
  def index
    @cart = current_guest.cart
    @value = cart_sum_check
  end

  def confirm
    # do usunięcia?
  end

  def cart_sum_check
    s = 0
    current_guest.cart.order_items.each do |item|
      s += item.product.price if item.product.amount.positive?
    end
    s
  end

  def check_string(str, str2)
    str = '' if str == 'Rezerwacja: '
    str2 = '' if str2 == ' Brak na stanie: '
    if !((str == '') && (str2 == '')) then str.chomp(', ') + str2.chomp(', ')
    else 'Nic nie wypożyczono (w koszyku mogły znajdować się tylko produkty, których nie było na stanie lub koszyk był pusty)'
    end
  end

  def cart_check
    s = 'Rezerwacja: '
    s2 = ' Brak na stanie: '
    current_guest.cart.order_items.each do |item|
      item = item.product
      if item.amount.positive? then s += item.name + ', '
      else s2 += item.name + ', '
      end
    end
    check_string s, s2
  end

  def finalize
    s = cart_check
    current_guest.cart.order_items.each do |item|
      CreateBooking.run(user: current_user, product: item.product)
      item.destroy
    end
    flash[:notice] = s
    redirect_to '/products'
  end
end
