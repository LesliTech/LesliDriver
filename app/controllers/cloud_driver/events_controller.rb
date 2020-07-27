=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
require_dependency "cloud_driver/application_controller"

module CloudDriver
    class EventsController < ApplicationLesliController
        before_action :set_event, only: [:update, :destroy, :show]

        # GET /events
        def index
            respond_with_successful()
        end

        # GET /events/1
        def show
            respond_to do |format|
                format.html { }
                format.json do 
                    return responseWithNotFound unless @event
                    respond_with_successful(@event.show(current_user))
                end
                format.ics do
                    return responseWithNotFound unless @event
                    render plain: @event.download
                end
            end
        end

        # GET /events/new
        def new
            @event = Event.new
        end

        # GET /events/1/edit
        def edit
        end

        # POST /events
        def create
            event = current_user.account.driver.calendars.default.events.new(event_params)            
            event.account = current_user.account
            event.user_creator = current_user
            event.set_workflow

            unless event_params[:user_main_id]
                event.user_main = current_user                
            end

            if event.save
                Event.log_activity_create(current_user, event)
                event.attendants.create(users_id: event.user_main.id)
                respond_with_successful(event.show(current_user))
            else
                respond_with_error(event.errors.full_messages.to_sentence)
            end
        end

        # PATCH/PUT /events/1
        def update
            return responseWithNotFound unless @event
            return responseWithUnauthorized unless @event.is_editable_by?(current_user)

            if @event.update(event_params)
                respond_with_successful(@event)
            else
                respond_with_error(@event.errors)
            end
        end

        # DELETE /events/1
        def destroy
            return responseWithNotFound unless @event
            return responseWithUnauthorized unless @event.is_editable_by?(current_user)

            if @event.destroy
                return respond_with_successful
            else
                return respond_with_error(@event.errors.full_messages.to_sentence)
            end
        end

        def events_by_model
            events = Courier::Driver::Event.by_model(params[:model_type], params[:model_id], current_user, @query)
            respond_with_successful(events)
        end

        def options
            # parse query string here to include or exclude options
            respond_with_successful({
                event_types: Event.event_types.map {|k, _| {value: k, text: I18n.t("driver.events.enum_event_type_#{k}")}}
            })
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_event
            @event = current_user.account.driver.events.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def event_params
            params.require(:event).permit(
                :model_id,
                :model_type,
                :user_main_id,
                detail_attributes: [
                    :title, 
                    :description, 
                    :event_date,
                    :time_start, 
                    :time_end, 
                    :location, 
                    :url, 
                    :event_type,
                    :public
                ]
            )
        end
    end
end
