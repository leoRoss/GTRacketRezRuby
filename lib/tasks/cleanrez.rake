namespace :delete do
	desc "Rake task to get events data"
	task :rez => :environment do
		Reservation.where('created_at <= ?', Time.now - 6.days).destroy_all
	end
end

