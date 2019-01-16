class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb 'Notifications', :bookings_user_bookings_path
    @current_name = current_user.email
    @notifications = Notification.where(user_id: current_user.id)
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
end
