require 'rails_helper'

RSpec.describe CatForm::Component, type: :component do
  subject { render_inline(described_class.new(cat:)) }
  let(:cat) { create(:cat, name: 'cat_name', age: 30) }

  it 'renders cat name and age input' do
    subject
    expect(page).to have_css("input[value='#{cat.name}']")
    expect(page).to have_css("input[value='#{cat.age}']")
  end

  it 'renders submit button' do
    subject
    expect(page).to have_css('input[type="submit"]')
  end

  it 'renders modal close button' do
    subject
    expect(page).to have_css('button[data-action="click->modal#close"]')
  end
end
