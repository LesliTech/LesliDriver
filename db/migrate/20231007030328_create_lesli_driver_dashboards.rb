class CreateLesliDriverDashboards < ActiveRecord::Migration[7.0]
  def change
    create_table :lesli_driver_dashboards do |t|

      t.timestamps
    end
  end
end
