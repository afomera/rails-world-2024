class AddUserToActiveStorageAttachment < ActiveRecord::Migration[8.0]
  def change
    add_reference :active_storage_attachments, :user, null: true, foreign_key: true
  end
end
