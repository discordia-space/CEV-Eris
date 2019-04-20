

/obj/machinery/multistructure/bioreactor_part/console
	name = "bioreactor metrics"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "screen"
	layer = ABOVE_MOB_LAYER + 0.1
	idle_power_usage = 350

/obj/machinery/multistructure/bioreactor_part/console/Initialize()
	..()
	set_light(1, 2, COLOR_LIGHTING_BLUE_MACHINERY)


/obj/machinery/multistructure/bioreactor_part/console/attack_hand(mob/user as mob)
	if(MS)
		return ui_interact(user)


/obj/machinery/multistructure/bioreactor_part/console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	if(MS_bioreactor.is_operational())
		if(MS_bioreactor.chamber_solution)
			data["status"] = "operational"
		else
			data["status"] = "solution required"
	else
		if(MS_bioreactor.chamber_breached)
			data["status"] = "chamber breached"
		else if(!MS_bioreactor.chamber_closed)
			data["status"] = "chamber opened"
		else if(MS_bioreactor.biotank_platform.pipes_opened)
			data["status"] = "pipes opened"
		else if(!MS_bioreactor.biotank_platform.pipes_cleanness)
			data["status"] = "major pipes issue detected"
		else
			data["status"] = "non operational"
	data["biotank_occupancy"] = MS_bioreactor.biotank_platform.biotank.reagents.total_volume || 0
	data["biotank_max_capacity"] = MS_bioreactor.biotank_platform.biotank.max_capacity
	data["biotank_status"] = MS_bioreactor.biotank_platform.pipes_opened
	data["pipes_condition"] = MS_bioreactor.biotank_platform.pipes_cleanness
	if(MS_bioreactor.biotank_platform.biotank.canister)
		data["canister"] = MS_bioreactor.biotank_platform.biotank.canister.name
	else
		data["canister"] = null


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bioreactor.tmpl", src.name, 410, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)