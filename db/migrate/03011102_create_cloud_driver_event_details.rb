class CreateCloudDriverEventDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_driver_event_details do |t|
            t.string    :title, required: true
            t.text      :description
            t.datetime  :time_start
            t.datetime  :time_end
            t.string    :location
            t.string    :url
            t.timestamps
        end
        add_reference :cloud_driver_event_details, :cloud_driver_events, foreign_key: true
    end
end
