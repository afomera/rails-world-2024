module ActiveStorage::UserAttachment
  extend ActiveSupport::Concern

  included do
    belongs_to :user, optional: true, default: -> { Current.user }
  end
end
