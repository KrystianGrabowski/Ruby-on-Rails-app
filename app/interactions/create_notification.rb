class CreateNotification < ActiveInteraction::Base
  object :user, default: nil
  object :product

  def execute
    create_obj
    owner_update
  end

  def create_obj
    @notification = Notification.new(product_id: product.id)
    @notification.update former_price: product.price
    errors.merge!(@notification.errors) unless @notification.save
  end

  def owner_update
    @notification.update user_id: user.id
  end
end
