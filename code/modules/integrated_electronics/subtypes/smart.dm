/obj/item/integrated_circuit/smart
	category_text = "Smart"

/obj/item/integrated_circuit/smart/basic_pathfinder
	name = "basic pathfinder"
	desc = "This complex circuit is able to determine what direction a given target is."
	extended_desc = "This circuit uses a miniturized integrated camera to determine where the target is. If the machine \
	cannot see the target, it will not be able to calculate the correct direction."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("target" = IC_PINTYPE_REF,"ignore obstacles" = IC_PINTYPE_BOOLEAN)
	outputs = list("dir" = IC_PINTYPE_DIR)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT,"not calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/smart/basic_pathfinder/do_work()
	var/datum/integrated_io/I = inputs[1]
	set_pin_data(IC_OUTPUT, 1, null)
	if(!isweakref(I.data))
		activate_pin(3)
		return
	var/atom/A = I.data.resolve()
	if(!A)
		activate_pin(3)
		return
	if(!(A in view(get_turf(src))))
		push_data()
		activate_pin(3)
		return // Can't see the target.

	if(get_pin_data(IC_INPUT, 2))
		set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_turf(A)))
	else
		set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_step_towards2(get_turf(src),A)))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/smart/coord_basic_pathfinder
	name = "coordinate pathfinder"
	desc = "This complex circuit is able to determine what direction a given target is."
	extended_desc = "This circuit uses absolute coordinates to determine where the target is. If the machine \
	cannot see the target, it will not be able to calculate the correct direction. \
	This circuit will only work while inside an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("X" = IC_PINTYPE_NUMBER,"Y" = IC_PINTYPE_NUMBER,"ignore obstacles" = IC_PINTYPE_BOOLEAN)
	outputs = list(	"dir" 					= IC_PINTYPE_DIR,
					"distance"				= IC_PINTYPE_NUMBER
	)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT,"not calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/smart/coord_basic_pathfinder/do_work()
	if(!assembly)
		activate_pin(3)
		return
	var/turf/T = get_turf(assembly)
	var/target_x = clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
	var/target_y = clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
	var/turf/A = locate(target_x, target_y, T.z)
	set_pin_data(IC_OUTPUT, 1, null)
	if(!A||A==T)
		activate_pin(3)
		return
	if(get_pin_data(IC_INPUT, 2))
		set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_turf(A)))
	else
		set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_step_towards2(get_turf(src),A)))
	set_pin_data(IC_OUTPUT, 2, sqrt((A.x-T.x)*(A.x-T.x)+ (A.y-T.y)*(A.y-T.y)))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/smart/advanced_pathfinder
	name = "advanced pathfinder"
	desc = "This circuit uses a complex processor for long-range pathfinding."
	extended_desc = "This circuit uses absolute coordinates to find its target. A path will be generated to the target, taking obstacles into account, \
	and pathing around any instances of said input. The passkey provided from a card reader is used to calculate a valid path through airlocks."
	icon_state = "numberpad"
	complexity = 40
	cooldown_per_use = 5 SECONDS
	inputs = list("X target" = IC_PINTYPE_NUMBER,"Y target" = IC_PINTYPE_NUMBER,"obstacle" = IC_PINTYPE_REF)
	outputs = list("X" = IC_PINTYPE_LIST,"Y" = IC_PINTYPE_LIST)
	activators = list("calculate path" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT,"not calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/smart/advanced_pathfinder/Initialize()
	.=..()

/obj/item/integrated_circuit/smart/advanced_pathfinder/do_work()
	if(!assembly)
		activate_pin(3)
		return

	var/turf/a_loc = get_turf(assembly)
	var/turf/b_loc = locate(clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx), clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy), a_loc.z)
	var/list/P = AStar(a_loc, b_loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 200, id = assembly.access_card, exclude=get_turf(get_pin_data_as_type(IC_INPUT, 3, /atom)))

	if(!islist(P))
		activate_pin(3)
		return
	else
		var/list/Xn[length(P)]
		var/list/Yn[length(P)]
		var/turf/T
		for(var/i = 1, i <= length(P), i++)
			T=P[i]
			Xn[i] = T.x
			Yn[i] = T.y
		set_pin_data(IC_OUTPUT, 1, Xn)
		set_pin_data(IC_OUTPUT, 2, Yn)
		push_data()
		activate_pin(2)

// mob changes
/mob/living/var/check_bot_self = FALSE

