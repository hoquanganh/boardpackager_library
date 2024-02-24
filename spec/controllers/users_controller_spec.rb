require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'assigns all users to @users' do
        get :index
        expect(assigns(:users)).to include(user)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not authenticated' do
      it 'redirects to login page' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is not an admin' do
      before { sign_in user }

      it 'redirects to root path with alert' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is an admin' do
      before { sign_in admin_user }

      it 'deletes the user' do
        expect { delete :destroy, params: { id: user.id } }.to change(User, :count).by(-1)
      end

      it 'redirects to users path with notice' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('User deleted successfully!')
      end
    end
  end
end
