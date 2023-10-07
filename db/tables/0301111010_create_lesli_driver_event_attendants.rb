class CreateCloudDriverEventAttendants < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_driver_event_attendants do |t|
            t.datetime :confirmed_at

            # acts_as_paranoid
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference(:cloud_driver_event_attendants, :user,  foreign_key: { to_table: :users })
        add_reference(:cloud_driver_event_attendants, :event, foreign_key: { to_table: :cloud_driver_events })
    end
end
