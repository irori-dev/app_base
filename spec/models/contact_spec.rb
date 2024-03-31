require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#valid?' do
    subject { contact.valid? }
    let(:contact) { build(:contact) }

    it { is_expected.to be_truthy }

    context 'when email is blank' do
      let(:contact) { build(:contact, email: '') }

      it { is_expected.to be_falsey }
    end

    context 'when name is blank' do
      let(:contact) { build(:contact, name: '') }

      it { is_expected.to be_falsey }
    end

    context 'when text is blank' do
      let(:contact) { build(:contact, text: '') }

      it { is_expected.to be_falsey }
    end

    context 'when phone_number is blank' do
      let(:contact) { build(:contact, phone_number: '') }

      it { is_expected.to be_falsey }
    end
  end
end
