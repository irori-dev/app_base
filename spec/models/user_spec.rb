require 'rails_helper'

RSpec.describe User do
  describe '.table_name_prefix' do
    subject { described_class.table_name_prefix }

    it { is_expected.to eq 'user_' }
  end
end
