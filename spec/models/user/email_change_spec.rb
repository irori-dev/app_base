require 'rails_helper'

RSpec.describe User::EmailChange, type: :model do
  describe '#valid?' do
    subject { email_change.valid? }
    let(:email_change) { build(:user_email_change) }

    it { is_expected.to be_truthy }

    context 'when user is blank' do
      let(:email_change) { build(:user_email_change, user: nil) }

      it { is_expected.to be_falsey }
    end

    context 'when change_digest is blank' do
      let(:email_change) { build(:user_email_change, change_digest: '') }

      it { is_expected.to be_falsey }
    end

    context 'when change_digest is not unique' do
      let(:existing_email_change) { create(:user_email_change) }
      let(:email_change) { build(:user_email_change, change_digest: existing_email_change.change_digest) }

      it { is_expected.to be_falsey }
    end

    context 'when email is blank' do
      let(:email_change) { build(:user_email_change, email: '') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#user' do
    subject { email_change.user }
    let(:email_change) { create(:user_email_change) }

    it { is_expected.to be_a User::Core }
  end

  describe '.not_expired' do
    subject { described_class.not_expired }
    let!(:expired_email_change) { create(:user_email_change, created_at: 1.hour.ago) }
    let!(:email_change) { create(:user_email_change) }

    it { is_expected.to eq([ email_change ]) }
  end

  describe '.not_changed' do
    subject { described_class.not_changed }
    let!(:reset_email_change) { create(:user_email_change, changed_at: 1.hour.ago) }
    let!(:email_change) { create(:user_email_change, changed_at: nil) }

    it { is_expected.to eq([ email_change ]) }
  end

  describe '.detected_by' do
    subject { described_class.detected_by(token) }
    let(:token) { 'token' }
    let!(:email_change) { create(:user_email_change, change_digest: described_class.digest('token')) }

    it { is_expected.to eq(email_change) }

    context 'when token is incorrect' do
      let(:token) { 'otherToken' }

      it { expect { subject }.to raise_error(ArgumentError, '期限切れ、もしくは無効なトークンです') }
    end
  end

  describe '#change!' do
    subject { email_change.change! }
    let(:email_change) { create(:user_email_change, changed_at: nil) }

    before do
      travel_to(Time.current)
    end

    it { expect { subject }.to change { email_change.changed_at }.from(nil).to(Time.current) }
  end

  describe '#send_email_changed_email' do
    subject { email_change.send_email_changed_email }
    let(:email_change) { create(:user_email_change) }

    it { expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1) }
  end

  describe '#match?' do
    subject { email_change.match?(token) }
    let(:email_change) { create(:user_email_change, change_digest: described_class.digest(token)) }
    let(:token) { 'token' }

    it { is_expected.to be_truthy }

    context 'when token is incorrect' do
      let(:email_change) { create(:user_email_change, change_digest: described_class.digest('otherToken')) }

      it { is_expected.to be_falsey }
    end
  end
end
