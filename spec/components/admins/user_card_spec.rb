require 'rails_helper'

RSpec.describe Admins::UserCard::Component, type: :component do
  subject { render_inline(described_class.new(user:)) }
  let(:user) { create(:user_core) }

  it 'renders id, email, created_at' do
    subject
    expect(page).to have_content(user.id)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.created_at.strftime('%Y/%m/%d %H:%M'))
  end
end
