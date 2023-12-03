<script setup>
/*
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { onMounted, watch, ref } from "vue"


// · 
import dayjs from "dayjs"


// · import lesli stores
import { useCalendar } from "LesliDriver/stores/calendar"


// · implement stores
const storeCalendar = useCalendar()


// · 
const agenda = ref([])
const today_iso = dayjs().format('YYYY-MM-DD')


// · 
function merge() {

    let events = [
        ...storeCalendar.calendarData.driver_events, 
        ...storeCalendar.calendarData.help_tickets
    ]
    
    let count = 0

    events = events.filter(event => {

        if (count >= 6) {
            return 
        }

        let event_date = dayjs(event.date).format('YYYY-MM-DD')

        if (event_date < today_iso) {
            return 
        } 

        let format = "DD MMM"

        event.time = event.start

        if (event_date == today_iso) {
            format = "HH:mm"
        } 

        if (event.start) { event['start'] = dayjs(event.start).format(format) }
        if (event.description) { event['description'] = event.description.substring(0, 40) + '...' }   
        
        event.classNames = event.classNames

        count++

        return event

    })
    
    events = events.sort((a,b) => a.time > b.time)

    agenda.value = events
}


// · 
watch(() => storeCalendar.calendarData.driver_events, () => merge())

</script>
<template>
    <div class="driver-agenda">
        <h3>Upcoming events</h3>
        <div 
            class="is-flex is-align-items-center event" 
            v-for="(event, index) in agenda"
            :key="index">
            <span class="date">
                {{ event.start }}
            </span>
            <div :class="['description', event.classNames]">
                <p>{{ event.title }}</p>
                <p>{{ event.description }}</p>
            </div>
        </div>
    </div>
</template>
