require 'rails_helper'

RSpec.describe CreateSampleUsersJob, type: :job do
  describe '#perform' do
    let(:count) { 2 }

    before do
      allow(ActionCable.server).to receive(:broadcast)
      allow_any_instance_of(described_class).to receive(:sleep)
      allow(ApplicationController.renderer).to receive(:render).and_return('card')
    end

    it 'creates users' do
      expect do
        described_class.perform_now(count)
      end.to change(User::Core, :count).by(count)
    end

    it 'broadcasts created user cards' do
      described_class.perform_now(count)
      expect(ActionCable.server).to have_received(:broadcast)
        .exactly(count).times
    end
  end
end
