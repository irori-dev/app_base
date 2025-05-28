require 'rails_helper'

RSpec.describe 'Authenticatable', type: :controller do
  controller(ApplicationController) do
    include Authenticatable

    before_action :require_resource!, only: :show
    before_action :require_no_resource!, only: :index

    def index
      head :ok
    end

    def show
      head :ok
    end

    private

    def resource_class
      User::Core
    end

    def session_key
      :user_id
    end

    def sign_in_path
      '/sign_in'
    end

    def after_sign_in_path
      '/after_sign_in'
    end
  end

  before do
    routes.draw do
      get 'index' => 'anonymous#index'
      get 'show' => 'anonymous#show'
    end
  end

  let(:user) { create(:user_core) }

  describe '#require_resource!' do
    context 'when not signed in' do
      it 'redirects to sign in path' do
        get :show
        expect(response).to redirect_to('/sign_in')
      end
    end

    context 'when signed in' do
      before { session[:user_id] = user.id }

      it 'allows access' do
        get :show
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#require_no_resource!' do
    context 'when signed in' do
      before { session[:user_id] = user.id }

      it 'redirects to after sign in path' do
        get :index
        expect(response).to redirect_to('/after_sign_in')
      end
    end

    context 'when not signed in' do
      it 'allows access' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#sign_in and #sign_out' do
    it 'updates session and current resource' do
      controller.sign_in(user)
      expect(session[:user_id]).to eq(user.id)
      expect(controller.current_resource).to eq(user)

      controller.sign_out
      expect(session[:user_id]).to be_nil
      expect(controller.current_resource).to be_nil
    end
  end
end
