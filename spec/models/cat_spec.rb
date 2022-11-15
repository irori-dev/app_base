require 'rails_helper'

RSpec.describe Cat, type: :model do
  describe '#name' do
    subject { cat.name }
    let(:cat) { create(:cat, name: 'hey', age: 1) }

    it { is_expected.to eq 'hey' }
  end

  describe '#age' do
    subject { cat.age }
    let(:cat) { create(:cat, name: 'hey', age: 1) }

    it { is_expected.to eq 1 }
  end
end
