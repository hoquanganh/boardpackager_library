module FlashHelper
  def flash_class(key)
    case key.to_sym
    when :notice, :success
      'success'
    when :alert, :error
      'danger'
    when :info
      'info'
    else
      'primary'
    end
  end
end
