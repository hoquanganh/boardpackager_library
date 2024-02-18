class DocumentCopyService
  def initialize(document_id, user)
    @document = Document.find_by(id: document_id)
    @user = user
  end

  def perform!
    return if @document&.private || @document.user == @user

    copied_document = @document.dup
    copied_document.user = @user
    copied_document.save!
  end
end
