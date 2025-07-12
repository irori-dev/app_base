require 'rails_helper'

RSpec.describe 'Admins::Contacts', type: :request do
  let(:admin) { create(:admin) }
  let(:contact) { create(:contact) }

  describe 'GET /admins/contacts' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get admins_contacts_path
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in(admin) }

      it 'returns success' do
        get admins_contacts_path
        expect(response).to have_http_status(:success)
      end

      it 'displays contacts' do
        contact
        get admins_contacts_path
        expect(response.body).to include(contact.name)
        expect(response.body).to include(contact.email)
        expect(response.body).to include(contact.phone_number)
      end

      context 'with search params' do
        let!(:contact1) { create(:contact, email: 'test@example.com', name: 'Test User') }
        let!(:contact2) { create(:contact, email: 'other@example.com', name: 'Other User') }

        it 'filters contacts by email' do
          get admins_contacts_path(q: { email_cont: 'test' })
          expect(response.body).to include('test@example.com')
          expect(response.body).not_to include('other@example.com')
        end

        it 'filters contacts by name' do
          get admins_contacts_path(q: { name_cont: 'Test' })
          expect(response.body).to include('Test User')
          expect(response.body).not_to include('Other User')
        end
      end

      context 'with pagination' do
        before { create_list(:contact, 30) }

        it 'paginates results' do
          get admins_contacts_path
          expect(response.body).to include('contacts-page-1')
        end
      end

      context 'with sorting' do
        let!(:old_contact) { create(:contact, email: 'old@example.com', created_at: 1.day.ago) }
        let!(:new_contact) { create(:contact, email: 'new@example.com', created_at: 1.hour.ago) }

        it 'sorts by id desc by default' do
          get admins_contacts_path
          # The newer contact should appear first (higher ID)
          expect(response.body.index(new_contact.email)).to be < response.body.index(old_contact.email)
        end
      end
    end
  end
end
