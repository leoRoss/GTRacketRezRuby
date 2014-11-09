class AddUserToReservations < ActiveRecord::Migration
  def change
    add_belongs_to :reservations, :user, index: true
  end
end
