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
require "lesli_request_helper"

RSpec.describe "CloudDriver::Event" do
    describe "GET:/driver/events/:id", type: :request do
        include_context "request user authentication"

        it "is expected to show the event data" do

            event = FactoryBot.create(:cloud_driver_event, {
                users_id: @current_user.id,
                user_main_id: @current_user.id,
                cloud_driver_accounts_id: @current_user.account.id
            })

            get("/driver/events/#{event.id}.json")

            # shared examples
            expect_response_with_successful

            # custom examples
            expect(response_body["organizer_name"]).to eq(@current_user.full_name)
            expect(response_body["title"]).to eq(event.title)
            expect(response_body["description"]).to eq(event.description)
            expect(response_body["location"]).to eq(event.location)
            expect(response_body["budget"].to_f).to eq(event.budget)
            expect(response_body["real_cost"].to_f).to eq(event.real_cost)
            expect(response_body["signed_up_count"].to_i).to eq(event.signed_up_count)
            expect(response_body["showed_up_count"].to_i).to eq(event.showed_up_count)

        end

    end
end
