require 'rails_helper'

RSpec.describe Navbar::Component, type: :component do
  subject { render_inline(described_class.new(current_user:)) }
  let(:current_user) { nil }

  it 'renders root_path link' do
    subject
    expect(page).to have_link nil, href: '/'
  end

  it 'renders login link' do
    subject
    expect(page).to have_link 'ログイン', href: '/users/session/new'
  end

  it 'renders signup link' do
    subject
    expect(page).to have_link '新規登録', href: '/users/new'
  end

  context 'when current_user is present' do
    let(:current_user) { create(:user_core) }

    it 'renders root_path link' do
      subject
      expect(page).to have_link nil, href: '/'
    end

    it 'renders mypage link' do
      subject
      expect(page).to have_link 'マイページ', href: '/users/mypage'
    end
  end
end
