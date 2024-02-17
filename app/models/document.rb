class Document < ApplicationRecord
  belongs_to :user
  has_one_attached :file

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
