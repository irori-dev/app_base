require 'rails_helper'

RSpec.describe Toast::Component, type: :component do
  subject { render_inline(described_class.new(type:, message:)) }
  let(:type) { :success }
  let(:message) { 'Success' }

  it 'renders message' do
    subject
    expect(page).to have_text message
  end

  context 'when type is success' do
    it 'renders success toast' do
      subject
      expect(page).to have_css 'div.bg-green-100.text-green-500'
    end
  end

  context 'when type is error' do
    let(:type) { :error }

    it 'renders error toast' do
      subject
      expect(page).to have_css 'div.bg-red-100.text-red-500'
    end
  end

  context 'when type is warning' do
    let(:type) { :warning }

    it 'renders warning toast' do
      subject
      expect(page).to have_css 'div.bg-orange-100.text-orange-500'
    end
  end

  context 'when type is other' do
    let(:type) { :other }

    it 'renders default toast' do
      subject
      expect(page).to have_css 'div.bg-gray-100.text-gray-500'
    end
  end
end
