class ApplicationRecord < ActiveRecord::Base
  include ActiveStorage::Providers

  primary_abstract_class
end