// - MMI Tank - //
/obj/item/integrated_circuit/input/mmi_tank
	name = "man-machine interface tank"
	desc = "This circuit is just a jar filled with an artificial liquid mimicking the cerebrospinal fluid."
	extended_desc = "This jar can hold 1 man-machine interface and let it take control of some basic functions of the assembly."
	complexity = 29
	outputs = list(
		"man-machine interface" = IC_PINTYPE_REF,
		"direction" = IC_PINTYPE_DIR,
		"click target" = IC_PINTYPE_REF
		)
	activators = list(
		"move" = IC_PINTYPE_PULSE_OUT,
		"left" = IC_PINTYPE_PULSE_OUT,
		"right" = IC_PINTYPE_PULSE_OUT,
		"up" = IC_PINTYPE_PULSE_OUT,
		"down" = IC_PINTYPE_PULSE_OUT,
		"leftclick" = IC_PINTYPE_PULSE_OUT,
		"shiftclick" = IC_PINTYPE_PULSE_OUT,
		"altclick" = IC_PINTYPE_PULSE_OUT,
		"ctrlclick" = IC_PINTYPE_PULSE_OUT
		)
	movement_handlers = list(/datum/movement_handler/move_relay_self)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 150
	can_be_asked_input = TRUE
	demands_object_input = TRUE

	var/obj/item/device/mmi/installed_brain

/obj/item/integrated_circuit/input/mmi_tank/attackby(obj/item/device/mmi/O, mob/user)
	if(!istype(O,/obj/item/device/mmi))
		to_chat(user,SPAN("warning", "You can't put that inside."))
		return
	if(installed_brain)
		to_chat(user,SPAN("warning", "There's already a brain inside."))
		return
	user.drop_item(O)
	O.forceMove(src)
	installed_brain = O
	can_be_asked_input = FALSE
	to_chat(user, SPAN("notice", "You gently place \the man-machine interface inside the tank."))
	to_chat(O, SPAN("notice", "You are slowly being placed inside the man-machine-interface tank."))
	set_pin_data(IC_OUTPUT, 1, O)

/obj/item/integrated_circuit/input/mmi_tank/attack_self(mob/user)
	if(installed_brain)
		RemoveBrain()
		to_chat(user, SPAN("notice", "You slowly lift [installed_brain] out of the MMI tank."))
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_brain = null
		push_data()
	else
		to_chat(user, SPAN("notice", "You don't see any brain swimming in the tank."))

/obj/item/integrated_circuit/input/mmi_tank/Destroy()
	RemoveBrain()

	return ..()

/obj/item/integrated_circuit/input/mmi_tank/relaymove(mob/user, direction)
	set_pin_data(IC_OUTPUT, 2, direction)
	do_work(1)
	switch(direction)
		if(8)	activate_pin(2)
		if(4)	activate_pin(3)
		if(1)	activate_pin(4)
		if(2)	activate_pin(5)

/obj/item/integrated_circuit/input/mmi_tank/do_work(ord)
	push_data()
	activate_pin(ord)

/obj/item/integrated_circuit/input/mmi_tank/proc/RemoveBrain()
	if(installed_brain)
		can_be_asked_input = TRUE
		installed_brain.forceMove(get_turf(src))
		set_pin_data(IC_OUTPUT, 1, WEAKREF(null))

