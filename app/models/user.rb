class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :comments
  has_many :bookings
  has_many :notifications
  has_one_attached :picture
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_accessor :remove_picture
  after_save :purge_picture, if: :remove_picture

  def display_name
    email if email.present?
  end

  private

  def purge_picture
    picture.purge_later
  end
end
