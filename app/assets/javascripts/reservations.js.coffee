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
	day = 13

	for reservation in gon.reservations
		startTime = new Date(reservation.start)
		#startTime = new Date('2014-11-'+day+' 11:30:00')
		endTime = new Date(startTime)
		endTime.setMinutes(startTime.getMinutes() + reservation.duration)
		description = 'Reservation for Court ' + reservation.court + ', by ' + reservation.name + ' with ' + reservation.guest1

		if reservation.name == gon.user
			color = "orange"
			text = "black"
		else
			color = "blue"
			text = "white"

		item = {
			title: description
			start: startTime
			end: endTime
			color: color
			textColor: text
		}
		
		eventList.push(item)
		#day++

	$('.calendar').fullCalendar
		defaultView: 'agendaDay',
		allDaySlot: false,
		minTime: moment.duration('05:00:00'),
		maxTime: moment.duration('22:00:00'),
		slotDuration: moment.duration('00:15:00'),
		height: 'auto',
		header: false,
		start: moment().add(1, 'days'),
		selectable: true,
		select: (start, end, allDay) ->
			$('#start').data('DateTimePicker').setDate(start)
			$('#end').data('DateTimePicker').setDate(moment(start).add(1, 'hours'))
			$('#reservationModal').modal('show')
		events: eventList

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

	$('#selectpicker').selectpicker

	reserveOnClick = ->
		eventTitle = 'Your Reservation'
		startTime = $('#start').data('DateTimePicker').getDate()
		endTime = $('#end').data('DateTimePicker').getDate()
		$('#today').fullCalendar('renderEvent', {
			title: eventTitle,
			start: startTime,
			end: endTime,
			allDay: false
		}, true)
		params =
			reservation:
				start: String(startTime.format('YYYY-MM-DD')),
				duration: String(endTime.diff(startTime)),
				court: $('#court').val(),
				user_id: String(1)
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

	$('#reserveButton').on 'click', reserveOnClick
