class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :entries
  belongs_to :counter

  def email_required?
    false
  end

  def email_changed?
    false
  end

end
