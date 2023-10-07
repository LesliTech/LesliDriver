# =begin

# Copyright (c) 2023, all rights reserved.

# All the information provided by this platform is protected by international laws related  to
# industrial property, intellectual property, copyright and relative international laws.
# All intellectual or industrial property rights of the code, texts, trade mark, design,
# pictures and any other information belongs to the owner of this platform.

# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.

# For more information read the license file including with this software.

# // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
# // ·

# =end


# include helpers, configuration & initializers for request tests
require "lesli_service_helper"

RSpec.describe CloudDriver::Event::AttendantServices, type: :model do

    it "is expected to destroy an event attendant" do
        current_user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)

        event = FactoryBot.create(:cloud_driver_event, {
            users_id: current_user.id,
            user_main_id: current_user.id,
        })

        event_attendant_params = {
            users_id: other_user.id
        }

        # Create the attendant to be deleted
        create_attendant_response = CloudDriver::Event::AttendantServices.create(current_user, event.id, event_attendant_params)

        attendant = create_attendant_response.payload

        response = CloudDriver::Event::AttendantServices.destroy(current_user, event.id, attendant.id)

        # shared examples
        expect_service_response_with_successful(response)
    end

    it "is expected not to destroy an event attendant because of nil attendant" do
        current_user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)

        event = FactoryBot.create(:cloud_driver_event, {
            users_id: current_user.id,
            user_main_id: current_user.id,
        })

        event_attendant_params = {
            users_id: other_user.id
        }

        # Create the attendant to be deleted
        create_attendant_response = CloudDriver::Event::AttendantServices.create(current_user, event.id, event_attendant_params)

        attendant = create_attendant_response.payload

        response = CloudDriver::Event::AttendantServices.destroy(current_user, event.id, attendant.id + 1)

        # shared examples
        expect_service_response_with_error(response)
    end

end
