require 'rails_helper'

RSpec.describe Notifier::Slack, type: :model do
  describe '#send' do
    subject { notifier.send(message) }

    let(:notifier) { Notifier::Slack.new }
    let(:message) { 'message' }
    let(:client) { double('client') }

    before do
      allow(Slack::Notifier).to receive(:new).and_return(client)
      allow(client).to receive(:ping).with(message)
    end

    it 'sends message to slack' do
      subject
      expect(client).to have_received(:ping).with(message)
    end
  end
end
