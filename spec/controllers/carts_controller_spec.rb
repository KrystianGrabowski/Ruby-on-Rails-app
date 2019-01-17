require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  describe 'GET #index' do
    subject { get :index }
    let(:admin) { create :admin_user }

    it do
      sign_in admin
      expect(subject.status).to eq(200)
    end
  end

  describe 'POST #finalize' do
    let(:user) { create :user }
    subject { post :finalize, params: { id: user.id } }
    let(:product) { create :product, amount: 10 }
    let(:guest) { create :guest }

    context "when user's cart is empty" do
      it 'notice should be nil' do
        sign_in user
        subject
        expect(controller.flash[:notice]).to eq('Nic nie wypożyczono (koszyk był pusty)')
      end
      it 'redirect if not signed in' do
        expect(subject.status).to redirect_to(new_user_session_path)
      end
      it 'status should be OK' do
        sign_in user
        expect(subject.status).to redirect_to(products_path)
      end
    end

    context 'when user has something in cart' do
      let(:ord_item) { create :order_item, product_id: product.id }
      let(:user_order) { create :order, owner_id: user.id, order_items: [ord_item] }
      let(:guest) { create :guest, orders: [user_order] }

      # it "shows correctly what has been booked" do  #WIP
      # s = guest.cart.cart_check
      # sign_in user
      # subject
      # expect(flash[:notice]).to eq(s)
      # end

      it 'redirects to products' do
        sign_in user
        subject
        expect(subject).to redirect_to(products_path)
      end
    end
  end
end
