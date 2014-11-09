class Reservation < ActiveRecord::Base

  belongs_to :user
	  #add more validation to our reservations
  #we should ensure phone, name, start, duration, and court are there
  #validates :gtid, presence: true dont validate this, not currently required
  validates  :start, presence: true
  validates  :duration, presence: true
  validates  :court, presence: true
end
