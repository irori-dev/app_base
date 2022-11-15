require 'rails_helper'

RSpec.describe Cat::Component, type: :component do
  subject { render_inline(described_class.new(cat:)) }
  let(:cat) { create(:cat, name: 'cat_name', age: 30) }

  it 'render turbo_frame_tag' do
    subject
    expect(page).to have_css "turbo-frame#cat_#{cat.id}"
  end

  it 'renders cat name and age' do
    subject
    expect(page).to have_text 'cat_name'
    expect(page).to have_text '30'
  end

  it 'renders edit and delete buttons' do
    subject
    expect(page).to have_link '編集', href: "/cats/#{cat.id}/edit"
    expect(page).to have_css("form[action='/cats/#{cat.id}']")
  end
end
