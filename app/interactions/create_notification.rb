# Klasa umożliwiająca utowrzenie rezerwacji.

class CreateNotification < ActiveInteraction::Base
  # Obecny użytownik
  object :user, default: nil
  # Produkt
  object :product

  # Tworzy powiadomienie.
  def execute
    create_obj
    owner_update
  end

  # Tworzy nowy obiekt klasy Notification. Przypisuje mu obecną cenę przedmiotu +product+::.
  def create_obj
    @notification = Notification.new(product_id: product.id)
    @notification.update former_price: product.price
    errors.merge!(@notification.errors) unless @notification.save
  end

  # Przypisuje powiadomieniu id użytkownika +user+::.
  def owner_update
    @notification.update user_id: user.id
  end
end
