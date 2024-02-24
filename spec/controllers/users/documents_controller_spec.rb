require 'rails_helper'

RSpec.describe Users::DocumentsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  let(:user) { create(:user) }
  let(:document) { create(:document, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns the user's documents to @documents" do
      get :index, params: { user_id: user.id }
      expect(assigns(:documents)).to eq(user.documents.order(created_at: :desc))
    end
  end

  describe "GET #new" do
    it "assigns a new document to @document" do
      get :new, params: { user_id: user.id }
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) { { user_id: user.id, file: [fixture_file_upload('document.txt', 'text/plain')] } }

      it "creates a new document" do
        expect {
          post :create, params: valid_params
        }.to change(Document, :count).by(1)
      end

      it "redirects to the user's documents path" do
        post :create, params: valid_params
        expect(response).to redirect_to(user_documents_path(user))
      end

      it "sets a flash success message" do
        post :create, params: valid_params
        expect(flash[:success]).to eq("document.txt uploaded successfully.")
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { user_id: user.id, file: nil } }

      it "does not create a new document" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Document, :count)
      end

      it "sets a flash error message" do
        allow_any_instance_of(Document).to receive(:save).and_return(false)
        allow_any_instance_of(Document).to receive_message_chain(:errors, :full_messages).and_return(['Error message'])

        post :create, params: { user_id: user.id, file: fixture_file_upload('document.txt', 'text/plain') }
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested document" do
      delete :destroy, params: { user_id: user.id, id: document.id }
      expect(Document.exists?(document.id)).to be_falsey
    end

    it "redirects to the user's documents path" do
      delete :destroy, params: { user_id: user.id, id: document.id }
      expect(response).to redirect_to(user_documents_path(user))
    end

    it "sets a flash notice message" do
      delete :destroy, params: { user_id: user.id, id: document.id }
      expect(flash[:notice]).to eq("Document deleted successfully.")
    end
  end

  describe "POST #copy" do
    let(:document_copy_service) { instance_double(DocumentCopyService) }

    before do
      allow(DocumentCopyService).to receive(:new).with(document, user).and_return(document_copy_service)
    end

    context "when the document is successfully copied" do
      before do
        allow(document_copy_service).to receive(:perform!).and_return(true)
        post :copy, params: { user_id: user.id, id: document.id }
      end

      it "redirects to user_documents_path with a success notice" do
        expect(response).to redirect_to(user_documents_path(user))
        expect(flash[:notice]).to eq("Document copied successfully.")
      end
    end

    context "when the document fails to be copied" do
      before do
        allow(document_copy_service).to receive(:perform!).and_return(false)
        post :copy, params: { user_id: user.id, id: document.id }
      end

      it "redirects to user_documents_path with an alert" do
        expect(response).to redirect_to(user_documents_path(user))
        expect(flash[:alert]).to eq("Failed to copy the document.")
      end
    end
  end

  describe "POST #toggle_privacy" do
    context "when privacy is successfully toggled" do
      before do
        allow(document).to receive(:toggle_privacy).and_return(true)
        post :toggle_privacy, params: { user_id: user.id, id: document.id }, format: :json
      end

      it "renders JSON response with success true" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "success" => true })
      end
    end

    context "when privacy toggle fails" do
      before do
        allow_any_instance_of(Document).to receive(:toggle_privacy).and_return(false)
        post :toggle_privacy, params: { user_id: user.id, id: document.id }, format: :json
      end

      it "renders JSON response with success false and error message" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "success" => false, "error" => "Failed to toggle privacy" })
      end
    end
  end
end
