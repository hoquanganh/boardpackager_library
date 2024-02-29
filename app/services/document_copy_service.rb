class DocumentCopyService
  def initialize(document, user)
    @document = document
    @user = user
  end

  def perform!
    return false if @document&.private || @document.user == @user

    Document.transaction do
      begin
        copied_document = @document.dup
        copied_document.user = @user

        if @document.file.attached?
          copied_document.file.attach(@document.file.blob)
        end

        copied_document.save!
        true
      rescue StandardError => e
        Rails.logger.error("An error occurred while performing the transaction: #{e.message}")
        false
      end
    end
  end
end
