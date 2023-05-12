require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid?' do
    subject { user.valid? }
    let(:user) { build(:user) }
    it { is_expected.to be_truthy }

    context 'when uid is nil' do
      let(:user) { build(:user, uid: nil) }
      it { is_expected.to be_falsy }
    end

    context 'when password is nil' do
      let(:user) { build(:user, password: nil) }
      it { is_expected.to be_falsy }
    end

    context 'when uid is not unique' do
      let(:existing_user) { create(:user) }
      let(:user) { build(:user, uid: existing_user.uid) }
      it { is_expected.to be_falsy }
    end
  end
end
