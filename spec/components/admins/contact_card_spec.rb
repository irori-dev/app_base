require 'rails_helper'

RSpec.describe Admins::ContactCard::Component, type: :component do
  subject { render_inline(described_class.new(contact:)) }
  let(:contact) { create(:contact) }

  it 'renders id, name, email, phone_number, text, created_at' do
    subject
    expect(page).to have_content(contact.id)
    expect(page).to have_content(contact.name)
    expect(page).to have_content(contact.email)
    expect(page).to have_content(contact.phone_number)
    expect(page).to have_content(contact.text)
    expect(page).to have_content(contact.created_at.strftime('%Y/%m/%d %H:%M'))
  end
end
