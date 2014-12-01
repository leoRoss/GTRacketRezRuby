# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = () ->
	getActiveEvents = (activeTab) ->
		eventList = []

		for reservation in gon.reservations
			
			if reservation.court == activeTab

				startTime = new Date(reservation.start)
				endTime = new Date(startTime)
				endTime.setMinutes(startTime.getMinutes() + reservation.duration)
				description =  'Name: ' + reservation.name + "\nCourt: " + reservation.court

				if reservation.name == gon.user
					color = "#58FA82"
					text = "black"
				else
					color = "#6AA4C1"
					text = "white"

				item = {
					id: reservation.id
					name: reservation.name
					court: reservation.court
					title: description
					start: startTime.toISOString()
					end: endTime.toISOString()
					color: color
					textColor: text
				}

				eventList.push(item)
		return eventList

	$('.calendar').fullCalendar
		defaultView: 'agendaDay',
		allDaySlot: false,
		minTime: moment.duration('05:00:00'),
		maxTime: moment.duration('22:00:00'),
		slotDuration: moment.duration('00:15:00'),
		height: 'auto',
		header: true,
		start: moment().add(1, 'days'),
		selectable: true if gon.user,
		select: (start, end, allDay) ->
			$('#start').data('DateTimePicker').setDate(start)
			tab = $('ul#tabs li.active')[0].value
			$('select#court option').eq(tab-1).prop('selected',true)
			$('select.selectpicker').selectpicker('refresh')
			$('#reservationModal').modal('show')
		events: getActiveEvents(1),
		eventClick: (calEvent, jsEvent, view) ->
			if calEvent.name == gon.user || gon.admin
				id = calEvent.id
				start = calEvent.start
				end = calEvent.end
				name = calEvent.name
				court = calEvent.court
				$('#details').modal('show')
				document.getElementById('res_desc').innerHTML='Reservation ID: ' + id
				document.getElementById('name_desc').innerHTML='Name: ' + name
				document.getElementById('court_desc').innerHTML='Court: ' + court
				document.getElementById('startdate_desc').innerHTML='Start Date: ' + start.format('MM/DD/YY')
				document.getElementById('enddate_desc').innerHTML='End Date: ' + end.format('MM/DD/YY')
				document.getElementById('start_desc').innerHTML='Start Time: ' + start.format('hh:mmA')
				document.getElementById('end_desc').innerHTML='End Time: ' + end.format('hh:mmA')

	$('#today').fullCalendar('gotoDate', moment())
	$('#tomorrow').fullCalendar('gotoDate', moment().add(1, 'days'))
	$('#dayafter').fullCalendar('gotoDate', moment().add(2, 'days'))

	$('.datetimepicker').datetimepicker
		enabledDates: [
		  moment(today),
		  moment(today).add(1, 'days'),
		  moment(today).add(2, 'days')
		],
		minuteStepping: 15
	
	reserveOnClick = ->
		eventTitle = 'Name: ' + gon.user  + "\nCourt: " + $('#court').val()
		startTime = new Date($('#start').data('DateTimePicker').getDate())
		duration = parseInt($('#duration').val())
		endTime = new Date(startTime)
		endTime.setMinutes(startTime.getMinutes() + duration)

		reservationInfo = {
			name: gon.user
			court: $('#court').val()
			title: eventTitle,
			start: startTime.toISOString(),
			end: endTime.toISOString(),
			allDay: false
			color: "#58FA82"
			textColor: "black"
		}

		if (gon.admin)
			params =
				reservation:
					name: $('#name input').val(),
					phone: $('#phone input').val(),
					start: startTime.toISOString(),
					duration: duration,
					court: $('#court').val(),
					user_id: String(current_user),
					guest1: $('#guest1 input').val(),
					guest2: $('#guest2 input').val(),
					guest3: $('#guest3 input').val(),
		else
			params =
				reservation:
					name: gon.user,
					phone: current_phone,
					start: startTime.toISOString(),
					duration: duration,
					court: $('#court').val(),
					user_id: String(current_user),
					guest1: $('#guest1 input').val(),
					guest2: $('#guest2 input').val(),
					guest3: $('#guest3 input').val(),
					

		$('#today').fullCalendar('renderEvent', reservationInfo, true)

		$('#tomorrow').fullCalendar('renderEvent', reservationInfo, true)

		$('#dayafter').fullCalendar('renderEvent', reservationInfo, true)

		$.ajax({
				type: 'POST',
				url: '/reservations',
				data: params,
				success:(data) ->
			        return false
			    error:(data) ->
			        return false
		})
		$('#reservationModal').modal('hide')
		$('.calendar').fullCalendar('unselect')

	confirmDelete = ->
		$('#details').modal('hide')
		$('#delConfirm').modal('show')
		
	deleteEvent = ->
		curr_id = document.getElementById('res_desc').innerHTML.match(/\d+/)
		$.ajax
			url: "/reservations/" + curr_id
			type: "POST"
			dataType: "json"
			data:
				_method: "delete"

		$('#delConfirm').modal('hide')

		$('.calendar').fullCalendar('removeEvents', curr_id)

	tabOnClick = (e) ->
		c = $('.calendar')
		c.fullCalendar('removeEvents')
		c.fullCalendar('addEventSource', getActiveEvents(e.target.parentNode.value))
		c.fullCalendar('rerenderEvents')

	$('#reserveButton').on 'click', reserveOnClick
	$('#deleteButton').on 'click', confirmDelete
	$('#confirmButton').on 'click', deleteEvent
	$('ul#tabs li').on 'click', tabOnClick

$(document).ready(ready);
$(document).on('page:load', ready);