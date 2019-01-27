# Klasa umożliwiająca utowrzenie rezerwacji.

class CreateBooking < ActiveInteraction::Base
  # Obecny użytownik
  object :user, default: nil
  # Produkt do rezerwacji
  object :product

  # Tworzy rezerwację.
  def execute
    if @product.amount.positive?
      create_obj
      amount_update
      date_update
      owner_update
      name_update
    else
      errors.add(:product, 'not enough')
    end
  end

  # Tworzy nowy obiekt klasy Booking.
  def create_obj
    @booking = Booking.new(product: product)
    errors.merge!(@booking.errors) unless @booking.save
  end

  # Przypisuje datę wypożyczenia oraz datę zwrotu.
  def date_update
    @booking.update start_date: Time.now, end_date: Time.now + 10.days
  end

  # Przypisuje właściciela rezerwacji.
  def owner_update
    @booking.user_name = !user ? 'gość' : user.email
    @booking.user_id = user.id if user
  end

  # Przypisuje nazwę wypożyczonego produktu.
  def name_update
    @booking.update product_name: product.name
  end

  # Aktualizuje ilość dostępnych produktów typu +product+::.
  def amount_update
    @product.update(amount: @product.amount - 1)
  end
end
