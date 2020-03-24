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
    class EventsController < ApplicationController
        before_action :set_event, only: [:show, :edit, :update, :destroy]

        # GET /events
        def index
            responseWithSuccessful()
        end

        # GET /events/1
        def show
            respond_to do |format|
                format.html { }
                format.json do
                    event = Event.joins(:detail)
                    .select(:id, :title, :description, :time_start, :time_end, :location, :url)
                    .find(@event.id)
                    responseWithSuccessful({
                        id: event[:id],
                        detail_attributes: {
                            title: event[:title],
                            description: event[:description],
                            time_start: event[:time_start],
                            time_end: event[:time_start],
                            location: event[:location],
                            url: event[:url]
                        }
                    })
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
            event = current_user.account.driver.calendars.default().events.create(event_params)
            responseWithSuccessful(event)
        end

        # PATCH/PUT /events/1
        def update
            #@event.detail.title = event_params[:]
            if @event.update(event_params)
                responseWithSuccessful(@event)
            else
                responseWithError(@event.errors)
            end
        end

        # DELETE /events/1
        def destroy
            @event.destroy
            redirect_to events_url, notice: 'Event was successfully destroyed.'
        end

        def event_options
            options = {
                task_types: Event.event_types.map {|k, _| {value: k, text: k}},
                users: Courier::Core::Users.list
            }
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_event
            @event = Event.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def event_params
            params.require(:event).permit(
                :id,
                detail_attributes: [
                    :title, 
                    :description, 
                    :time_start, 
                    :time_end, 
                    :location, 
                    :url, 
                    :event_type,
                    :address,
                    :public
                ]
            )
        end
    end
end
