/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	icon_state = "d_analyzer"
	var/obj/item/weapon/loaded_item = null
	var/decon_mod = 0
	circuit = /obj/item/weapon/circuitboard/destructive_analyzer

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/stock_parts/S in src)
		T += S.rating
	decon_mod = T * 0.1

/obj/machinery/r_n_d/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/r_n_d/destructive_analyzer/attackby(var/obj/item/I, var/mob/user as mob)
	if(busy)
		user << SPAN_NOTICE("\The [src] is busy right now.")
		return
	if(loaded_item)
		user << SPAN_NOTICE("There is something already loaded into \the [src].")
		return 1

	var/tool_type = I.get_tool_type(user, list(QUALITY_PRYING, QUALITY_SCREW_DRIVING))
	switch(tool_type)

		if(QUALITY_PRYING)
			if(!panel_open)
				user << SPAN_NOTICE("You cant get to the components of \the [src], remove the cover.")
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_PRD))
				user << SPAN_NOTICE("You remove the components of \the [src] with [I].")
				dismantle()
				return

		if(QUALITY_SCREW_DRIVING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_PRD, instant_finish_tier = 30, forced_sound = used_sound))
				if(linked_console)
					linked_console.linked_imprinter = null
					linked_console = null
				panel_open = !panel_open
				user << SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src] with [I].")
				update_icon()
				return

		if(ABORT_CHECK)
			return

	if(default_part_replacement(I, user))
		return
	if(panel_open)
		user << SPAN_NOTICE("You can't load \the [src] while it's opened.")
		return 1
	if(!linked_console)
		user << SPAN_NOTICE("\The [src] must be linked to an R&D console first.")
		return
	if(!loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return
		if(!I.origin_tech)
			user << SPAN_NOTICE("This doesn't seem to have a tech origin.")
			return
		if(I.origin_tech.len == 0)
			user << SPAN_NOTICE("You cannot deconstruct this item.")
			return
		busy = 1
		loaded_item = I
		user.drop_item()
		I.loc = src
		user << SPAN_NOTICE("You add \the [I] to \the [src].")
		flick("d_analyzer_la", src)
		spawn(10)
			update_icon()
			busy = 0
		return 1
	return
