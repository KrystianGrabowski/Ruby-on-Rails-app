require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let(:product) { FactoryBot.create :product }
  let(:user) { FactoryBot.create :user }
  let(:guest) { FactoryBot.create :guest }

  describe 'POST #create' do
    subject { post :create, params: { booking: { product_id: product.id } } }
    before do
      allow(CreateBooking).to receive(:run).and_return(outcome)
    end

    context 'when guest creates booking' do
      let(:outcome) { instance_double(CreateBooking, valid?: true) }

      it do
        subject
        expect(controller.flash[:notice]).to eq('Rezerwacja została dodana')
      end
    end
  end
end
