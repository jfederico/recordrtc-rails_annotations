class Account < ApplicationRecord
  has_many :recordings, dependent: :destroy

  validates_presence_of :user_id
end
