require 'rails_helper'

RSpec.describe Product do
  let(:product) { FactoryBot.create :product }

  describe '#display_price' do
    it do
      expect(product.display_price).to eq(product.price)
    end
  end
end
