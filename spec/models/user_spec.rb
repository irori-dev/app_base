require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    subject { user.valid? }
    let(:user) { build(:user) }

    it { is_expected.to be_truthy }

    context 'when email is blank' do
      let(:user) { build(:user, email: '') }

      it { is_expected.to be_falsey }
    end

    context 'when email is not unique' do
      let(:existing_user) { create(:user) }
      let(:user) { build(:user, email: existing_user.email) }

      it { is_expected.to be_falsey }
    end

    context 'when password is blank' do
      let(:user) { build(:user, password: '') }

      it { is_expected.to be_falsey }
    end

    context 'when password is too short' do
      let(:user) { build(:user, password: 'a' * 5) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#password_resets' do
    subject { user.password_resets }
    let(:user) { create(:user) }
    let!(:password_reset) { create(:password_reset, password_resettable: user, password_resettable_type: 'User') }

    it { is_expected.to eq([password_reset]) }
  end

  describe '#email_changes' do
    subject { user.email_changes }
    let(:user) { create(:user) }
    let!(:email_change) { create(:email_change, email_changeable: user, email_changeable_type: 'User') }

    it { is_expected.to eq([email_change]) }
  end
end
