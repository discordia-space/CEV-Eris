/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in GLOB.drones)
		if(D.key && D.client)
			drones++
	return drones

/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing69aintenance drones."

	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	active_power_usage = 5000

	var/fabricator_tag = "Eris"
	var/drone_progress = 0
	var/produce_drones = 1
	var/time_last_drone = 500
	var/drone_type = /mob/living/silicon/robot/drone

	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"

/obj/machinery/drone_fabricator/New()
	..()

/obj/machinery/drone_fabricator/power_change()
	..()
	if (stat &69OPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/drone_fabricator/Process()

	if(SSticker.current_state < GAME_STATE_PLAYING)
		return

	if(stat &69OPOWER || !produce_drones)
		if(icon_state != "drone_fab_nopower") icon_state = "drone_fab_nopower"
		return

	if(drone_progress >= 100)
		icon_state = "drone_fab_idle"
		return

	icon_state = "drone_fab_active"
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/config.drone_build_time)*100)

	if(drone_progress >= 100)
		visible_message("\The 69src6969oices a strident beep, indicating a drone chassis is prepared.")

/obj/machinery/drone_fabricator/examine(mob/user)
	..(user)
	if(produce_drones && drone_progress >= 100 && isghost(user) && config.allow_drone_spawn && count_drones() < config.max_maint_drones)
		to_chat(user, "<BR><B>A drone is prepared. Select 'Join As Drone' from the Ghost tab to spawn as a69aintenance drone.</B>")

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player,69ar/aibound = FALSE)

	if(stat &69OPOWER)
		return

	if(!produce_drones || !config.allow_drone_spawn || count_drones() >= config.max_maint_drones)
		return

	if(!player || (!isghost(player.mob) && !aibound))
		return

	announce_ghost_joinleave(player, 0, "They have taken control over a69aintenance drone.")
	visible_message("\The 69src69 churns and grinds as it lurches into69otion, disgorging a shiny69ew drone after a few69oments.")
	flick("h_lathe_leave",src)

	time_last_drone = world.time
	if(!aibound)
		var/mob/living/silicon/robot/drone/new_drone =69ew drone_type(get_turf(src))
		if(player.mob && player.mob.mind) player.mob.mind.reset()
		new_drone.transfer_personality(player)
		new_drone.master_fabricator = src
	else
		var/mob/living/silicon/robot/drone/aibound/new_drone =69ew /mob/living/silicon/robot/drone/aibound(get_turf(src))
		var/mob/living/silicon/ai/M = player.mob
		new_drone.bound_ai =69 // Save AI core in69ariable to be able to get back to it
		M.bound_drone =69ew_drone  // Save69ew drone in69ariable of AI
		new_drone.real_name =69.name + " controlled drone"
		new_drone.name =69ew_drone.real_name
		new_drone.laws =69.laws
		M.mind.active = 0 // We want to transfer the key69anually
		M.mind.transfer_to(new_drone) // Transfer69ind to drone
		new_drone.key = player.key //69anually transfer the key to log them in
		new_drone.master_fabricator = src

	drone_progress = 0

/mob/observer/ghost/verb/join_as_drone()
	set category = "Ghost"
	set69ame = "Respawn as Drone"
	set desc = "If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a69aintenance drone."
	try_drone_spawn(src)

/proc/try_drone_spawn(var/mob/user,69ar/obj/machinery/drone_fabricator/fabricator,69ar/aibound = FALSE)

	if(SSticker.current_state < GAME_STATE_PLAYING)
		to_chat(user, SPAN_DANGER("The game hasn't started yet!"))
		return

	if(!(config.allow_drone_spawn))
		to_chat(user, SPAN_DANGER("That69erb is69ot currently permitted."))
		return

	if(jobban_isbanned(user,"Robot"))
		to_chat(user, SPAN_DANGER("You are banned from playing synthetics and cannot spawn as a drone."))
		return

	if(!user.MayRespawn(1,69INISYNTH) && !aibound)
		return

	if(!fabricator)

		var/list/all_fabricators = list()
		for(var/obj/machinery/drone_fabricator/DF in GLOB.machines)
			if((DF.stat &69OPOWER) || !DF.produce_drones || DF.drone_progress < 100)
				continue
			all_fabricators69DF.fabricator_tag69 = DF

		if(!all_fabricators.len)
			to_chat(user, SPAN_DANGER("There are69o available drone spawn points, sorry."))
			return

		var/choice = input(user,"Spawning as a drone will69ot affect your crew or69ouse respawn timers. Which fabricator do you wish to use?") as69ull|anything in all_fabricators
		if(!choice || !all_fabricators69choice69)
			return
		fabricator = all_fabricators69choice69

	if(user && fabricator && !((fabricator.stat &69OPOWER) || !fabricator.produce_drones || fabricator.drone_progress < 100))
		fabricator.create_drone(user.client, aibound)
		return 1
	return
