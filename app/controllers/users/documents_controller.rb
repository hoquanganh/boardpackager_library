class Users::DocumentsController < ApplicationController
  before_action :set_user

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

  private

  def set_user
    @user = User.find(params[:user_id])
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
