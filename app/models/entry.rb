class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :counter
end
