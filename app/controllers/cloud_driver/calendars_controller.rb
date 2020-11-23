=begin
    
Copyright (c) 2020, all rights reserved.

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

require_dependency "cloud_driver/application_controller"

module CloudDriver
    class CalendarsController < ApplicationController
        before_action :set_calendar, only: [:show, :edit, :update, :destroy]
        before_action :set_date_filter_params, only: :show

        # GET /calendars
        def index
            respond_to do |format|
                format.html { }
                format.json do
                    respond_with_successful(
                        current_user.account.driver
                        .calendars.joins(:detail)
                        .select(:id, :name, :color)
                    )
                end
            end
        end

        # GET /calendars/1
        def show
            respond_to do |format|
                format.html { }
                format.json { respond_with_successful(Calendar.index(current_user, @query)) }
            end
        end

        # GET /calendars/new
        def new
            @calendar = Calendar.new
        end

        # GET /calendars/1/edit
        def edit
        end

        # POST /calendars
        def create
            @calendar = Calendar.new(calendar_params)
            if @calendar.save
                redirect_to @calendar, notice: 'Calendar was successfully created.'
            else
                render :new
            end
        end

        # PATCH/PUT /calendars/1
        def update
            return respond_with_not_found unless @calendar

            if @calendar.update(calendar_params)
                redirect_to @calendar, notice: 'Calendar was successfully updated.'
            else
                render :edit
            end
        end

        # DELETE /calendars/1
        def destroy
            return respond_with_not_found unless @calendar

            @calendar.destroy
            redirect_to calendars_url, notice: 'Calendar was successfully destroyed.'
        end

        def options
            
        end

        private

        # @return [void]
        # @description Sets the requested user based on the current_users's account
        # @example
        #     # Executing this method from a controller action:
        #     set_calendar
        #     puts @calendar
        #     # This will either display nil or an instance of CloudDriver::Calendar
        def set_calendar
            if params[:id].blank? || params[:id] == "default"
                @calendar = current_user.account.driver.calendars.default
            elsif params[:id]
                @calendar = current_user.account.driver.calendars.find_by(id: params[:id])
            end
        end

        # Only allow a trusted parameter "white list" through.
        def calendar_params
            params.fetch(:calendar, {})
        end

        def set_date_filter_params
            filters_date = Calendar.get_date_range_filter(params[:month], params[:day])
            @query[:filters][:start_date] = filters_date[:start_date]
            @query[:filters][:end_date] = filters_date[:end_date]
        end
    end
end
