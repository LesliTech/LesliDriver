=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
require "lesli_request_helper"

RSpec.describe "CloudDriver::Calendar" do
    describe "GET:/calendars", type: :request do
        include_context "request user authentication"

        it "is expected to get the default calendar and personal calendar of that user" do
            @user = FactoryBot.create(:user)

            get("/driver/calendars.json")

            # shared examples
            expect_response_with_pagination

            # custom examples
            expect(response_body["records"].length).to be >= 2
            expect(response_body["records"][0]).to have_key("name")
            expect(response_body["records"][0]).to have_key("default")
            expect(response_body["records"][0]).to have_key("source_code")
        end
    end
end
