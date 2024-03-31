require 'rails_helper'

RSpec.describe Admins::AdminCard::Component, type: :component do
  subject { render_inline(described_class.new(admin:, current_admin:)) }
  let(:admin) { create(:admin) }
  let(:current_admin) { create(:admin) }

  it 'renders id, email' do
    subject
    expect(page).to have_content(admin.id)
    expect(page).to have_content(admin.email)
  end

  it 'does not renders edit, delete buttons' do
    subject
    expect(page).to have_link '編集', href: "/admins/admins/#{admin.id}/edit"
    expect(page).to have_css "form[action='/admins/admins/#{admin.id}']"
  end
end
