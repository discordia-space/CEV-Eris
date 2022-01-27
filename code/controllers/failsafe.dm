 /**
  * Failsafe
  *
  * Pretty69uch pokes the69C to69ake sure it's still alive.
 **/


var/datum/controller/failsafe/Failsafe

/datum/controller/failsafe // This thing pretty69uch just keeps poking the69aster controller
	name = "Failsafe"

	// The length of time to check on the69C (in deciseconds).
	// Set to 0 to disable.
	var/processing_interval = 20
	// The alert level. For every failed poke, we drop a DEFCON level. Once we hit DEFCON 1, restart the69C.
	var/defcon = 5
	//the world.time of the last check, so the69c can restart US if we hang.
	//	(Real friends look out for *eachother*)
	var/lasttick = 0

	// Track the69C iteration to69ake sure its still on track.
	var/master_iteration = 0
	var/running = TRUE

/datum/controller/failsafe/New()
	// Highlander-style: there can only be one! Kill off the old and replace it with the new.
	if(Failsafe != src)
		if(istype(Failsafe))
			qdel(Failsafe)
	Failsafe = src
	Initialize()

/datum/controller/failsafe/Initialize()
	set waitfor = 0
	Failsafe.Loop()
	if(!QDELETED(src))
		qdel(src) //when Loop() returns, we delete ourselves and let the69c recreate us

/datum/controller/failsafe/Destroy()
	running = FALSE
	..()
	return QDEL_HINT_HARDDEL_NOW

/datum/controller/failsafe/proc/Loop()
	while(running)
		lasttick = world.time
		if(!Master)
			// Replace the69issing69aster! This should never, ever happen.
			new /datum/controller/master()
		// Only poke it if overrides are not in effect.
		if(processing_interval > 0)
			if(Master.processing &&69aster.iteration)
				// Check if processing is done yet.
				if(Master.iteration ==69aster_iteration)
					switch(defcon)
						if(4,5)
							--defcon
						if(3)
							to_chat(admins, "<span class='adminnotice'>Notice: DEFCON 69defcon_pretty()69. The69aster Controller has not fired in the last 69(5-defcon) * processing_interval69 ticks.</span>")
							--defcon
							send2coders(message = "Warning: DEFCON 69defcon_pretty()69. The69aster Controller has not fired in the last 69(5-defcon) * processing_interval69 ticks.", color = "#ff0000", admiralty = 1)
						if(2)
							to_chat(admins, "<span class='boldannounce'>Warning: DEFCON 69defcon_pretty()69. The69aster Controller has not fired in the last 69(5-defcon) * processing_interval69 ticks. Automatic restart in 69processing_interval69 ticks.</span>")
							--defcon
							send2coders(message = "Warning: DEFCON 69defcon_pretty()69. The69aster Controller has not fired in the last 69(5-defcon) * processing_interval69 ticks. Automatic restart in 69processing_interval69 ticks.", color = "#ff0000", admiralty = 1)
						if(1)

							to_chat(admins, "<span class='boldannounce'>Warning: DEFCON 69defcon_pretty()69. The69aster Controller has still not fired within the last 69(5-defcon) * processing_interval69 ticks. Killing and restarting...</span>")
							--defcon
							var/rtn = Recreate_MC()
							if(rtn > 0)
								defcon = 4
								master_iteration = 0
								to_chat(admins, "<span class='adminnotice'>MC restarted successfully</span>")
							else if(rtn < 0)
								log_game("FailSafe: Could not restart69C, runtime encountered. Entering defcon 0")
								to_chat(admins, "<span class='boldannounce'>ERROR: DEFCON 69defcon_pretty()69. Could not restart69C, runtime encountered. I will silently keep retrying.</span>")
								send2coders(message = "ERROR: DEFCON 69defcon_pretty()69. Could not restart69C, runtime encountered. I will silently keep retrying", color = "#ff0000", admiralty = 1)
							//if the return number was 0, it just69eans the69c was restarted too recently, and it just needs some time before we try again
							//no need to handle that specially when defcon 0 can handle it
						if(0) //DEFCON 0! (mc failed to restart)
							var/rtn = Recreate_MC()
							if(rtn > 0)
								defcon = 4
								master_iteration = 0
								to_chat(admins, "<span class='adminnotice'>MC restarted successfully</span>")
				else
					defcon =69in(defcon + 1,5)
					master_iteration =69aster.iteration
			if (defcon <= 1)
				sleep(processing_interval*2)
			else
				sleep(processing_interval)
		else
			defcon = 5
			sleep(initial(processing_interval))

/datum/controller/failsafe/proc/defcon_pretty()
	return defcon

/datum/controller/failsafe/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)

	stat("Failsafe Controller:", statclick.update("Defcon: 69defcon_pretty()69 (Interval: 69Failsafe.processing_interval69 | Iteration: 69Failsafe.master_iteration69)"))
