require 'rails_helper'

RSpec.describe Order do
  describe '#cart_sum_check' do
    context 'when the order is empty' do
      let!(:owner) { create :user }
      let!(:order) { create :order, owner_id: owner.id }

      it { expect(order.cart_sum_check).to eq(0) }
    end

    context 'when there is one product ordered' do
      let!(:owner) { create :user }
      let!(:product) { create :product, amount: 10 }
      let!(:order_item) { create :order_item, product_id: product.id }
      let!(:order) { create :order, owner_id: owner.id, order_items: [order_item] }

      it { expect(order.cart_sum_check).to eq(product.price) }
    end
  end

  describe '#check_string' do
    context 'when the order is empty' do
      let!(:owner) { create :user }
      let!(:order) { create :order, owner_id: owner.id }

      it { expect(order.check_string('Rezerwacja: ', ' Brak na stanie: ')).to eq('Nic nie wypożyczono (koszyk był pusty)') }
    end
    context 'when the order is not empty' do
      let!(:owner) { create :user }
      let!(:product) { create :product, amount: 10 }
      let!(:order_item) { create :order_item, product_id: product.id }
      let!(:order) { create :order, owner_id: owner.id, order_items: [order_item] }

      it 'product is available' do
        str = 'Rezerwacja: ' + product.name + ', '
        expect(order.check_string(str, ' Brak na stanie: ')).to eq(str.chomp(', '))
      end

      it 'product is not available' do
        product.amount = 0
        str = ' Brak na stanie: ' + product.name + ', '
        expect(order.check_string('Rezerwacja: ', str)).to eq(str.chomp(', '))
      end
    end

    context 'when the order contains some available products and some unavailable' do
      let!(:owner) { create :user }
      let!(:prod1) { create :product, amount: 10 }
      let!(:prod2) { create :product, amount: 0 }
      let!(:ord_i_a) { create :order_item, product_id: prod1.id }
      let!(:ord_i_una) { create :order_item, product_id: prod2.id }
      let!(:order) { create :order, owner_id: owner.id, order_items: [ord_i_a, ord_i_una] }

      it do
        str1 = 'Rezerwacja: ' + prod1.name + ', '
        str2 = ' Brak na stanie: ' + prod2.name + ', '
        expect(order.check_string(str1, str2)).to eq(str1.chomp(', ') + str2.chomp(', '))
      end
    end
  end

  describe '#cart_check' do
    context 'when the order is empty' do
      let!(:owner) { create :user }
      let!(:order) { create :order, owner_id: owner.id }

      it { expect(order.cart_check).to eq('Nic nie wypożyczono (koszyk był pusty)') }
    end
    context 'when the order contains some available products and some unavailable' do
      let!(:owner) { create :user }
      let!(:prod1) { create :product, amount: 10 }
      let!(:prod2) { create :product, amount: 0 }
      let!(:ord_i_a) { create :order_item, product_id: prod1.id }
      let!(:ord_i_una) { create :order_item, product_id: prod2.id }
      let!(:order) { create :order, owner_id: owner.id, order_items: [ord_i_a, ord_i_una] }

      it do
        str1 = 'Rezerwacja: ' + prod1.name + ', '
        str2 = ' Brak na stanie: ' + prod2.name + ', '
        expect(order.cart_check).to eq(str1.chomp(', ') + str2.chomp(', '))
      end
    end
  end
end
