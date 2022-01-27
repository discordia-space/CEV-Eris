//Bioreactor console
//In fact, this is not a console. Just69etrics screen


/obj/machinery/multistructure/bioreactor_part/console
	name = "bioreactor69etrics"
	icon_state = "screen"
	layer = ABOVE_MOB_LAYER + 0.1
	idle_power_usage = 350

/obj/machinery/multistructure/bioreactor_part/console/Initialize()
	. = ..()
	set_light(1, 2, COLOR_LIGHTING_BLUE_MACHINERY)


/obj/machinery/multistructure/bioreactor_part/console/attack_hand(mob/user as69ob)
	if(MS)
		ui_interact(user)


/obj/machinery/multistructure/bioreactor_part/console/ui_data()
	var/list/data = list()
	if(MS_bioreactor.is_operational())
		if(MS_bioreactor.chamber_solution)
			//operational
			data69"status"69 = 1
		else
			//solution required
			data69"status"69 = 2
	else
		if(MS_bioreactor.chamber_breached)
			//breach
			data69"status"69 = 3
		else if(!MS_bioreactor.chamber_closed)
			//chamber opened
			data69"status"69 = 4
		else if(MS_bioreactor.biotank_platform.pipes_opened)
			//tank at to-port position
			data69"status"69 = 5
		else if(!MS_bioreactor.biotank_platform.pipes_cleanness)
			//pipes issue
			data69"status"69 = 6
		else
			//non operational
			data69"status"69 = 0

	data69"biotank_occupancy"69 =69S_bioreactor.biotank_platform.biotank.reagents.total_volume || 0
	data69"biotank_max_capacity"69 =69S_bioreactor.biotank_platform.biotank.max_capacity
	data69"biotank_status"69 =69S_bioreactor.biotank_platform.pipes_opened
	data69"pipes_condition"69 =69S_bioreactor.biotank_platform.pipes_cleanness
	if(MS_bioreactor.biotank_platform.biotank.canister)
		data69"canister"69 =69S_bioreactor.biotank_platform.biotank.canister.name
	else
		data69"canister"69 = null

	return data


/obj/machinery/multistructure/bioreactor_part/console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bioreactor.tmpl", src.name, 410, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)