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

RSpec.describe CloudDriver::Event::ProposalServices, type: :model do

    it "is expected to create an event proposal" do
        current_user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)

        event = FactoryBot.create(:cloud_driver_event, {
            users_id: current_user.id,
            user_main_id: current_user.id,
            is_proposal: true,
        })

        event_proposal_params = {
            users_id: other_user.id,
            event_date: LC::Date2.new.get,
        }

        response = CloudDriver::Event::ProposalServices.create(current_user, event.id, event_proposal_params)

        # shared examples
        expect_service_response_with_successful(response)

        # custom examples
        expect(service_response_body).to be_a CloudDriver::Event::Proposal
        expect(service_response_body.id).not_to be_nil
    end

    it "is expected not to create an event proposal because of nil event" do
        current_user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)

        event_id = CloudDriver::Event.all.count + 1

        event_proposal_params = {
            users_id: other_user.id
        }

        response = CloudDriver::Event::ProposalServices.create(current_user, event_id, event_proposal_params)

        # shared examples
        expect_service_response_with_error(response)
    end

end
