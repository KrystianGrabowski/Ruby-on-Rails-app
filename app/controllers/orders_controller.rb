class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def show
    @order = attach_order
  end

  def confirm
    order = current_user.orders.pending.find(params[:id])
    order.update(
      comment: params[:order][:comment],
      status: Order::CONFIRMED_ORDER_STATUS
    )

    redirect_to user_panel_order_path(order)
  end

  private

  def attach_order
    order = current_user.orders.find_by(id: params[:id])
    return order if order

    order = current_guest.orders.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless order

    order.update owner: current_user

    order
  end
end
