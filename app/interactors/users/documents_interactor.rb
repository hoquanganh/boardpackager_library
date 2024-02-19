class Users::DocumentsInteractor
  def initialize(user, target_user)
    @user = user
    @target_user = target_user
  end

  def call
    fetch_documents
  end

  private

  def fetch_documents
    if @user == @target_user
      @target_user.documents.order(created_at: :desc)
    else
      @target_user.documents.where("private IS NULL OR private = ?", false).order(created_at: :desc)
    end
  end
end
