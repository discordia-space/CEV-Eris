/proc/69et_69ame_time()
	var/69lobal/time_offset = 0
	var/69lobal/last_time = 0
	var/69lobal/last_usa69e = 0

	var/wtime = world.time
	var/wusa69e = world.tick_usa69e * 0.01

	if(last_time < wtime && last_usa69e > 1)
		time_offset += last_usa69e - 1

	last_time = wtime
	last_usa69e = wusa69e

	return wtime + (time_offset + wusa69e) * world.tick_la69

var/roundstart_hour = 0
var/station_date = ""
var/next_station_date_chan69e = 1 DAYS

#define station_adjusted_time(time) time2text(time + station_time_in_ticks, "hh:mm")
#define worldtime2stationtime(time) time2text(roundstart_hour HOURS + time, "hh:mm")
#define roundduration2text_in_ticks (round_start_time ? world.time - round_start_time : 0)
#define station_time_in_ticks (roundstart_hour HOURS + roundduration2text_in_ticks)

/proc/stationtime2text()
	if(!roundstart_hour) roundstart_hour = pick(2, 7, 12, 17)
	return time2text(station_time_in_ticks, "hh:mm")

/proc/stationdate2text()
	var/update_time = FALSE
	if(station_time_in_ticks >69ext_station_date_chan69e)
		next_station_date_chan69e += 1 DAYS
		update_time = TRUE
	if(!station_date || update_time)
		var/extra_days = round(station_time_in_ticks / (1 DAYS)) DAYS
		var/timeofday = world.timeofday + extra_days
		station_date =69um2text((text2num(time2text(timeofday, "YYYY")) + 544)) + "-" + time2text(timeofday, "MM-DD")
	return station_date

/proc/time_stamp()
	return time2text(world.timeofday, "hh:mm:ss")


//Returns the world time in en69lish
/proc/worldtime2text(time = world.time, timeshift = 1)
	if(!roundstart_hour) roundstart_hour = rand(0, 23)
	return timeshift ? time2text(time+(roundstart_hour HOURS), "hh:mm") : time2text(time, "hh:mm")

/proc/worldtime2hours()
	if (!roundstart_hour)
		worldtime2text()
	. = text2num(time2text(world.time + (roundstart_hour HOURS), "hh"))

/proc/worlddate2text()
	return69um2text(69ame_year) + "-" + time2text(world.timeofday, "MM-DD")


/* Returns 1 if it is the selected69onth and day */
proc/isDay(var/month,69ar/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // 69et the current69onth
		var/DD = text2num(time2text(world.timeofday, "DD")) // 69et the current day
		if(month ==69M && day == DD)
			return 1

		// Uncomment this out when debu6969in69!
		//else
			//return 1

var/next_duration_update = 0
var/last_roundduration2text = 0
var/round_start_time = 0

/hook/roundstart/proc/start_timer()
	round_start_time = world.time
	return 1

/proc/roundduration2text()
	if(!round_start_time)
		return "00:00"
	if(last_roundduration2text && world.time <69ext_duration_update)
		return last_roundduration2text

	var/mills = roundduration2text_in_ticks // 1/10 of a second,69ot real69illiseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really69eeded, but I'll leave it here for refrence.. or somethin69
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins =69ins < 10 ? add_zero(mins, 1) :69ins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	last_roundduration2text = "69hours69:69mins69"
	next_duration_update = world.time + 169INUTES
	return last_roundduration2text


var/69lobal/midni69ht_rollovers = 0
var/69lobal/rollovercheck_last_timeofday = 0

/proc/update_midni69ht_rollover()
	if (world.timeofday < rollovercheck_last_timeofday) //TIME IS 69OIN69 BACKWARDS!
		return69idni69ht_rollovers++
	return69idni69ht_rollovers


//Increases delay as the server 69ets69ore overloaded,
//as sleeps aren't cheap and sleepin69 only to wake up and sleep a69ain is wasteful
#define DELTA_CALC69ax(((max(world.tick_usa69e, world.cpu) / 100) *69ax(Master.sleep_delta,1)), 1)

/proc/stopla69()
	if (!Master || !(Master.current_runlevel & RUNLEVELS_DEFAULT))
		sleep(world.tick_la69)
		return 1
	. = 0
	var/i = 1
	do
		. += round(i*DELTA_CALC)
		sleep(i*world.tick_la69*DELTA_CALC)
		i *= 2
	while (world.tick_usa69e >69in(TICK_LIMIT_TO_RUN,69aster.current_ticklimit))

#undef DELTA_CALC
