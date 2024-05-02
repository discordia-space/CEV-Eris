

/obj/machinery/cooking_with_jane/oven
	name = "Convection Oven"
	desc = "A cozy oven for baking food."
	description_info = "Ctrl+Click: Set Temperatures / Timers. \nShift+Ctrl+Click: Turn on the oven.\nAlt+Click: Empty container of physical food."
	icon = 'icons/obj/cwj_cooking/oven.dmi'
	icon_state = "oven"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	cooking = FALSE
	var/temperature= J_LO
	var/timer = 0
	var/timerstamp = 0
	var/switches = 0
	var/opened = FALSE
	var/cooking_timestamp = 0 //Timestamp of when cooking initialized so we know if the prep was disturbed at any point.
	var/items = null

	var/reference_time = 0 //The exact moment when we call the process routine, just to account for lag.

	var/power_cost = 3000 //Power cost per process step for a particular burner
	var/check_on_10 = 0

	var/on_fire = FALSE //if the oven has caught fire or not.

	circuit = /obj/item/electronics/circuitboard/cooking_with_jane/oven

//Did not want to use this...
/obj/machinery/cooking_with_jane/oven/Process()

	//if(on_fire)
		//Do bad things if it is on fire.

	if(switches)
		handle_cooking(null, FALSE)

	//Under normal circumstances, Only process the rest of this 10 process calls; it doesn't need to be hyper-accurate.
	if(check_on_10 != 10)
		check_on_10++
		return
	else
		check_on_10 = 0

	if(switches)
		use_power(power_cost)

/obj/machinery/cooking_with_jane/oven/RefreshParts()
	..()

	var/las_rating = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		las_rating += M.rating
	quality_mod = round(las_rating/2)

//Process how a specific oven is interacting with material
/obj/machinery/cooking_with_jane/oven/proc/cook_checkin()
	if(items)
		#ifdef CWJ_DEBUG
		log_debug("/cooking_with_jane/oven/proc/cook_checkin called on burner ")
		#endif
		var/old_timestamp = cooking_timestamp
		switch(temperature)
			if("Low")
				spawn(CWJ_BURN_TIME_LOW)
					if(cooking_timestamp == old_timestamp)
						handle_burning()
				spawn(CWJ_IGNITE_TIME_LOW)
					if(cooking_timestamp == old_timestamp)
						handle_ignition()

			if("Medium")
				spawn(CWJ_BURN_TIME_MEDIUM)
					if(cooking_timestamp == old_timestamp)
						handle_burning()
				spawn(CWJ_IGNITE_TIME_MEDIUM)
					if(cooking_timestamp == old_timestamp)
						handle_ignition()

			if("High")
				spawn(CWJ_BURN_TIME_HIGH)
					if(cooking_timestamp == old_timestamp)
						handle_burning()
				spawn(CWJ_IGNITE_TIME_HIGH)
					if(cooking_timestamp == old_timestamp)
						handle_ignition()

/obj/machinery/cooking_with_jane/oven/proc/handle_burning()
	if(!(items && istype(items, /obj/item/reagent_containers/cooking_with_jane/cooking_container)))
		return

	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = items
	container.handle_burning()

/obj/machinery/cooking_with_jane/oven/proc/handle_ignition()
	if(!(items && istype(items, /obj/item/reagent_containers/cooking_with_jane/cooking_container)))
		return

	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = items
	if(container.handle_ignition())
		on_fire = TRUE
/obj/machinery/cooking_with_jane/oven/attackby(var/obj/item/used_item, var/mob/user, params)
	if(default_deconstruction(used_item, user))
		return

	var/center_selected = getInput(params)

	if(opened && center_selected)
		if(items != null)
			var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = items
			container.process_item(used_item, params)

		else if(istype(used_item, /obj/item/reagent_containers/cooking_with_jane/cooking_container))
			to_chat(usr, SPAN_NOTICE("You put a [used_item] on the oven."))
			if(usr.canUnEquip(used_item))
				usr.unEquip(used_item, src)
			else
				used_item.forceMove(src)
			items = used_item
			if(switches == 1)
				cooking_timestamp = world.time
	else
		handle_open(user)
	update_icon()

//Retrieve whether or not the oven door has been clicked.
#define ICON_SPLIT_X_1 5
#define ICON_SPLIT_X_2 28
#define ICON_SPLIT_Y_1 5
#define ICON_SPLIT_Y_2 20
/obj/machinery/cooking_with_jane/oven/proc/getInput(params)
	var/list/click_params = params2list(params)
	var/input
	var/icon_x = text2num(click_params["icon-x"])
	var/icon_y = text2num(click_params["icon-y"])
	if(icon_x >= ICON_SPLIT_X_1 && icon_x <= ICON_SPLIT_X_2 && icon_y >= ICON_SPLIT_Y_1 && icon_y <= ICON_SPLIT_Y_2)
		input = TRUE
	else
		input = FALSE
	#ifdef CWJ_DEBUG
	log_debug("cooking_with_jane/oven/proc/getInput returned area [input]. icon-x: [click_params["icon-x"]], icon-y: [click_params["icon-y"]]")
	#endif
	return input