//Brain changes
/mob/living/carbon/brain/ClickOn(atom/A, params)
	..()
	var/obj/item/integrated_circuit/input/mmi_tank/brainholder
	if(istype(loc, /obj/item/device/mmi))
		var/obj/item/device/mmi/H = loc
		if(istype(H.loc, /obj/item/integrated_circuit/input/mmi_tank))
			brainholder = H.loc
	if(!istype(brainholder))
		return
	brainholder.set_pin_data(IC_OUTPUT, 3, A)
	var/list/modifiers = params2list(params)

	if(modifiers["shift"])
		brainholder.do_work(7)
		return
	if(modifiers["alt"])
		brainholder.do_work(8)
		return
	if(modifiers["ctrl"])
		brainholder.do_work(9)
		return

	if(istype(A,/obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/holdingassembly = A

		if(brainholder in holdingassembly.assembly_components)
			check_bot_self = TRUE

			if(holdingassembly.opened)
				holdingassembly.nano_ui_interact(src)
			holdingassembly.attack_self(src)
			check_bot_self = FALSE
			return

	brainholder.do_work(6)

// - pAI connector circuit - //
/obj/item/integrated_circuit/input/pAI_connector
	name = "pAI connector circuit"
	desc = "This circuit lets you fit in a personal artificial intelligence to give it some form of control over the bot."
	extended_desc = "You can wire various functions to it."
	complexity = 29
	outputs = list(
		"personal artificial intelligence" = IC_PINTYPE_REF,
		"direction" = IC_PINTYPE_DIR,
		"click target" = IC_PINTYPE_REF
		)
	activators = list(
		"move" = IC_PINTYPE_PULSE_OUT,
		"left" = IC_PINTYPE_PULSE_OUT,
		"right" = IC_PINTYPE_PULSE_OUT,
		"up" = IC_PINTYPE_PULSE_OUT,
		"down" = IC_PINTYPE_PULSE_OUT,
		"leftclick" = IC_PINTYPE_PULSE_OUT,
		"shiftclick" = IC_PINTYPE_PULSE_OUT,
		"altclick" = IC_PINTYPE_PULSE_OUT,
		"ctrlclick" = IC_PINTYPE_PULSE_OUT,
		"shiftctrlclick" = IC_PINTYPE_PULSE_OUT
		)
	movement_handlers = list(/datum/movement_handler/move_relay_self)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 150
	can_be_asked_input = TRUE
	demands_object_input = TRUE

	var/obj/item/device/paicard/installed_pai

/obj/item/integrated_circuit/input/pAI_connector/attackby(obj/item/device/paicard/O, mob/user)
	if(!istype(O,/obj/item/device/paicard))
		to_chat(user,SPAN("warning", "You can't put that inside."))
		return
	if(installed_pai)
		to_chat(user,SPAN("warning", "There's already a pAI connected to this."))
		return
	user.drop_item(O)
	O.forceMove(src)
	installed_pai = O
	can_be_asked_input = FALSE
	to_chat(user, SPAN("notice", "You slowly connect the circuit's pins to the [installed_pai]."))
	to_chat(O, SPAN("notice", "You are slowly being connected to the pAI connector."))
	set_pin_data(IC_OUTPUT, 1, O)

/obj/item/integrated_circuit/input/pAI_connector/attack_self(mob/user)
	if(installed_pai)
		RemovepAI()
		to_chat(user, SPAN("notice", "You slowly disconnect the circuit's pins from the [installed_pai]."))
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_pai = null
		push_data()
	else
		to_chat(user, SPAN("notice", "The connection port is empty."))

/obj/item/integrated_circuit/input/pAI_connector/relaymove(mob/user, direction)
	set_pin_data(IC_OUTPUT, 2, direction)
	do_work(1)
	switch(direction)
		if(8)	activate_pin(2)
		if(4)	activate_pin(3)
		if(1)	activate_pin(4)
		if(2)	activate_pin(5)

/obj/item/integrated_circuit/input/pAI_connector/do_work(n)
	push_data()
	activate_pin(n)


/obj/item/integrated_circuit/input/pAI_connector/Destroy()
	RemovepAI()

	return ..()

/obj/item/integrated_circuit/input/pAI_connector/proc/RemovepAI()
	if(installed_pai)
		can_be_asked_input = TRUE
		installed_pai.forceMove(get_turf(src))
		set_pin_data(IC_OUTPUT, 1, WEAKREF(null))


//pAI changes
/mob/living/silicon/pai/ClickOn(atom/A, params)
	..()
	var/obj/item/integrated_circuit/input/pAI_connector/paiholder
	if(istype(loc, /obj/item/device/paicard))
		var/obj/item/device/paicard/H = loc
		if(istype(H.loc, /obj/item/integrated_circuit/input/pAI_connector))
			paiholder = H.loc

	if(!istype(paiholder))
		return

	paiholder.set_pin_data(IC_OUTPUT, 3, A)
	var/list/modifiers = params2list(params)

	if(modifiers["shift"] && modifiers["ctrl"])
		paiholder.do_work(10)
		return
	if(modifiers["shift"])
		paiholder.do_work(7)
		return
	if(modifiers["alt"])
		paiholder.do_work(8)
		return
	if(modifiers["ctrl"])
		paiholder.do_work(9)
		return

	if(istype(A,/obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/holdingassembly = A

		if(paiholder in holdingassembly.assembly_components)
			check_bot_self = TRUE

			if(holdingassembly.opened)
				holdingassembly.nano_ui_interact(src)
			holdingassembly.attack_self(src)
			check_bot_self = FALSE
			return

	paiholder.do_work(6)

// - AI connector circuit - //
/obj/item/integrated_circuit/input/AI_connector
	name = "AI connector circuit"
	desc = "This circuit lets you fit in a carded artificial intelligence to give it some form of control over the bot."
	extended_desc = "This jar can hold 1 man-machine interface and let it take control of some basic functions of the assembly."
	complexity = 29
	outputs = list(
		"carded artificial intelligence" = IC_PINTYPE_REF,
		"direction" = IC_PINTYPE_DIR,
		"click target" = IC_PINTYPE_REF
		)
	activators = list(
		"move" = IC_PINTYPE_PULSE_OUT,
		"left" = IC_PINTYPE_PULSE_OUT,
		"right" = IC_PINTYPE_PULSE_OUT,
		"up" = IC_PINTYPE_PULSE_OUT,
		"down" = IC_PINTYPE_PULSE_OUT,
		"leftclick" = IC_PINTYPE_PULSE_OUT,
		"shiftclick" = IC_PINTYPE_PULSE_OUT,
		"altclick" = IC_PINTYPE_PULSE_OUT,
		"ctrlclick" = IC_PINTYPE_PULSE_OUT
		)
	movement_handlers = list(/datum/movement_handler/move_relay_self)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 150
	can_be_asked_input = TRUE
	demands_object_input = TRUE

	var/obj/item/device/aicard/installed_brain

/obj/item/integrated_circuit/input/AI_connector/attackby(obj/item/device/aicard/O, mob/user)
	if(!istype(O,/obj/item/device/aicard))
		to_chat(user,SPAN("warning", "You can't put that inside."))
		return
	if(installed_brain)
		to_chat(user,SPAN("warning", "There's already a brain inside."))
		return
	user.drop_item(O)
	O.forceMove(src)
	installed_brain = O
	can_be_asked_input = FALSE
	to_chat(user, SPAN("notice", "You gently place \the man-machine interface inside the tank."))
	to_chat(O, SPAN("notice", "You are slowly being placed inside the man-machine-interface tank."))
	set_pin_data(IC_OUTPUT, 1, O)

/obj/item/integrated_circuit/input/AI_connector/attack_self(mob/user)
	if(installed_brain)
		RemoveBrain()
		to_chat(user, SPAN("notice", "You slowly lift [installed_brain] out of the MMI tank."))
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_brain = null
		push_data()
	else
		to_chat(user, SPAN("notice", "You don't see any brain swimming in the tank."))

/obj/item/integrated_circuit/input/AI_connector/Destroy()
	RemoveBrain()

	return ..()

/obj/item/integrated_circuit/input/AI_connector/relaymove(mob/user, direction)
	set_pin_data(IC_OUTPUT, 2, direction)
	do_work(1)
	switch(direction)
		if(8)	activate_pin(2)
		if(4)	activate_pin(3)
		if(1)	activate_pin(4)
		if(2)	activate_pin(5)

/obj/item/integrated_circuit/input/AI_connector/do_work(ord)
	push_data()
	activate_pin(ord)

/obj/item/integrated_circuit/input/AI_connector/proc/RemoveBrain()
	if(installed_brain)
		can_be_asked_input = TRUE
		installed_brain.forceMove(get_turf(src))
		set_pin_data(IC_OUTPUT, 1, WEAKREF(null))

//AI changes
/mob/living/silicon/ai/ClickOn(atom/A, params)
	..()
	var/obj/item/integrated_circuit/input/AI_connector/brainholder
	if(istype(loc, /obj/item/device/aicard))
		var/obj/item/device/aicard/H = loc
		if(istype(H.loc, /obj/item/integrated_circuit/input/AI_connector))
			brainholder = H.loc
	if(!istype(brainholder))
		return
	brainholder.set_pin_data(IC_OUTPUT, 3, A)
	var/list/modifiers = params2list(params)

	if(modifiers["shift"])
		brainholder.do_work(7)
		return
	if(modifiers["alt"])
		brainholder.do_work(8)
		return
	if(modifiers["ctrl"])
		brainholder.do_work(9)
		return

	if(istype(A,/obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/holdingassembly = A

		if(brainholder in holdingassembly.assembly_components)
			check_bot_self = TRUE

			if(holdingassembly.opened)
				holdingassembly.nano_ui_interact(src)
			holdingassembly.attack_self(src)
			check_bot_self = FALSE
			return

	brainholder.do_work(6)
