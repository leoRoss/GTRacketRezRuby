# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
	today = moment()
	dayOfWeek = moment().diff(moment().startOf('week'),'days')

	# hack to get the correct days to display
	hideDays = []
	for i in [0..7]
		do (i) ->
			unless i == dayOfWeek or i == (dayOfWeek + 1) % 7 or i == (dayOfWeek + 2) % 7
				hideDays.push(i)
	eventList = []

	for reservation in gon.reservations
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
			title: description
			start: startTime.toISOString()
			end: endTime.toISOString()
			color: color
			textColor: text
			name: reservation.name
			court: reservation.court
		}
		
		eventList.push(item)

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
			$('#reservationModal').modal('show')
		events: eventList
		eventClick: (calEvent, jsEvent, view) ->
			if gon.user
				id = calEvent.id		
				start = calEvent.start
				end = calEvent.end
				name = calEvent.name
				court = calEvent.court
				$('#details').modal('show')
				document.getElementById('res_desc').innerHTML='Reservation ID: ' + id
				document.getElementById('name_desc').innerHTML='Name: ' + name
				document.getElementById('court_desc').innerHTML='Court: ' + court
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

	#$('.selectpicker').selectpicker

	reserveOnClick = ->
		eventTitle = 'Reservation for Court ' + $('#court').val() + ", by " + gon.user
		startTime = new Date($('#start').data('DateTimePicker').getDate())
		duration = $('#duration').val()
		endTime = new Date(startTime)
		endTime.setMinutes(startTime.getMinutes() + duration)	

		$('#today').fullCalendar('renderEvent', {
			title: eventTitle,
			start: startTime.toISOString(),
			end: endTime.toISOString(),
			allDay: false
			color: "#58FA82"
			textColor: "black"
			name: gon.user
			court: $('#court').val()
		}, true)

		params =
			reservation:
				name: gon.user
				phone: current_phone
				start: startTime.toISOString(),
				duration: duration,
				court: $('#court').val(),
				user_id: String(current_user),

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

	$('#reserveButton').on 'click', reserveOnClick
	$('#deleteButton').on 'click', confirmDelete
	$('#confirmButton').on 'click', deleteEvent