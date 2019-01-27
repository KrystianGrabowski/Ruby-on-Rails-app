class ApplicationController < ActionController::Base
  helper_method :current_guest
  add_breadcrumb 'Home', :root_path
  # Znajduje obecnego gościa lub tworzy nowego, gdy obecny nie jest zdefiniowany.
  # @return [Guest] Obecny lub nowy gość
  def current_guest
    existing_guest || new_guest
  end

  private

  # Znajduje obecnego gościa.
  # @return [Guest] Obecny gość
  def existing_guest
    Guest.find(cookies.signed[:guest_id]) if cookies[:guest_id]
  end

  # Tworzy nowego gościa.
  # @return [Guest] Nowy gość
  def new_guest
    guest = Guest.create!
    cookies.signed[:guest_id] = { value: guest.id, expires: 1.month.from_now }
    guest
  end
end
