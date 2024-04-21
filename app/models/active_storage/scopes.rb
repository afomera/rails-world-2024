module ActiveStorage::Scopes
  extend ActiveSupport::Concern

  class_methods do
    def search_by_filename(filename)
      return all if filename.blank?

      where("filename LIKE ?", "%#{filename}%")
    end
  end
end
