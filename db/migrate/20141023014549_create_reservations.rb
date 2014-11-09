class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      #if user is admin, admin will add these feilds manually, otherwise they will be null
      t.string :name, limit: 50
      t.string :phone, limit: 20

      t.string :gtid, limit: 50

      t.datetime :start
      t.integer :duration
      t.integer :court
      t.string :guest1, limit: 50
      t.string :guest2, limit: 50
      t.string :guest3, limit: 50
      t.timestamps
    end
  end
end
