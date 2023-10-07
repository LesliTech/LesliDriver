# =begin

# Copyright (c) 2022, all rights reserved.

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
require "lesli_request_helper"

RSpec.describe "Tests for Lesli 3" do
    describe "POST:/driver/catalog/event_types", type: :request do
        include_context "request user authentication"

        it "is expected to create an event type" do

            event_type = FactoryBot.attributes_for(:cloud_driver_catalog_event_type)

            post("/driver/catalog/event_types.json", params: {event_type: event_type})

            # shared examples
            expect_response_with_successful

            # custom examples
            expect(response_body["name"]).to eq(event_type[:name])
        end

        it "is expected to receive an error if the event type name is empty" do

            event_type = FactoryBot.attributes_for(:cloud_driver_catalog_event_type)
            event_type[:name] = nil

            post("/driver/catalog/event_types.json", params: {event_type: event_type})

            # shared examples
            expect_response_with_error

            # custom examples
            expect(response_body["message"]).to eq("Name can't be blank")
        end
    end
end
