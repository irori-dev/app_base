require 'rails_helper'

RSpec.describe Admins::Sidebar::Component, type: :component do
  subject { render_inline(described_class.new) }

  it 'renders links' do
    subject
    expect(page).to have_link nil, href: '/admins/users'
    expect(page).to have_link nil, href: '/admins/contacts'
    expect(page).to have_link nil, href: '/admins/admins'
  end
end
