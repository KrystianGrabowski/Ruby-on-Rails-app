# Klasa umożliwiająca dodanie produktu do koszyka.

class AddToCart < ActiveInteraction::Base
  # Obecny użytownik
  object :guest
  # Produkt do dodania
  object :product

  # Dodaje +product+:: do koszyka +guest+::.
  def execute
    guest.cart.order_items.create product: product
  end
end
