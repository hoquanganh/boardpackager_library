class Users::DocumentsController < ApplicationController
  before_action :set_user
  before_action :find_document, only: %i(copy toggle_privacy)

  def index
    @documents = @user.documents.order(created_at: :desc)
  end

  def show
    @document = @user.documents.find(params[:id])
  end

  def new
    @document = @user.documents.new
  end

  def create
    files = Array(params[:file]).compact_blank

    files.each do |file|
      @document = @user.documents.build(file_attrs(file))
      @document.file.attach(file)

      if @document.save
        flash[:success] = "#{file.original_filename} uploaded successfully."
      else
        flash[:error] = @document.errors.full_messages.join(', ')
      end
    end

    redirect_to user_documents_path(@user), notice: 'Documents uploaded successfully.'
  end

  def destroy
    @document = @user.documents.find(params[:id])
    @document.destroy
    redirect_to user_documents_path(@user), notice: 'Document deleted successfully.'
  end

  def copy
    if DocumentCopyService.new(@document, current_user).perform!
      redirect_to user_documents_path(current_user), notice: 'Document copied successfully.'
    else
      redirect_to user_documents_path(current_user), alert: 'Failed to copy the document.'
    end
  end

  def toggle_privacy
    if @document.toggle_privacy
      render json: { success: true }
    else
      render json: { success: false, error: "Failed to toggle privacy" }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def find_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:file)
  end

  def file_attrs(file)
    {
      name: file.original_filename,
      file_size: file.size
    }
  end
end
