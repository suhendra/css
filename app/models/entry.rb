class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :counter

  attr_accessor :range_type, :date_start, :date_end

  def self.feedback_option_list
    # sangat puas-puas-cukup puas-tidak puas
    [
      ["Sangat Puas", 3],
      ["Puas", 2],
      ["Cukup Puas", 1],
      ["Tidak Puas", 0]
    ]
  end

  def self.range_type_list
    [
      ["Yearly", "yearly"],
      ["Monthly", "monthly"],
      ["Weekly", "weekly"],
      ["Daily", "daily"]
    ]
  end
end
