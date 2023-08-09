class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :authentication, :dependent => :destroy
  accepts_nested_attributes_for :authentication

end
