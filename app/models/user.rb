class User < ActiveRecord::Base

  has_many :reservations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :phone, presence: true #length: { minimum: 5 }
  validates  :name, presence: true

end
