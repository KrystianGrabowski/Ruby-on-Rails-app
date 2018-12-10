require 'rails_helper'

RSpec.describe ProductsProvider do
  let!(:product0) { create :product, name: 'Nasz najlepszy produkt' }

  describe '#results' do
    subject { described_class.new(key).results }

    context 'when key is lowercased' do
      let(:key) { {:key => 'nasz'} }

      it { is_expected.to include(product0) }
    end

    context 'when key is a prefix' do
      let(:key) { {:key => 'Nasz'}  }

      it { is_expected.to include(product0) }
    end

    context 'when key is in the middle' do
      let(:key) { {:key => 'najlepszy'}  }

      it { is_expected.to include(product0) }
    end

    context 'when key is empty' do
      let(:key) { '' }

      it { is_expected.to be_blank }
    end
  end
end
