SUBSYSTEM_DEF(statpanels)
	name = "Stat Panels"
	wait = 4
	init_order = INIT_ORDER_STATPANELS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/encoded_global_data
	var/mc_data_encoded
	var/list/cached_images = list()

/datum/controller/subsystem/statpanels/fire(resumed = FALSE)
	if(!resumed)
		var/list/global_data = list(
			list("Storyteller: [master_storyteller ? master_storyteller : "being democratically elected"]"),
			list("Server Time: [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")]"),
			list("Round Time: [roundduration2text()]"),
			list("Ship Time: [stationtime2text()]"),
		)
		var/eta_status = evacuation_controller.get_status_panel_eta()
		if(eta_status)
			global_data += list(list(eta_status))

		encoded_global_data = url_encode(json_encode(global_data))

		var/list/mc_data = list(
			list("CPU:", world.cpu),
			list("Instances:", "[num2text(world.contents.len, 10)]"),
			list("World Time:", "[world.time]"),
			list("Globals:", "Edit", "\ref[GLOB]"),
			list("Config:", "Edit", "\ref[config]"),
			list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%))"),
			list("Master Controller:", Master ? "(TickRate:[Master.processing]) (Iteration:[Master.iteration])" : "ERROR", "\ref[Master]"),
			list("Failsafe Controller:", Failsafe ? "Defcon: [Failsafe.defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])" : "ERROR", "\ref[Failsafe]"),
			list("","")
		)
		for(var/ss in Master.subsystems)
			var/datum/controller/subsystem/sub_system = ss
			mc_data[++mc_data.len] = list("\[[sub_system.state_letter()]][sub_system.name]", sub_system.stat_entry(), "\ref[sub_system]")
		mc_data_encoded = url_encode(json_encode(mc_data))
		src.currentrun = clients.Copy()

	var/list/currentrun = src.currentrun
	while(LAZYLEN(currentrun))
		var/client/target = currentrun[LAZYLEN(currentrun)]
		currentrun.len--
		var/list/personal_data = list(list("Ping: [round(target.lastping, 1)]ms (Average: [round(target.avgping, 1)]ms)"))
		personal_data += target.mob.get_status_tab_items()
		var/encoded_personal_data = url_encode(json_encode(personal_data))
		target << output("[encoded_global_data];[encoded_personal_data]", "statbrowser:update")

		if(!target.holder)
			target << output("", "statbrowser:remove_admin_tabs")
		else
			var/turf/eye_turf = get_turf(target.eye)
			var/coord_entry = url_encode(COORD(eye_turf))
			target << output("[mc_data_encoded];[coord_entry]", "statbrowser:update_mc")

		if(target.mob?.listed_turf)
			var/mob/target_mob = target.mob
			if(!target_mob.TurfAdjacent(target_mob.listed_turf))
				target << output("", "statbrowser:remove_listedturf")
				target_mob.listed_turf = null
			else
				var/list/overrides = list()
				var/list/turfitems = list()
				for(var/image/target_image as anything in target.images)
					if(!target_image.loc || target_image.loc.loc != target_mob.listed_turf || !target_image.override)
						continue
					overrides += target_image.loc
				for(var/atom/movable/turf_content as anything in target_mob.listed_turf)
					if(turf_content.mouse_opacity == MOUSE_OPACITY_TRANSPARENT)
						continue
					if(turf_content.invisibility > target_mob.see_invisible)
						continue
					if(turf_content in overrides)
						continue
					if(LAZYLEN(turfitems) < 30) // Only create images for the first 30 items on the turf, for performance reasons
						if(!("\ref[turf_content]" in cached_images))
							target << browse_rsc(getFlatIcon(turf_content, no_anim = TRUE), "\ref[turf_content].png")
							cached_images += "\ref[turf_content]"
						turfitems[++turfitems.len] = list("[turf_content.name]", "\ref[turf_content]", "\ref[turf_content].png")
					else
						turfitems[++turfitems.len] = list("[turf_content.name]", "\ref[turf_content]")
				turfitems = url_encode(json_encode(turfitems))
				target << output("[turfitems];", "statbrowser:update_listedturf")
		if(MC_TICK_CHECK)
			return
