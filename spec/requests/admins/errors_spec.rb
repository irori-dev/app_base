require 'rails_helper'

RSpec.describe 'Admins::Errors', type: :request do
  let(:admin) { create(:admin) }

  describe 'GET /admins/errors/trigger' do
    context 'when not signed in as admin' do
      it 'redirects to admin sign in page' do
        get '/admins/errors/trigger'
        expect(response).to redirect_to(new_admins_session_path)
      end
    end

    context 'when signed in as admin' do
      before { sign_in(admin) }

      it 'can access the error trigger endpoint' do
        get '/admins/errors/trigger'
        # 実際に例外が発生するため、ステータスコードは500になる
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'triggers different error types' do
        # StandardError (デフォルト)
        get '/admins/errors/trigger'
        expect(response).to have_http_status(:internal_server_error)

        # RuntimeError
        get '/admins/errors/trigger', params: { type: 'runtime' }
        expect(response).to have_http_status(:internal_server_error)

        # ArgumentError
        get '/admins/errors/trigger', params: { type: 'argument' }
        expect(response).to have_http_status(:internal_server_error)

        # ActiveRecord::RecordNotFound
        get '/admins/errors/trigger', params: { type: 'not_found' }
        expect(response).to have_http_status(:not_found)

        # Timeout::Error
        get '/admins/errors/trigger', params: { type: 'timeout' }
        expect(response).to have_http_status(:internal_server_error)

        # Database Error
        get '/admins/errors/trigger', params: { type: 'database' }
        expect(response).to have_http_status(:internal_server_error)

        # ZeroDivisionError
        get '/admins/errors/trigger', params: { type: 'zero_division' }
        expect(response).to have_http_status(:internal_server_error)

        # NoMethodError
        get '/admins/errors/trigger', params: { type: 'nil' }
        expect(response).to have_http_status(:internal_server_error)

        # Unknown type
        get '/admins/errors/trigger', params: { type: 'unknown' }
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
