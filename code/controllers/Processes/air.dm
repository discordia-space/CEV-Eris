/datum/controller/process/air/setup()
	name = "air"
	schedule_interval = 20 // every 2 seconds
	start_delay = 4

	if(!SSair)
		SSair = new
		SSair.Setup()

/datum/controller/process/air/doWork()
	if(!air_processing_killed)
		if(!SSair.Tick()) //Runtimed.
			SSair.failed_ticks++

			if(SSair.failed_ticks > 5)
				world << SPAN_DANGER("RUNTIMES IN ATMOS TICKER.  Killing air simulation!")
				world.log << "### ZAS SHUTDOWN"

				message_admins("ZASALERT: Shutting down! status: [SSair.tick_progress]")
				log_admin("ZASALERT: Shutting down! status: [SSair.tick_progress]")

				air_processing_killed = TRUE
				SSair.failed_ticks = 0
