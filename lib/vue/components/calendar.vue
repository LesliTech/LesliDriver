<script setup>
/*
Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
*/


// · Import components, libraries and tools
import { onMounted, inject, ref } from "vue"
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import listPlugin from '@fullcalendar/list';


// · 
const date = inject("date")

const storeCalendar = ref({ calendar: null })


// · 
function initCalendar() {
    storeCalendar.calendar = new Calendar(document.getElementById("driver-calendar"), {
        plugins: [
            dayGridPlugin,
            interactionPlugin,
            timeGridPlugin,
            listPlugin
        ],
        headerToolbar: false,
        firstDay: 1,
        locale: I18n.currentLocale(),
        initialView: 'dayGridMonth',
        showNonCurrentDates: true,
        events: [],
        eventClick: storeCalendar.onEventClick,
        dateClick: storeCalendar.onDateClick,
        eventContent: function (args) {

            let title = document.createElement('span')
            let time = document.createElement('span')
            title.innerHTML = args.event.title
            time.innerHTML = date.time(args.event._def.extendedProps.dateStart)

            if (args.event._def.extendedProps.dateEnd) {
                time.innerHTML += (" - " + date.time(args.event._def.extendedProps.dateEnd))
            }
            
            title.classList.add('event-title')
            time.classList.add('event-time')
            return { domNodes: [title, time] }
        }
    })
    storeCalendar.calendar.render()
}


onMounted(() => {
    let calendar = new Calendar(document.getElementById("driver-calendar"), {
        plugins: [
            dayGridPlugin,
            interactionPlugin,
            timeGridPlugin,
            listPlugin
        ],
        headerToolbar: {
            left: '',
            center: 'title',
            right: ''
        },
        firstDay: 1,
        initialView: 'dayGridMonth',
        showNonCurrentDates: true,
        dayMaxEvents: true, // allow "more" link when too many events
        editable: true,
        events: [{
            title: 'All Day Event',
            start: '2023-10-01',
            classNames: "ldonis"
        }, {
            title: 'Long Event',
            start: '2023-10-07',
            end: '2023-10-10'
        }, {
            groupId: 999,
            title: 'Repeating Event',
            start: '2023-10-09T16:00:00'
        }, {
            groupId: 999,
            title: 'Repeating Event',
            start: '2023-10-16T16:00:00'
        }, {
            title: 'Conference',
            start: '2023-10-11',
            end: '2023-10-13'
        }, {
            title: 'Meeting',
            start: '2023-10-12T10:30:00',
            end: '2023-10-12T12:30:00'
        }, {
            title: 'Lunch',
            start: '2023-10-12T12:00:00'
        }, {
            title: 'Meeting',
            start: '2023-10-15T14:30:00'
        }, {
            title: 'Happy Hour',
            start: '2023-10-15T17:30:00'
        }, {
            title: 'Dinner',
            start: '2023-10-12T20:00:00'
        }, {
            title: 'Birthday Party',
            start: '2023-10-13T07:00:00'
        }, {
            title: 'Click for Google',
            url: 'http://google.com/',
            start: '2023-10-28'
        }]
    });

    setTimeout(() => { calendar.render(); }, 100)

})

</script>

<template>
    <div id="driver-calendar"></div>
</template>
