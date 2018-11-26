class Order < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :order_items

  scope :pending, -> { where(status: PENDING_ORDER_STATUS) }

  CART_STATUS = 'cart'.freeze
  PENDING_ORDER_STATUS = 'pending_order'.freeze
  CONFIRMED_ORDER_STATUS = 'confirmed_order'.freeze
end
