class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :counter

  def self.feedback_option_list
    # sangat puas-puas-cukup puas-tidak puas
    [
      ["Sangat Puas", 3],
      ["Puas", 2],
      ["Cukup Puas", 1],
      ["Tidak Puas", 0]
    ]
  end
end
