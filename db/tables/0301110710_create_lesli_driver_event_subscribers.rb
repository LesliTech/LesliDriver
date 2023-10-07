class CreateCloudDriverEventSubscribers < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000007_subscribers.json')))
        create_table :cloud_driver_event_subscribers do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_driver_event_subscribers, :users, foreign_key: true, index: { name: 'driver_event_subscribers_users' }
        add_reference :cloud_driver_event_subscribers, :cloud_driver_events, foreign_key: true, index: { name: 'driver_event_subscribers_events' }
    end
end
