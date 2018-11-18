class Product < ApplicationRecord
  validates :name, :price, :category, :amount, presence: true
  validates :name, uniqueness: true
  validates :amount, :price, numericality: { greater_than_or_equal_to: 0 }
  has_many :comments
  has_one_attached :picture
  attr_accessor :remove_picture
  after_save :purge_picture, if: :remove_picture

  private

  def purge_picture
    picture.purge_later
  end
end
