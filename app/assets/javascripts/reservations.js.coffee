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

		#startTime = new Date(reservation.start)
		startTime = new Date('2014-11-'+day+' 11:30:00')
		endTime = new Date(startTime)
		endTime.setMinutes(startTime.getMinutes() + reservation.duration)
		description = 'Reservation for Court ' + reservation.court + ', by ' + gon.user + ' with ' + reservation.guest1

		item = {
			title: 
			start: startTime
			end: endTime
		}
		eventList.push(item)
		day++

	$('.calendar').fullCalendar
		defaultView: 'agendaDay',
		allDaySlot: false,
		minTime: moment.duration("05:00:00"),
		maxTime: moment.duration("22:00:00"),
		slotDuration: moment.duration("00:15:00"),
		height: 'auto',
		header: false,
		start: moment().add(1, 'days'),
		events: eventList

	$('#today').fullCalendar('gotoDate', moment())
	$('#tomorrow').fullCalendar('gotoDate', moment().add(1, 'days'))
	$('#dayafter').fullCalendar('gotoDate', moment().add(2, 'days'))

	$('#datetime').datetimepicker
		enabledDates: [
		  moment(today),
		  moment(today).add(1, 'days'),
		  moment(today).add(2, 'days')
		],
		minuteStepping: 15

	$('#selectpicker').selectpicker

	$('#reserveButton').on "click", ->
		startTime = $('#datetime').data("DateTimePicker").getDate()
		$('#calendar').fullCalendar('renderEvent', {
			title: 'Reserved Block',
			start: startTime,
			end: moment(startTime).add(1, 'hours')
		}, true)
		$('#calendar').fullCalendar('refetchEvents')