class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  validates :password, confirmation: true

  has_many :entries
  belongs_to :counter

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def counter_name
    self.counter.name
  end

  def self.role_list
    [
      ['CS', 'CS'],
      ['Admin', 'Admin']
    ]
  end

end
