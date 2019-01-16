class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb 'Notifications', :notifications_index_path
    @current_name = current_user.email
    @notifications = Notification.where(user_id: current_user.id)
    update_prices
  end

  def add_to_watch_list
    product = Product.find(params[:id])
    flash[:notice] = current_user.id
    outcome = CreateNotification.run(user: current_user, product: product)

    flash[:notice] = if outcome.valid?
                       'Dodano do listy obserowanych'
                     else
                       outcome.errors.full_messages
                     end

    redirect_to products_path
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_back(fallback_location: notifications_index_path)
    flash[:notice] = 'Notification was destroyed!'
  end

  def self.track_changes(user)
    @notifications = Notification.where(user_id: user.id)
    @notifications.each do |nf|
      product = Product.find(nf.product_id)
      return true if nf.former_price != product.price
    end
    false
  end

  def update_prices
    @notifications = Notification.where(user_id: current_user.id)
    @notifications.each do |nf|
      product = Product.find(nf.product_id)
      nf.update former_price: product.price if nf.former_price != product.price
    end
  end
end
