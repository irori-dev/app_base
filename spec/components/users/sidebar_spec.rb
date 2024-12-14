require 'rails_helper'

RSpec.describe Users::Sidebar::Component, type: :component do
  subject { render_inline(described_class.new) }

  it 'renders change email link' do
    subject
    expect(page).to have_link 'メールアドレス変更', href: '/users/email_changes/new'
  end

  it 'renders logout link' do
    subject
    expect(page).to have_link 'ログアウト', href: '/users/session'
  end
end
