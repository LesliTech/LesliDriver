class CreateCloudDriverEventActions < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000003_actions.json')))
        create_table :cloud_driver_event_actions do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_driver_event_actions, :users, foreign_key: true
        add_reference :cloud_driver_event_actions, :cloud_driver_events, foreign_key: true, index: { name: "driver_event_actions_events" }
    end
end
