class DocumentCopyService
  def initialize(document, user)
    @document = document
    @user = user
  end

  def perform!
    return if @document&.private || @document.user == @user

    Document.transaction do
      copied_document = @document.dup
      copied_document.user = @user

      if @document.file.attached?
        copied_document.file.attach(@document.file.blob)
      end

      copied_document.save
    end
  end
end
