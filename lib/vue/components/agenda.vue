<script setup>
/*
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
*/


// · 
import { onMounted, watch, ref } from "vue"


// · 
import dayjs from "dayjs"


// · import lesli stores
import { useCalendar } from 'CloudDriver/stores/calendar'


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
