module LesliDriver
    class CalendarsController < ApplicationController
        before_action :set_calendar, only: [:show, :edit, :update]

        # GET /calendars
        def index
            respond_to do |format|
                format.html { }
                format.json do
                    respond_with_pagination(CloudDriver::CalendarService.new(current_user).index(@query))
                end
            end
        end

        # GET /calendars/1
        def show
            respond_to do |format|
                format.html { }
                format.json { respond_with_successful() }
                #format.json { respond_with_successful(@calendar.show(@query)) }
            end
        end

        # GET /calendars/new
        def new
        end

        # GET /calendars/1/edit
        def edit
        end

        # POST /calendars
        def create
        end

        # PATCH/PUT /calendars/1
        def update
        end

        # DELETE /calendars/1
        def destroy
        end

        def options
            respond_with_successful(Calendar.options(current_user, @query))
        end

        def sync
            respond_with_successful(Calendar.sync(current_user))
        end

        private

        # Sets the requested user based on the current_users's account
        def set_calendar

            # if params[:id].blank? || params[:id] == "default"
            #     @calendar = CloudDriver::CalendarService.new(current_user).default_calendar
            # elsif params[:id]
            #     @calendar = CloudDriver::CalendarService.new(current_user).find(params[:id])
            # end

            # return respond_with_not_found unless @calendar
        end

        # Only allow a trusted parameter "white list" through.
        def calendar_params
            params.require(:calendar)
        end
    end
end
