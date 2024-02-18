module HasFileAttachment
  extend ActiveSupport::Concern

  included do
    has_one_attached :file
  end

  def file_url
    return unless file&.attached?

    case file.blob.service_name
    when "local"
      Rails.application.routes.url_helpers.rails_blob_path(file, disposition: 'attachment', only_path: true)
    when 'amazon'
      file.blob.url(expires_in: 1.hour, disposition: 'attachment')
    end
  end
end
