module Users::DocumentsHelper
  def show_delete_link?
    @user == current_user || current_user.admin?
  end

  def show_copy_link?(document)
    !document.private && document.user != current_user
  end
end
