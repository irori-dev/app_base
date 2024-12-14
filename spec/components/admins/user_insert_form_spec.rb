require 'rails_helper'

RSpec.describe Admins::UserInsertForm::Component, type: :component do
  subject { render_inline(described_class.new) }

  it 'renders form' do
    subject
    expect(page).to have_selector 'form'
  end
end