#undef ICON_SPLIT_X_1
#undef ICON_SPLIT_X_2
#undef ICON_SPLIT_Y_1
#undef ICON_SPLIT_Y_2


/obj/machinery/cooking_with_jane/oven/attack_hand(mob/user as mob, params)
	var/center_selected = getInput(params)

	switch(center_selected)
		if(TRUE)
			if(!opened)
				handle_open(user)
			else
				if(items != null)
					if(switches == 1)
						handle_cooking(user)
						cooking_timestamp = world.time
						if(ishuman(user) && (temperature == "High" || temperature == "Medium" ))
							var/mob/living/carbon/human/burn_victim = user
							if(!burn_victim.gloves)
								switch(temperature)
									if("High")
										burn_victim.adjustFireLoss(5)
									if("Medium")
										burn_victim.adjustFireLoss(2)
								to_chat(burn_victim, SPAN_DANGER("You burn your hand a little taking the [items] off of the oven."))
					user.put_in_hands(items)
					items = null
				else
					handle_open(user)
		if(FALSE)
			handle_open(user)
	update_icon()

/obj/machinery/cooking_with_jane/oven/CtrlClick(var/mob/user, params)
	if(user.stat || user.restrained() || (!in_range(src, user)))
		return

	#ifdef CWJ_DEBUG
	log_debug("/cooking_with_jane/oven/CtrlClick called ")
	#endif
	var/choice = alert(user,"Select an action","Select One:","Set temperature","Set timer","Cancel")
	switch(choice)
		if("Set temperature")
			handle_temperature(user)
		if("Set timer")
			handle_timer(user)

//Switch the cooking device on or off
/obj/machinery/cooking_with_jane/oven/CtrlShiftClick(var/mob/user, params)
	if(user.stat || user.restrained() || (!in_range(src, user)))
		return

	#ifdef CWJ_DEBUG
	log_debug("/cooking_with_jane/oven/CtrlShiftClick called")
	#endif
	handle_switch(user)

//Empty a container without a tool
/obj/machinery/cooking_with_jane/oven/AltClick(var/mob/user, params)
	if(user.stat || user.restrained() || (!in_range(src, user)))
		return

	var/center_selected = getInput(params)
	switch(center_selected)
		if(TRUE)
			if(!opened)
				to_chat(user, SPAN_NOTICE("The oven must be open to retrieve the food."))
			else
				if((items != null && istype(items, /obj/item/reagent_containers/cooking_with_jane/cooking_container)))
					var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = items

					#ifdef CWJ_DEBUG
					log_debug("/cooking_with_jane/oven/AltClick called on [container]")
					#endif
					container.do_empty(user)

/obj/machinery/cooking_with_jane/oven/proc/handle_open(var/mob/user)
	if(opened)
		opened = FALSE
	else
		opened = TRUE
		if(switches == 1)
			handle_switch(user)

/obj/machinery/cooking_with_jane/oven/proc/handle_temperature(var/mob/user)
	var/old_temp = temperature
	var/choice = input(user,"Select a heat setting for burner #.\nCurrent temp :[old_temp]","Select Temperature",old_temp) in list("High","Medium","Low","Cancel")
	if(choice && choice != "Cancel" && choice != old_temp)
		temperature = choice
		if(switches == 1)
			handle_cooking(user)
			cooking_timestamp = world.time
			timerstamp=world.time
			#ifdef CWJ_DEBUG
			log_debug("Timerstamp no.  set! New timerstamp: [timerstamp]")
			#endif


/obj/machinery/cooking_with_jane/oven/proc/handle_timer(var/mob/user)
	var/old_time = timer? round((timer/(1 SECONDS)), 1 SECONDS): 1
	timer = (input(user, "Enter a timer for burner # (In Seconds, 0 Stays On)","Set Timer", old_time) as num) SECONDS
	if(timer != 0 && switches == 1)
		timer_act(user)
	update_icon()

