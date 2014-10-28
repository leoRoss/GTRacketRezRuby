class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :gtid, limit: 20
      t.string :gtuser, limit:20
      t.string :name, limit: 50
      t.string :phone, limit: 20
      t.datetime :start
      t.integer :duration
      t.integer :court
      t.string :guest1, limit: 50
      t.string :guest2, limit: 50
      t.string :guest3, limit: 50
      t.string :email
      t.timestamps
    end
  end
end
