class Product < ApplicationRecord
  validates :name, :price, :category, :amount, presence: true
  validates :name, uniqueness: true
  validates :amount, :price, numericality: {greater_than_or_equal_to: 0}
  has_many :comments
end
