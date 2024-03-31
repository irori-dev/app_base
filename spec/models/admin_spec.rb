require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    subject { admin.valid? }
    let(:admin) { build(:admin) }

    it { is_expected.to be_truthy }

    context 'when email is blank' do
      let(:admin) { build(:admin, email: '') }

      it { is_expected.to be_falsey }
    end

    context 'when email is not unique' do
      let(:existing_admin) { create(:admin) }
      let(:admin) { build(:admin, email: existing_admin.email) }

      it { is_expected.to be_falsey }
    end

    context 'when password is blank' do
      let(:admin) { build(:admin, password: '') }

      it { is_expected.to be_falsey }
    end

    context 'when password is too short' do
      let(:admin) { build(:admin, password: 'a' * 5) }

      it { is_expected.to be_falsey }
    end

    context 'when password_confirmation is not equal to password' do
      let(:admin) { build(:admin, password_confirmation: 'invalid') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#password_resets' do
    subject { admin.password_resets }
    let(:admin) { create(:admin) }
    let!(:password_reset) { create(:password_reset, password_resettable: admin, password_resettable_type: 'Admin') }

    it { is_expected.to eq([password_reset]) }
  end
end
