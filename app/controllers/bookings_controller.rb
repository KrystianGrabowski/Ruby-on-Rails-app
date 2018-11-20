class BookingsController < ApplicationController
  before_action :authenticate_admin_user!, only: %i[index destroy]

  def create
    @booking = Booking.new(params.require(:booking).permit(:product_id).merge(start_date: Time.now, end_date: Time.now + 10.days))
    @product = Product.find(@booking.product_id)
    @booking.product_name = @product.name
    @booking.user_name = !current_user ? 'gość' : current_user.email
    if @product.amount.positive?
      @product.update(amount: @product.amount - 1)
      flash[:notice] = @booking.save ? 'Rezerwacja została dodana' : 'Nie można tego zrobić' else flash[:notice] = 'Nie można tego zrobić'
    end
    redirect_to @product
  end

  def index
    @bookings = Booking.all
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = 'Booking was destroyed!'
  end

  def restore
    @booking = Booking.find(params[:id])
    @product = Product.find(@booking.product_id)
    @product.update amount: @product.amount + 1
    @booking.update returned: true
    redirect_to bookings_path
  end
end
