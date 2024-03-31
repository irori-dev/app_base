require 'rails_helper'

RSpec.describe Modal::Component, type: :component do
  subject do
    render_inline(described_class.new) do
      'Sample content'
    end
  end

  it 'renders turbo-frame' do
    subject
    expect(page).to have_selector "turbo-frame[id='modal']"
  end

  it 'renders content' do
    subject
    expect(page).to have_text 'Sample content'
  end
end
