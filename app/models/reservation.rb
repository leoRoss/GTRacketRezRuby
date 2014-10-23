class Reservation < ActiveRecord::Base
	  #add more validation to our reservations
  #we should ensure phone, name, start, duration, and court are there
  validates :phone, presence: true #length: { minimum: 5 }
  validates  :name, presence: true
  #validates  :start, presence: true
  validates  :duration, presence: true
  validates  :court, presence: true
end
