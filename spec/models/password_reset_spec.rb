require 'rails_helper'

RSpec.describe PasswordReset, type: :model do
  describe '#valid?' do
    subject { password_reset.valid? }
    let(:password_reset) { build(:password_reset) }

    it { is_expected.to be_truthy }

    context 'when password_resettable is blank' do
      let(:password_reset) { build(:password_reset, password_resettable: nil) }

      it { is_expected.to be_falsey }
    end

    context 'when reset_digest is blank' do
      let(:password_reset) { build(:password_reset, reset_digest: '') }

      it { is_expected.to be_falsey }
    end

    context 'when reset_digest is not unique' do
      let(:existing_password_reset) { create(:password_reset) }
      let(:password_reset) { build(:password_reset, reset_digest: existing_password_reset.reset_digest) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#password_resettable' do
    subject { password_reset.password_resettable }
    let(:password_reset) { create(:password_reset) }

    it { is_expected.to be_a User }
  end

  describe '.not_expired' do
    subject { described_class.not_expired }
    let!(:expired_password_reset) { create(:password_reset, created_at: 1.hour.ago) }
    let!(:password_reset) { create(:password_reset) }

    it { is_expected.to eq([ password_reset ]) }
  end

  describe '.not_reset' do
    subject { described_class.not_reset }
    let!(:reset_password_reset) { create(:password_reset, reset_at: 1.hour.ago) }
    let!(:password_reset) { create(:password_reset, reset_at: nil) }

    it { is_expected.to eq([ password_reset ]) }
  end

  describe '.detected_by' do
    subject { described_class.detected_by(token) }
    let(:token) { 'token' }
    let!(:password_reset) { create(:password_reset, reset_digest: described_class.digest('token')) }

    it { is_expected.to eq(password_reset) }

    context 'when token is incorrect' do
      let(:token) { 'otherToken' }

      it { expect { subject }.to raise_error(ArgumentError, '期限切れ、もしくは無効なトークンです') }
    end
  end

  describe '#reset!' do
    subject { password_reset.reset! }
    let(:password_reset) { create(:password_reset, reset_at: nil) }

    before do
      travel_to(Time.current)
    end

    it { expect { subject }.to change { password_reset.reset_at }.from(nil).to(Time.current) }
  end

  describe '#send_password_reset_email' do
    subject { password_reset.send_password_reset_email }
    let(:password_reset) { create(:password_reset) }

    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
  end

  describe '#match?' do
    subject { password_reset.match?(token) }
    let(:password_reset) { create(:password_reset, reset_digest: described_class.digest(token)) }
    let(:token) { 'token' }

    it { is_expected.to be_truthy }

    context 'when token is incorrect' do
      let(:password_reset) { create(:password_reset, reset_digest: described_class.digest('otherToken')) }

      it { is_expected.to be_falsey }
    end
  end
end
