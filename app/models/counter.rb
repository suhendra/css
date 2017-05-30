class Counter < ApplicationRecord
  has_many :entries
  has_one :user
end
