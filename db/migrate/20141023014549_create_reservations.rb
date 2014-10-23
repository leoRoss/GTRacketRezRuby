class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :gtid
      t.string :name, limit: 50
      t.datetime :start
      t.integer :duration
      t.string :phone, limit: 20
      t.integer :court
      t.integer :rackets
      t.integer :ball
      t.integer :goggles
      t.string :guest1, limit: 50
      t.string :guest2, limit: 50
      t.string :guest3, limit: 50

      t.timestamps
    end
  end
end
