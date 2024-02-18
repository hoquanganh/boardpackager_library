class Document < ApplicationRecord
  include HasFileAttachment

  belongs_to :user

  def toggle_privacy
    update(private: !private)
  end
end
