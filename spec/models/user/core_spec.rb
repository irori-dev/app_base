require 'rails_helper'

RSpec.describe User::Core, type: :model do
  describe '#valid?' do
    subject { user.valid? }
    let(:user) { build(:user_core) }

    it { is_expected.to be_truthy }

    context 'when email is blank' do
      let(:user) { build(:user_core, email: '') }

      it { is_expected.to be_falsey }
    end

    context 'when email is not unique' do
      let(:existing_user) { create(:user_core) }
      let(:user) { build(:user_core, email: existing_user.email) }

      it { is_expected.to be_falsey }
    end

    context 'when password is blank' do
      let(:user) { build(:user_core, password: '') }

      it { is_expected.to be_falsey }
    end

    context 'when password is too short' do
      let(:user) { build(:user_core, password: 'a' * 5) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#password_resets' do
    subject { user.password_resets }
    let(:user) { create(:user_core) }
    let!(:password_reset) { create(:user_password_reset, user:) }

    it { is_expected.to eq([password_reset]) }
  end

  describe '#email_changes' do
    subject { user.email_changes }
    let(:user) { create(:user_core) }
    let!(:email_change) { create(:user_email_change, user:) }

    it { is_expected.to eq([email_change]) }
  end
end
