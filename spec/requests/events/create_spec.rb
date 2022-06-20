# =begin

# Copyright (c) 2021, all rights reserved.

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

RSpec.describe "Tests for DeutschLeibrenten", :unless => defined?(DeutscheLeibrenten) do
    describe "POST:/driver/events", type: :request do
        include_context "request user authentication"

        it "is expected to create an event with all the data" do

            event = FactoryBot.attributes_for(:cloud_driver_event, {
                users_id: @current_user.id,
                user_main_id: @current_user.id,
                cloud_driver_accounts_id: @current_user.account.id
            })

            post("/driver/events.json", params: {event: event})

            # shared examples
            expect_response_with_successful

            # custom examples
            expect(response_json["data"]["organizer_name"]).to eq(@current_user.full_name)
            expect(response_json["data"]["detail_attributes"]["title"]).to eq(event[:detail_attributes][:title])
            expect(response_json["data"]["detail_attributes"]["description"]).to eq(event[:detail_attributes][:description])
            expect(response_json["data"]["detail_attributes"]["location"]).to eq(event[:detail_attributes][:location])
            expect(response_json["data"]["detail_attributes"]["budget"].to_f).to eq(event[:detail_attributes][:budget])
            expect(response_json["data"]["detail_attributes"]["real_cost"].to_f).to eq(event[:detail_attributes][:real_cost])
            expect(response_json["data"]["detail_attributes"]["signed_up_count"].to_i).to eq(event[:detail_attributes][:signed_up_count])
            expect(response_json["data"]["detail_attributes"]["showed_up_count"].to_i).to eq(event[:detail_attributes][:showed_up_count])
        end


        it "is expected to create an event with the minimum data" do

            event = FactoryBot.attributes_for(:cloud_driver_event)
            event.slice(:detail_attributes)
            event[:detail_attributes] = event[:detail_attributes].slice(:title, :event_date)

            event = {
                detail_attributes: {
                    "title": Faker::Sports::Football.competition,
                    "event_date": Time.current
                }
            }

            post("/driver/events.json", params: { "event": event})

            # shared examples
            expect_response_with_successful

            # custom examples
            expect(response_json["data"]["organizer_name"]).to eq(@current_user.full_name)
            expect(response_json["data"]["detail_attributes"]["title"]).to eq(event[:detail_attributes][:title])

        end


        it "is expected to respond with error if event is empty" do
            post("/driver/events.json", params: { "event": { "detail_attributes": {} }})

            # shared examples
            expect_response_with_error

            # custom examples
            expect(response_error["message"]).to eq("Missing event data")
        end

        it "is expected to respond with error if event title is empty" do

            event = {
                detail_attributes: {
                    "event_date": Faker::Time.between(from: DateTime.now, to: DateTime.now + 3.days)
                }
            }

            post("/driver/events.json", params: { "event": event})

            # shared examples
            expect_response_with_error

            # custom examples
            expect(response_json["error"]["message"]).to eq("Missing event data")
        end

        it "is expected to respond with error if event date is empty" do

            event = {
                detail_attributes: {
                    "title": Faker::Sports::Football.competition,
                }
            }

            post("/driver/events.json", params: { "event": event})

            # shared examples
            expect_response_with_errorr

            # custom examples
            expect(response_["error"]["message"]).to eq("Missing event data")
        end
    end
end
