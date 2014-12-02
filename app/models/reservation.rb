class Reservation < ActiveRecord::Base

  belongs_to :user
	  #add more validation to our reservations
  #we should ensure phone, name, start, duration, and court are there
  #validates :gtid, presence: true dont validate this, not currently required
  validates  :start, presence: true
  validates  :duration, presence: true
  validates  :court, presence: true
  validates  :user_id, presence: true
  validates  :phone, presence: true
  validates  :name, presence: true
  before_save :rule_check

  def rule_check 
  	count = 0
  	@reservations = Reservation.all

  	@reservations.each do |rez| 
  		if self.phone == rez.phone && self.start.to_date == rez.start.to_date
        Error.add(:reservation, "Daily Limit Surpased")
  		end
      if self.court == rez.court
    		if self.start < rez.start+rez.duration.minutes && self.start > rez.start || self.start + self.duration.minutes < rez.start+rez.duration.minutes && self.start + self.duration.minutes > rez.start 
    		 	Error.add(:reservation, "Time Conflict")
    		end
        if self.start < rez.start && self.start+self.duration.minutes > rez.start + rez.duration.minutes
          Error.add(:reservation, "Time Conflict")
        end
      end
  	end
  end

end