/obj/machinery/cooking_with_jane/oven/proc/timer_act(var/mob/user)

	timerstamp=round(world.time)
	#ifdef CWJ_DEBUG
	log_debug("Timerstamp set! New timerstamp: [timerstamp]")
	#endif
	var/old_timerstamp = timerstamp
	spawn(timer)
		#ifdef CWJ_DEBUG
		log_debug("Comparimg timerstamp() of [timerstamp] to old_timerstamp [old_timerstamp]")
		#endif
		if(old_timerstamp == timerstamp)
			playsound(src, 'sound/items/lighter.ogg', 100, 1, 0)

			handle_cooking(user, TRUE) //Do a check in the cooking interface
			switches = 0
			timerstamp=world.time
			cooking_timestamp = world.time
			update_icon()
	update_icon()

/obj/machinery/cooking_with_jane/oven/proc/handle_switch(user)

	if(switches == 1)
		playsound(src, 'sound/items/lighter.ogg', 100, 1, 0)
		handle_cooking(user)
		switches = 0
		timerstamp=world.time
		#ifdef CWJ_DEBUG
		log_debug("Timerstamp no.  set! New timerstamp: [timerstamp]")
		#endif
		cooking_timestamp = world.time
	else
		if(opened)
			to_chat(user, SPAN_NOTICE("The oven must be closed in order to turn it on."))
			return
		playsound(src, 'sound/items/lighter.ogg', 100, 1, 0)
		switches = 1
		cooking_timestamp = world.time
		cook_checkin(user)
		if(timer != 0)
			timer_act(user)
	update_icon()



/obj/machinery/cooking_with_jane/oven/proc/handle_cooking(var/mob/user, set_timer=FALSE)

	if(!(items && istype(items, /obj/item/reagent_containers/cooking_with_jane/cooking_container)))
		return

	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = items
	if(set_timer)
		reference_time = timer
	else
		reference_time = world.time - cooking_timestamp


	#ifdef CWJ_DEBUG
	log_debug("oven/proc/handle_cooking data:")
	log_debug("     temperature: [temperature]")
	log_debug("     reference_time: [reference_time]")
	log_debug("     world.time: [world.time]")
	log_debug("     cooking_timestamp: [cooking_timestamp]")
	log_debug("     oven_data: [container.oven_data]")
	#endif


	if(container.oven_data[temperature])
		container.oven_data[temperature] += reference_time
	else
		container.oven_data[temperature] = reference_time


	if(user && user.Adjacent(src))
		container.process_item(src, user, send_message=TRUE)
	else
		container.process_item(src, user)



/obj/machinery/cooking_with_jane/oven/update_icon()
	cut_overlays()
	icon_state = "oven_base"
	for(var/obj/item/our_item in vis_contents)
		src.remove_from_visible(our_item)

	if(items)
		var/obj/item/our_item = items
		our_item.pixel_x = 0
		our_item.pixel_y = -5
		src.add_to_visible(our_item)
	if(!opened)
		add_overlay(image(src.icon, icon_state="oven_hatch[switches?"_on":""]", layer=ABOVE_OBJ_LAYER))

/obj/machinery/cooking_with_jane/oven/proc/add_to_visible(var/obj/item/our_item)
	our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	src.vis_contents += our_item
	our_item.transform *= 0.8

/obj/machinery/cooking_with_jane/oven/proc/remove_from_visible(var/obj/item/our_item)
	our_item.vis_flags = 0
	our_item.blend_mode = 0
	our_item.transform =  null
	src.vis_contents.Remove(our_item)

/obj/machinery/cooking_with_jane/oven/verb/toggle_burner()
	set src in view(1)
	set name = "Oven - Toggle"
	set category = "Object"
	set desc = "Turn on the oven"
	#ifdef CWJ_DEBUG
	log_debug("/cooking_with_jane/oven/verb/toggle_burner_1() called")
	#endif
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_switch(usr)


/obj/machinery/cooking_with_jane/oven/verb/change_temperature()
	set src in view(1)
	set name = "Oven - Set Temp"
	set category = "Object"
	set desc = "Set a temperature for the oven."
	#ifdef CWJ_DEBUG
	log_debug("/cooking_with_jane/oven/verb/change_temperature_1() called")
	#endif
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_temperature(usr)

/obj/machinery/cooking_with_jane/oven/verb/change_timer()
	set src in view(1)
	set name = "Oven - Set Timer"
	set category = "Object"
	set desc = "Set a timer for the oven."
	#ifdef CWJ_DEBUG
	log_debug("/cooking_with_jane/oven/verb/change_timer() called")
	#endif
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_timer(usr)

/obj/machinery/cooking_with_jane/oven/verb/toggle_door()
	set src in view(1)
	set name = "Oven - Open/Close door"
	set category = "Object"
	set desc = "Open/Close the door of the oven."
	#ifdef CWJ_DEBUG
	log_debug("/cooking_with_jane/oven/verb/toggle_door() called")
	#endif
	if(!ishuman(usr) && !isrobot(usr))
		return
	handle_open(usr)
