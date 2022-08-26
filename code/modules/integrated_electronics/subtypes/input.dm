/obj/item/integrated_circuit/input
	var/can_be_asked_input = FALSE
	category_text = "Input"
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/proc/ask_for_input(mob/user)
	return

/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	complexity = 1
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list()
	activators = list("on pressed" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	radial_menu_icon = "button"

/obj/item/integrated_circuit/input/button/ask_for_input(mob/user) //Bit misleading name for this specific use.
	to_chat(user, SPAN("notice", "You press the button labeled '[displayed_name]'."))
	activate_pin(1)

/obj/item/integrated_circuit/input/button/get_topic_data(mob/user)
	return list("Press" = "press=1")

/obj/item/integrated_circuit/input/button/OnICTopic(href_list, user)
	if(href_list["press"])
		to_chat(user, SPAN("notice", "You press the button labeled '[src.displayed_name]'."))
		activate_pin(1)
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/toggle_button
	name = "toggle button"
	desc = "It toggles on, off, on, off..."
	icon_state = "toggle_button"
	complexity = 1
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list("on" = IC_PINTYPE_BOOLEAN)
	activators = list("on toggle" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	radial_menu_icon = "toggle_button_on"

/obj/item/integrated_circuit/input/toggle_button/ask_for_input(mob/user) // Ditto.
	var/state = !get_pin_data(IC_OUTPUT, 1)
	radial_menu_icon = "toggle_button_[state ? "on" : "off"]"
	set_pin_data(IC_OUTPUT, 1, state)
	push_data()
	activate_pin(1)
	to_chat(user, SPAN("notice", "You toggle the button labeled \"[displayed_name]\" [get_pin_data(IC_OUTPUT, 1) ? "on" : "off"]."))

/obj/item/integrated_circuit/input/toggle_button/get_topic_data(mob/user)
	return list("Toggle [get_pin_data(IC_OUTPUT, 1) ? "Off" : "On"]" = "toggle=1")

/obj/item/integrated_circuit/input/toggle_button/OnICTopic(href_list, user)
	if(href_list["toggle"])
		set_pin_data(IC_OUTPUT, 1, !get_pin_data(IC_OUTPUT, 1))
		push_data()
		activate_pin(1)
		to_chat(user, SPAN("notice", "You toggle the button labeled \"[displayed_name]\" [get_pin_data(IC_OUTPUT, 1) ? "on" : "off"]."))
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	complexity = 2
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list("number entered" = IC_PINTYPE_NUMBER)
	activators = list("on entered" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4
	radial_menu_icon = "numberpad"

/obj/item/integrated_circuit/input/numberpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter a number, please.",displayed_name) as null|num
	if(isnum_safe(new_input) && user.IsAdvancedToolUser())
		set_pin_data(IC_OUTPUT, 1, new_input)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/numberpad/get_topic_data(mob/user)
	return list("Enter Number" = "enter_number=1")

/obj/item/integrated_circuit/input/numberpad/OnICTopic(href_list, mob/user)
	if(href_list["enter_number"])
		var/new_input = input(user, "Enter a number, please.", displayed_name) as num|null
		if(isnum_safe(new_input) && user.IsAdvancedToolUser())
			set_pin_data(IC_OUTPUT, 1, new_input)
			push_data()
			activate_pin(1)
		return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "textpad"
	complexity = 2
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list("string entered" = IC_PINTYPE_STRING)
	activators = list("on entered" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4
	radial_menu_icon = "textpad"

/obj/item/integrated_circuit/input/textpad/ask_for_input(mob/user)
	var/new_input = sanitize(input(user, "Enter some words, please.", displayed_name) as text|null)
	if(istext(new_input) && user.IsAdvancedToolUser())
		set_pin_data(IC_OUTPUT, 1, new_input)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/textpad/get_topic_data(mob/user)
	return list("Enter Words" = "enter_words=1")

/obj/item/integrated_circuit/input/textpad/OnICTopic(href_list, mob/user)
	if(href_list["enter_words"])
		var/new_input = input(user, "Enter some words, please.", displayed_name)
		new_input = sanitize(new_input)
		if(istext(new_input) && user.IsAdvancedToolUser())
			set_pin_data(IC_OUTPUT, 1, new_input)
			push_data()
			activate_pin(1)
			return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/colorpad
	name = "color pad"
	desc = "This small color pad allows someone to input a hexadecimal color into the system."
	icon_state = "colorpad"
	complexity = 2
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list("color entered" = IC_PINTYPE_STRING)
	activators = list("on entered" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4
	radial_menu_icon = "colorpad"

/obj/item/integrated_circuit/input/colorpad/ask_for_input(mob/user)
	var/new_color = input(user, "Enter a color, please.", "Color", "#ffffff") as color|null
	if(new_color && user.IsAdvancedToolUser())
		set_pin_data(IC_OUTPUT, 1, new_color)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/colorpad/get_topic_data(mob/user)
	return list("Enter Color" = "enter_color=1")

/obj/item/integrated_circuit/input/colorpad/OnICTopic(href_list, mob/user)
	if(href_list["enter_color"])
		var/new_color = input(user, "Enter a color, please.", "Color", "#ffffff") as color|null
		if(new_color && user.IsAdvancedToolUser())
			set_pin_data(IC_OUTPUT, 1, new_color)
			push_data()
			activate_pin(1)
			return IC_TOPIC_REFRESH

/obj/item/integrated_circuit/input/slime_scanner
	name = "slime scanner"
	desc = "A very small version of the xenobio analyser. This allows the machine to know every needed properties of slime. Output mutation list is non-associative."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"colour"				= IC_PINTYPE_STRING,
		"adult"					= IC_PINTYPE_BOOLEAN,
		"nutrition"				= IC_PINTYPE_NUMBER,
		"charge"				= IC_PINTYPE_NUMBER,
		"health"				= IC_PINTYPE_NUMBER,
		"possible mutation"		= IC_PINTYPE_LIST,
		"genetic destability"	= IC_PINTYPE_NUMBER,
		"slime core amount"		= IC_PINTYPE_NUMBER,
		"growth progress"		= IC_PINTYPE_NUMBER,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/slime_scanner/do_work()
	var/mob/living/carbon/slime/T = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/slime)
	if(!isslime(T)) //Invalid input
		return
	if(T in view(get_turf(src))) // Like medbot's analyzer it can be used in range..

		set_pin_data(IC_OUTPUT, 1, T.colour)
		set_pin_data(IC_OUTPUT, 2, T.is_adult)
		set_pin_data(IC_OUTPUT, 3, T.nutrition/T.get_max_nutrition())
		set_pin_data(IC_OUTPUT, 4, T.powerlevel)
		set_pin_data(IC_OUTPUT, 5, round(T.health/T.maxHealth,0.01)*100)
		set_pin_data(IC_OUTPUT, 6, T.slime_mutation)
		set_pin_data(IC_OUTPUT, 7, T.mutation_chance)
		set_pin_data(IC_OUTPUT, 8, T.cores)
		set_pin_data(IC_OUTPUT, 9, T.amount_grown/10)


	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/plant_scanner
	name = "integrated plant analyzer"
	desc = "A very small version of the plant analyser. This allows the machine to know all valuable parameters of plants in trays. \
			It can only scan plants, not seeds or fruits."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"plant type"			= IC_PINTYPE_STRING,
		"age"					= IC_PINTYPE_NUMBER,
		"potency"				= IC_PINTYPE_NUMBER,
		"yield"					= IC_PINTYPE_NUMBER,
		"Maturation speed"		= IC_PINTYPE_NUMBER,
		"Production speed"		= IC_PINTYPE_NUMBER,
		"Endurance"				= IC_PINTYPE_NUMBER,
		"Lifespan"				= IC_PINTYPE_NUMBER,
		"Weed Resistance"		= IC_PINTYPE_NUMBER,
		"Weed level"			= IC_PINTYPE_NUMBER,
		"Pest level"			= IC_PINTYPE_NUMBER,
		"Water level"			= IC_PINTYPE_NUMBER,
		"Nutrition level"		= IC_PINTYPE_NUMBER,
		"harvest"				= IC_PINTYPE_NUMBER,
		"dead"					= IC_PINTYPE_NUMBER,
		"plant health"			= IC_PINTYPE_NUMBER,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 10

/obj/item/integrated_circuit/input/plant_scanner/do_work()
	var/obj/machinery/portable_atmospherics/hydroponics/H = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/portable_atmospherics/hydroponics)
	if(!istype(H)) //Invalid input
		return
	for(var/i=1, i<=outputs.len, i++)
		set_pin_data(IC_OUTPUT, i, null)
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..
		if(H.seed)
			set_pin_data(IC_OUTPUT, 1, H.seed.seed_name)
			set_pin_data(IC_OUTPUT, 2, H.age)
			set_pin_data(IC_OUTPUT, 3, H.seed.get_trait(TRAIT_POTENCY))
			set_pin_data(IC_OUTPUT, 4, H.seed.get_trait(TRAIT_YIELD))
			set_pin_data(IC_OUTPUT, 5, H.seed.get_trait(TRAIT_MATURATION))
			set_pin_data(IC_OUTPUT, 6, H.seed.get_trait(TRAIT_PRODUCTION))
			set_pin_data(IC_OUTPUT, 7, H.seed.get_trait(TRAIT_ENDURANCE))
			set_pin_data(IC_OUTPUT, 8, !!H.seed.get_trait(TRAIT_HARVEST_REPEAT))
			set_pin_data(IC_OUTPUT, 9, H.seed.get_trait(TRAIT_WEED_TOLERANCE))
		set_pin_data(IC_OUTPUT, 10, H.weedlevel)
		set_pin_data(IC_OUTPUT, 11, H.pestlevel)
		set_pin_data(IC_OUTPUT, 12, H.waterlevel)
		set_pin_data(IC_OUTPUT, 13, H.nutrilevel)
		set_pin_data(IC_OUTPUT, 14, H.harvest)
		set_pin_data(IC_OUTPUT, 15, H.dead)
		set_pin_data(IC_OUTPUT, 16, H.health)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/view_filter
	name = "view filter"
	desc = "This circuit will filter every object in assembly view."
	extended_desc = "The first pin is ref to filter, to see avaliable filters go to Filter category. The output will contents everything with filtering type"
	inputs = list(
		"filter" = IC_PINTYPE_REF
	)
	outputs = list(
		"objects" = IC_PINTYPE_LIST
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/view_filter/do_work(ord)
	var/list/objects = list()
	var/obj/item/integrated_circuit/filter/ref/filter = get_pin_data(IC_INPUT, 1)
	if(istype(filter) && assembly && (filter in assembly.assembly_components))
		for(var/atom/A in view(get_turf(assembly)))
			if(istype(A, filter.filter_type))
				objects.Add(WEAKREF(A))
		set_pin_data(IC_OUTPUT, 1, objects)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/gene_scanner
	name = "gene scanner"
	desc = "This circuit will scan the target plant for traits and reagent genes. Output is non-associative."
	extended_desc = "This allows the machine to scan plants in trays for reagent and trait genes. \
			It can only scan plants, not seeds or fruits."
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"reagents" = IC_PINTYPE_LIST
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	icon_state = "medscan_adv"
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/gene_scanner/do_work()
	var/list/greagents = list()
	var/obj/machinery/portable_atmospherics/hydroponics/H = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/portable_atmospherics/hydroponics)
	if(!istype(H)) //Invalid input
		return
	for(var/i=1, i<=outputs.len, i++)
		set_pin_data(IC_OUTPUT, i, null)
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..
		if(H.seed)
			for(var/chem_path in H.seed.chems)
				var/datum/reagent/R = chem_path
				greagents.Add(initial(R.name))

	set_pin_data(IC_OUTPUT, 1, greagents)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/examiner
	name = "examiner"
	desc = "A little machine vision system. It can return the name, description, distance, \
	relative coordinates, total amount of reagents, maximum amount of reagents, density, and opacity of the referenced object."
	icon_state = "video_camera"
	complexity = 6
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"name"				 	= IC_PINTYPE_STRING,
		"description"			= IC_PINTYPE_STRING,
		"X"						= IC_PINTYPE_NUMBER,
		"Y"						= IC_PINTYPE_NUMBER,
		"distance"				= IC_PINTYPE_NUMBER,
		"max reagents"			= IC_PINTYPE_NUMBER,
		"amount of reagents"	= IC_PINTYPE_NUMBER,
		"density"				= IC_PINTYPE_BOOLEAN,
		"opacity"				= IC_PINTYPE_BOOLEAN,
		"occupied turf"			= IC_PINTYPE_REF
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80
	var/stat = CONSCIOUS // for examine proc.

/obj/item/integrated_circuit/input/examiner/do_work()
	var/atom/H = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/turf/T = get_turf(src)

	if(!istype(H) || (!(H in view(T) || (H in assembly.loc)))) // if assembly located in same loc with object, we can scan it.
		activate_pin(3)
	else
		set_pin_data(IC_OUTPUT, 1, H.name)
		set_pin_data(IC_OUTPUT, 2, H.desc)

		if(istype(H, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = H
			var/msg = M.examine(src)
			if(msg)
				set_pin_data(IC_OUTPUT, 2, msg)

		set_pin_data(IC_OUTPUT, 3, H.x-T.x)
		set_pin_data(IC_OUTPUT, 4, H.y-T.y)
		set_pin_data(IC_OUTPUT, 5, sqrt((H.x-T.x)*(H.x-T.x)+ (H.y-T.y)*(H.y-T.y)))
		var/mr = 0
		var/tr = 0
		if(H.reagents)
			mr = H.reagents.maximum_volume
			tr = H.reagents.total_volume
		set_pin_data(IC_OUTPUT, 6, mr)
		set_pin_data(IC_OUTPUT, 7, tr)
		set_pin_data(IC_OUTPUT, 8, H.CanPass(assembly ? assembly : src, get_turf(H)))
		set_pin_data(IC_OUTPUT, 9, H.opacity)
		set_pin_data(IC_OUTPUT, 10, get_turf(H))
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/turfpoint
	name = "Tile pointer"
	desc = "This circuit will get a tile ref with the provided absolute coordinates."
	extended_desc = "If the machine	cannot see the target, it will not be able to calculate the correct direction.\
	This circuit only works while inside an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("X" = IC_PINTYPE_NUMBER,"Y" = IC_PINTYPE_NUMBER)
	outputs = list("tile" = IC_PINTYPE_REF)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT,"not calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/turfpoint/do_work()
	if(!assembly)
		activate_pin(3)
		return
	var/turf/T = get_turf(assembly)
	var/target_x = clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
	var/target_y = clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
	var/turf/A = locate(target_x, target_y, T.z)
	set_pin_data(IC_OUTPUT, 1, null)
	if(!A || !(A in view(T)))
		activate_pin(3)
		return
	else
		set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/turfscan
	name = "tile analyzer"
	desc = "This circuit can analyze the contents of the scanned turf, and can read letters on the turf."
	icon_state = "video_camera"
	complexity = 5
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"located refs" 		= IC_PINTYPE_LIST,
		"Written letters" 	= IC_PINTYPE_STRING,
		"area"				= IC_PINTYPE_STRING
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/turfscan/do_work()
	var/turf/scanned_turf = get_pin_data_as_type(IC_INPUT, 1, /turf)
	var/turf/circuit_turf = get_turf(src)
	if(!istype(scanned_turf)) //Invalid input
		activate_pin(3)
		return
	var/area_name = scanned_turf.loc.name
	if(scanned_turf in view(circuit_turf)) // This is a camera. It can't examine things that it can't see.
		var/list/turf_contents = new()
		for(var/obj/U in scanned_turf)
			turf_contents += WEAKREF(U)
		for(var/mob/living/U in scanned_turf)
			turf_contents += WEAKREF(U)
		set_pin_data(IC_OUTPUT, 1, turf_contents)
		set_pin_data(IC_OUTPUT, 3, area_name)
		var/list/St = new()
		for(var/obj/effect/decal/cleanable/blood/writing/I in scanned_turf)
			St.Add(I.message)
		if(St.len)
			set_pin_data(IC_OUTPUT, 2, jointext(St, ",", 1, 0))
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/input/turfpoint
	name = "tile pointer"
	desc = "This circuit will get tile ref with given absolute coorinates."
	extended_desc = "If the machine	cannot see the target, it will not be able to scan it.\
	This circuit will only work in an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("X" = IC_PINTYPE_NUMBER,"Y" = IC_PINTYPE_NUMBER)
	outputs = list("tile" = IC_PINTYPE_REF)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT,"not scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/turfpoint/do_work()
	if(!assembly)
		activate_pin(3)
		return
	var/turf/T = get_turf(assembly)
	var/target_x = clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
	var/target_y = clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
	var/turf/A = locate(target_x, target_y, T.z)
	set_pin_data(IC_OUTPUT, 1, null)
	if(!A || !(A in view(T)))
		activate_pin(3)
		return
	else
		set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/local_locator
	name = "local locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type only locates something \
	that is holding the machine containing it."
	inputs = list()
	outputs = list("located ref"		= IC_PINTYPE_REF,
					"is ground"			= IC_PINTYPE_BOOLEAN,
					"is creature"		= IC_PINTYPE_BOOLEAN)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/local_locator/do_work()
	var/datum/integrated_io/O = outputs[1]
	O.data = null
	if(assembly)
		O.data = WEAKREF(assembly.loc)
	set_pin_data(IC_OUTPUT, 2, isturf(assembly.loc))
	set_pin_data(IC_OUTPUT, 3, ismob(assembly.loc))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/adjacent_locator
	name = "adjacent locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type only locates something \
	that is standing up to a meter away from the machine."
	extended_desc = "The first pin requires a ref to the kind of object that you want the locator to acquire. This means that it will \
	give refs to nearby objects that are similar. If more than one valid object is found nearby, it will choose one of them at \
	random."
	inputs = list("desired type ref" = IC_PINTYPE_REF)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,
		"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/adjacent_locator/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null

	if(!isweakref(I.data))
		return
	var/atom/A = I.data.resolve()
	if(!A)
		return
	var/desired_type = A.type

	var/list/nearby_things = range(1, get_turf(src))
	var/list/valid_things = list()
	for(var/atom/thing in nearby_things)
		if(thing.type != desired_type)
			continue
		valid_things.Add(thing)
	if(valid_things.len)
		O.data = WEAKREF(pick(valid_things))
		activate_pin(2)
	else
		activate_pin(3)
	O.push_data()

/obj/item/integrated_circuit/input/advanced_locator_list
	complexity = 6
	name = "list advanced locator"
	desc = "This is needed for certain devices that demand list of names for a target to act upon. This type locates something \
	that is standing in given radius of up to 8 meters. Output is non-associative. Input will only consider keys if associative."
	extended_desc = "The first pin requires a list of the kinds of objects that you want the locator to acquire. It will locate nearby objects by name and description, \
	and will then provide a list of all found objects which are similar. \
	The second pin is a radius."
	inputs = list("desired type ref" = IC_PINTYPE_LIST, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_LIST)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/advanced_locator_list/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)

	if(isnum_safe(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator_list/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null
	var/list/input_list = list()
	input_list = I.data
	if(length(input_list))	//if there is no input don't do anything.
		var/turf/T = get_turf(src)
		var/list/nearby_things = view(radius,T)
		var/list/valid_things = list()
		for(var/item in input_list)
			if(!isnull(item) && !isnum_safe(item))
				if(istext(item))
					for(var/i in nearby_things)
						var/atom/thing = i
						if(ismob(thing) && !isliving(thing))
							continue
						if(findtext(addtext(thing.name," ",thing.desc), item, 1, 0) )
							valid_things.Add(WEAKREF(thing))
				else
					var/atom/A = item
					var/desired_type = A.type
					for(var/i in nearby_things)
						var/atom/thing = i
						if(thing.type != desired_type)
							continue
						if(ismob(thing) && !isliving(thing))
							continue
						valid_things.Add(WEAKREF(thing))
		if(valid_things.len)
			O.data = valid_things
			O.push_data()
			activate_pin(2)
		else
			O.push_data()
			activate_pin(3)
	else
		O.push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/advanced_locator
	complexity = 6
	name = "advanced locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type locates something \
	that is standing in given radius of up to 8 meters"
	extended_desc = "The first pin requires a ref to the kind of object that you want the locator to acquire. This means that it will \
	give refs to nearby objects which are similar. If this pin is a string, the locator will search for an \
	item matching the desired text in its name and description. If more than one valid object is found nearby, it will choose one of them at \
	random. The second pin is a radius."
	inputs = list("desired type" = IC_PINTYPE_ANY, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1

/obj/item/integrated_circuit/input/advanced_locator/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)
	if(isnum_safe(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator/do_work()
	var/datum/integrated_io/I = inputs[1]
	var/datum/integrated_io/O = outputs[1]
	O.data = null
	var/turf/T = get_turf(src)
	var/list/nearby_things =  view(radius,T)
	var/list/valid_things = list()
	if(isweakref(I.data))
		var/atom/A = I.data.resolve()
		var/desired_type = A.type
		if(desired_type)
			for(var/i in nearby_things)
				var/atom/thing = i
				if(ismob(thing) && !isliving(thing))
					continue
				if(thing.type == desired_type)
					valid_things.Add(thing)
	else if(istext(I.data))
		var/DT = I.data
		for(var/i in nearby_things)
			var/atom/thing = i
			if(ismob(thing) && !isliving(thing))
				continue
			if(findtext(addtext(thing.name," ",thing.desc), DT, 1, 0) )
				valid_things.Add(thing)
	if(valid_things.len)
		O.data = WEAKREF(pick(valid_things))
		O.push_data()
		activate_pin(2)
	else
		O.push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/signaler
	name = "integrated signaler"
	desc = "Signals from a signaler can be received with this, allowing for remote control. It can also send signals."
	extended_desc = "When a signal is received from another signaler, the 'on signal received' activator pin will be pulsed. \
	The two input pins are to configure the integrated signaler's settings. Note that the frequency should not have a decimal in it, \
	meaning the default frequency is expressed as 1457, not 145.7. To send a signal, pulse the 'send signal' activator pin."
	icon_state = "signal"
	complexity = 4
	inputs = list("frequency" = IC_PINTYPE_NUMBER,"code" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list(
		"send signal" = IC_PINTYPE_PULSE_IN,
		"on signal sent" = IC_PINTYPE_PULSE_OUT,
		"on signal received" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	power_draw_idle = 5
	power_draw_per_use = 40
	cooldown_per_use = 5
	var/frequency = 1457
	var/code = 30
	var/datum/radio_frequency/radio_connection
	var/hearing_range = 1

/obj/item/integrated_circuit/input/signaler/Initialize()
	. = ..()
	set_frequency(frequency)
	// Set the pins so when someone sees them, they won't show as null
	set_pin_data(IC_INPUT, 1, frequency)
	set_pin_data(IC_INPUT, 2, code)

/obj/item/integrated_circuit/input/signaler/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/item/integrated_circuit/input/signaler/on_data_written()
	var/new_freq = get_pin_data(IC_INPUT, 1)
	var/new_code = get_pin_data(IC_INPUT, 2)
	if(isnum_safe(new_freq) && new_freq > 0)
		new_freq = clamp(RADIO_LOW_FREQ, new_freq, RADIO_HIGH_FREQ)
		set_frequency(new_freq)
	if(isnum_safe(new_code))
		code = new_code


/obj/item/integrated_circuit/input/signaler/do_work() // Sends a signal.
	if(!radio_connection)
		return

	radio_connection.post_signal(src, create_signal())
	activate_pin(2)

/obj/item/integrated_circuit/input/signaler/proc/create_signal()
	var/datum/signal/signal = new()
	signal.transmission_method = 1
	signal.source = src
	if(isnum(code))
		signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	return signal

/obj/item/integrated_circuit/input/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	// fallball to prevent comms shittification and killing with constant rebuilding of the radio.
	// im not sure why its happenning myself either, the only reason it would be happening is if the target
	// frequency deletes itself for not having any linked devices.(but theres plenty of headsets)
	// The main reason this always stopped engi comms is that byond always initializes one instance of every item
	// then deletes it (i don't know why) at round-start or on world init
	// SPCR 2022
	if(new_frequency > PUBLIC_HIGH_FREQ || new_frequency < PUBLIC_LOW_FREQ)
		frequency = 1461
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)

/obj/item/integrated_circuit/input/signaler/proc/signal_good(datum/signal/signal)
	if(!signal || signal.source == src)
		return FALSE
	if(code)
		var/real_code = 0
		if(isnum_safe(code))
			real_code = code
		var/rec = 0
		if(signal.encryption)
			rec = signal.encryption
		if(real_code != rec)
			return FALSE
	return TRUE

/obj/item/integrated_circuit/input/signaler/receive_signal(datum/signal/signal)
	if(!signal_good(signal))
		return FALSE

	activate_pin(3)
	for(var/CHM in hearers(hearing_range, src))
		if(ismob(CHM))
			var/mob/LM = CHM
			LM.playsound_local(get_turf(src), 'sound/machines/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)

/obj/item/integrated_circuit/input/signaler/advanced
	name = "advanced integrated signaler"
	icon_state = "signal_advanced"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler with the right id tag, the 'on signal received' activator pin will be pulsed and the command output is updated.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin. Set the command output to set the message received."
	complexity = 8
	inputs = list("frequency" = IC_PINTYPE_NUMBER, "id tag" = IC_PINTYPE_STRING, "command" = IC_PINTYPE_STRING)
	outputs = list("received command" = IC_PINTYPE_STRING)
	var/command
	code = "Integrated_Circuits"

/obj/item/integrated_circuit/input/signaler/advanced/on_data_written()
	..()
	code = get_pin_data(IC_INPUT, 2)
	command = get_pin_data(IC_INPUT, 3)

/obj/item/integrated_circuit/input/signaler/advanced/signal_good(datum/signal/signal)
	if(!..() || signal.data["tag"] != code)
		return FALSE
	return TRUE

/obj/item/integrated_circuit/input/signaler/advanced/create_signal()
	var/datum/signal/signal = new()
	signal.transmission_method = 1
	signal.data["tag"] = code
	signal.data["command"] = command
	signal.encryption = 0
	return signal

/obj/item/integrated_circuit/input/signaler/advanced/receive_signal(datum/signal/signal)
	if(signal_good(signal))
		set_pin_data(IC_OUTPUT,1, signal.data["command"])
		push_data()
		..()

/obj/item/integrated_circuit/input/teleporter_locator
	name = "teleporter locator"
	desc = "This circuit can locate and allow for selection of teleporter computers."
	icon_state = "gps"
	complexity = 5
	can_be_asked_input = TRUE
	inputs = list()
	outputs = list("teleporter" = IC_PINTYPE_REF)
	activators = list("on selected" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE
	radial_menu_icon = "teleporter_locator"

/obj/item/integrated_circuit/input/teleporter_locator/Initialize()
	. = ..()
	set_pin_data(IC_OUTPUT, 1, WEAKREF(null))

/obj/item/integrated_circuit/input/teleporter_locator/ask_for_input(mob/user)
	var/list/teleporters_id = list()
	var/list/teleporters = list()
	for(var/obj/machinery/teleport/hub/R in SSmachines.processing)
		var/obj/machinery/computer/teleporter/com = R.mconsole
		if(istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use && com.operable())
			teleporters_id.Add(com.id)
			teleporters[com.id] = com

	var/obj/machinery/computer/teleporter/selected_console
	var/selected_id = input("Please select a teleporter to lock in. Do not select anything for random", "Teleport Selector") as null|anything in teleporters_id
	if(isnull(selected_id))
		selected_console = null
	else
		selected_console = teleporters[selected_id]
	set_pin_data(IC_OUTPUT, 1, selected_console && WEAKREF(selected_console))
	push_data()
	activate_pin(1)

/obj/item/integrated_circuit/input/teleporter_locator/any_examine(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/obj/machinery/computer/teleporter/current_console = O.data_as_type(/obj/machinery/computer/teleporter)

	var/output = "Current selection: [(current_console && current_console.id) || "None"]"
	output += "\nList of avaliable teleporters:"
	for(var/obj/machinery/teleport/hub/R in SSmachines.processing)
		var/obj/machinery/computer/teleporter/com = R.mconsole
		if(istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use && com.operable())
			output += "\n[com.id] ([R.icon_state == "tele1" ? "Active" : "Inactive"])"
	to_chat(user, output)

/obj/item/integrated_circuit/input/teleporter_locator/get_topic_data(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/obj/machinery/computer/teleporter/current_console = O.data_as_type(/obj/machinery/computer/teleporter)

	. = list()
	. += "Current selection: [(current_console && current_console.id) || "None"]"
	. += "Please select a teleporter to lock in on:"
	for(var/obj/machinery/teleport/hub/R in world)
		var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
		if (istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use)
			.["[com.id] ([R.icon_state == "tele1" ? "Active" : "Inactive"])"] = "tport=[any2ref(com)]"
	.["None (Dangerous)"] = "tport=random"

/obj/item/integrated_circuit/input/teleporter_locator/OnICTopic(href_list, mob/user)
	if(href_list["tport"] && user.IsAdvancedToolUser())
		var/output = href_list["tport"] == "random" ? null : locate(href_list["tport"])
		set_pin_data(IC_OUTPUT, 1, output && WEAKREF(output))
		push_data()
		activate_pin(1)
		return IC_TOPIC_REFRESH

// TODO: refactor ntnet circuit to OnyxBay code and add items using this stuff (ex. modular_computer, airlock)

//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/input/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	extended_desc = "The coordinates that the GPS outputs are absolute, not relative. The full coords output has the coords separated by commas and is in string format."
	icon_state = "gps"
	complexity = 4
	inputs = list()
	outputs = list("X"= IC_PINTYPE_NUMBER, "Y" = IC_PINTYPE_NUMBER, "Z" = IC_PINTYPE_NUMBER, "full coords" = IC_PINTYPE_STRING)
	activators = list("get coordinates" = IC_PINTYPE_PULSE_IN, "on get coordinates" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/gps/do_work()
	var/turf/T = get_turf(src)

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, null)
	if(!T)
		return

	set_pin_data(IC_OUTPUT, 1, T.x)
	set_pin_data(IC_OUTPUT, 2, T.y)
	set_pin_data(IC_OUTPUT, 3, T.z)
	set_pin_data(IC_OUTPUT, 4, "[T.x],[T.y],[T.z]")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people, or for voice-activated machines."
	extended_desc = "This will automatically translate most languages it hears to Zurich Accord Common. \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Zurich Accord Common."
	//icon_state = "recorder" TODO: make sprite for this icon_state.
	complexity = 8
	inputs = list()
	flags = CONDUCT
	outputs = list(
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/microphone/Initialize()
	. = ..()
	add_hearing()

/obj/item/integrated_circuit/input/microphone/Destroy()
	remove_hearing()
	. = ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(mob/living/M, msg, var/verb="says", datum/language/speaking=null, speech_volume)
	var/translated = FALSE
	if(M && msg)
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			if(!istype(speaking, /datum/language/common))
				translated = TRUE
		set_pin_data(IC_OUTPUT, 1, M.GetVoice())
		set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)
	if(translated)
		activate_pin(2)

/obj/item/integrated_circuit/input/sensor
	name = "sensor"
	desc = "Scans and obtains a reference for any objects or persons near you. All you need to do is shove the machine in their face."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	//icon_state = "recorder"
	complexity = 12
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/input/sensor/sense(atom/A, mob/user, prox)
	if(!prox || !A || (ismob(A) && !isliving(A)))
		return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags && istype(A, /obj/item/storage))
		return FALSE
	set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	to_chat(user, SPAN("notice", "You scan [A] with [assembly]."))
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/sensor/ranged
	name = "ranged sensor"
	desc = "Scans and obtains a reference for any objects or persons in range. All you need to do is point the machine towards the target."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	//icon_state = "recorder"
	complexity = 36
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/input/sensor/ranged/sense(atom/A, mob/user)
	if(!user || !A || (ismob(A) && !isliving(A)))
		return FALSE
	if(user.client && A != user)
		if(!(A in view(user.client)))
			return FALSE
	else
		if(!(A in view(user)))
			return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags && istype(A, /obj/item/storage))
		return FALSE
	set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	to_chat(user, SPAN("notice", "You scan [A] with [assembly]."))
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/obj_scanner
	name = "scanner"
	desc = "Scans and obtains a reference for any objects you use on the assembly."
	extended_desc = "If the 'put down' pin is set to true, the assembly will take the scanned object from your hands to its location. \
	Useful for interaction with the grabber. The scanner only works using the help intent."
	//icon_state = "recorder"
	complexity = 4
	inputs = list("put down" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/obj_scanner/attackby_react(atom/A, mob/user, intent)
	if(intent != I_HELP)
		return FALSE
	if(!check_then_do_work())
		return FALSE
	var/pu = get_pin_data(IC_INPUT, 1)
	if(pu && !user.unEquip(A,get_turf(src)))
		return FALSE
	if(pu)
		user.drop_item(A)
	set_pin_data(IC_OUTPUT, 1, WEAKREF(A))
	push_data()
	to_chat(user, SPAN("notice", "You let [assembly] scan [A]."))
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/internalbm
	name = "internal battery monitor"
	desc = "This monitors the charge level of an internal battery."
	icon_state = "internalbm"
	extended_desc = "This circuit will give you the values of charge, max charge, and the current percentage of the internal battery on demand."
	w_class = ITEM_SIZE_TINY
	complexity = 1
	inputs = list()
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER,
		"refference to assembly" = IC_PINTYPE_REF,
		"refference to cell" = IC_PINTYPE_REF
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/internalbm/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, null)
	set_pin_data(IC_OUTPUT, 5, null)
	if(assembly)
		set_pin_data(IC_OUTPUT, 4, WEAKREF(assembly))
		if(assembly.battery)
			set_pin_data(IC_OUTPUT, 1, assembly.battery.charge)
			set_pin_data(IC_OUTPUT, 2, assembly.battery.maxcharge)
			set_pin_data(IC_OUTPUT, 3, 100*assembly.battery.charge/assembly.battery.maxcharge)
			set_pin_data(IC_OUTPUT, 5, WEAKREF(assembly.battery))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/externalbm
	name = "external battery monitor"
	desc = "This can read the battery state of any device in view."
	icon_state = "externalbm"
	extended_desc = "This circuit will give you the charge, max charge, and the current percentage values of any device or battery in view."
	w_class = ITEM_SIZE_TINY
	complexity = 2
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1

/obj/item/integrated_circuit/input/externalbm/do_work()

	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	if(AM)
		var/list/power_cell_list = get_power_cell(AM)
		var/obj/item/cell/small/C = power_cell_list[1]
		if(istype(C))
			var/turf/A = get_turf(src)
			if(get_turf(AM) in view(A))
				set_pin_data(IC_OUTPUT, 1, C.charge)
				set_pin_data(IC_OUTPUT, 2, C.maxcharge)
				set_pin_data(IC_OUTPUT, 3, C.percent())
	push_data()
	activate_pin(2)
	return

// TODO: port ntnetsc from TG
/obj/item/integrated_circuit/input/matscan
	name = "material scanner"
	desc = "This special module is designed to get information about material containers of different machinery, \
			like ORM, lathes, etc."
	icon_state = "video_camera"
	complexity = 6
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		MATERIAL_STEEL				 	= IC_PINTYPE_NUMBER,
		MATERIAL_GLASS					= IC_PINTYPE_NUMBER,
		MATERIAL_SILVER					= IC_PINTYPE_NUMBER,
		MATERIAL_GOLD					= IC_PINTYPE_NUMBER,
		MATERIAL_DIAMOND				= IC_PINTYPE_NUMBER,
		MATERIAL_PLASMA					= IC_PINTYPE_NUMBER,
		MATERIAL_URANIUM				= IC_PINTYPE_NUMBER,
		MATERIAL_PLASTEEL				= IC_PINTYPE_NUMBER,
		MATERIAL_TITANIUM				= IC_PINTYPE_NUMBER,
		MATERIAL_GLASS					= IC_PINTYPE_NUMBER,
		MATERIAL_PLASTIC				= IC_PINTYPE_NUMBER,
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	var/list/mtypes = list(MATERIAL_STEEL, MATERIAL_GLASS, MATERIAL_SILVER, MATERIAL_GOLD, MATERIAL_DIAMOND, MATERIAL_PLASMA, MATERIAL_URANIUM, MATERIAL_PLASTEEL, MATERIAL_TITANIUM, MATERIAL_GLASS, MATERIAL_PLASTIC)

/obj/item/integrated_circuit/input/matscan/do_work()
	var/obj/O = get_pin_data_as_type(IC_INPUT, 1, /obj)
	if(!O || !O.matter) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(O in view(T)) // This is a camera. It can't examine thngs,that it can't see.
		for(var/I in 1 to mtypes.len)
			var/amount = O.matter[mtypes[I]]
			if(amount)
				set_pin_data(IC_OUTPUT, I, amount)
			else
				set_pin_data(IC_OUTPUT, I, null)
		push_data()
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/input/data_card_reader
	name = "data card reader"
	desc = "A circuit that can read from and write to data cards."
	extended_desc = "Setting the \"write mode\" boolean to true will cause any data cards that are used on the assembly to replace\
 their existing function and data strings with the given strings, if it is set to false then using a data card on the assembly will cause\
 the function and data strings stored on the card to be written to the output pins."
	icon_state = "card_reader"
	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"function" = IC_PINTYPE_STRING,
		"data to store" = IC_PINTYPE_STRING,
		"write mode" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"function" = IC_PINTYPE_STRING,
		"stored data" = IC_PINTYPE_STRING
	)
	activators = list(
		"on write" = IC_PINTYPE_PULSE_OUT,
		"on read" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/input/data_card_reader/attackby_react(obj/item/I, mob/living/user, intent)
	var/obj/item/card/data/card = I
	var/write_mode = get_pin_data(IC_INPUT, 3)
	if(istype(card))
		if(write_mode == TRUE)
			card.function = get_pin_data(IC_INPUT, 1)
			card.data = get_pin_data(IC_INPUT, 2)
			push_data()
			activate_pin(1)
		else
			set_pin_data(IC_OUTPUT, 1, card.function)
			set_pin_data(IC_OUTPUT, 2, card.data)
			push_data()
			activate_pin(2)
	else
		return FALSE
	return TRUE


// -Inputlist- //
/obj/item/integrated_circuit/input/selection
	name = "selection circuit"
	desc = "This circuit lets you choose between different strings from a selection."
	extended_desc = "This circuit lets you choose between up to 4 different values from selection of up to 8 strings that you can set. Null values are ignored and the chosen value is put out in selected."
	icon_state = "addition"
	can_be_asked_input = TRUE
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"A" = IC_PINTYPE_STRING,
		"B" = IC_PINTYPE_STRING,
		"C" = IC_PINTYPE_STRING,
		"D" = IC_PINTYPE_STRING,
		"E" = IC_PINTYPE_STRING,
		"F" = IC_PINTYPE_STRING,
		"G" = IC_PINTYPE_STRING,
		"H" = IC_PINTYPE_STRING
	)
	activators = list(
		"on selected" = IC_PINTYPE_PULSE_OUT
	)
	outputs = list(
		"selected" = IC_PINTYPE_STRING
	)
	var/input_selected = FALSE
	var/selected_value = "None"
	radial_menu_icon = "textpad"

/obj/item/integrated_circuit/input/selection/ask_for_input(mob/user)
	var/list/selection = list()
	for(var/k in 1 to inputs.len)
		var/I = get_pin_data(IC_INPUT, k)
		if(istext(I))
			selection.Add(I)
	var/selected = input(user,"Choose input.","Selection") in selection
	if(!selected)
		input_selected = FALSE
		return
	input_selected = selected
	set_pin_data(IC_OUTPUT, 1, selected)
	push_data()
	activate_pin(1)

/obj/item/integrated_circuit/input/selection/get_topic_data(mob/user)
	. = list()
	. += "Last Selected: [selected_value]"
	. += "Please select string:"
	for(var/k in 1 to inputs.len)
		var/I = get_pin_data(IC_INPUT, k)
		if(istext(I))
			.["[I]"] = "select=[I]"

/obj/item/integrated_circuit/input/selection/OnICTopic(href_list, mob/user)
	if(href_list["select"] && user.IsAdvancedToolUser())
		var/selected = sanitize(href_list["select"])
		if(selected)
			selected_value = selected
			set_pin_data(IC_OUTPUT, 1, selected)
			push_data()
			activate_pin(1)
		return IC_TOPIC_REFRESH

// -storage examiner- // **works**
/obj/item/integrated_circuit/input/storage_examiner
	name = "storage examiner circuit"
	desc = "This circuit lets you scan a storage's content. (backpacks, toolboxes etc.)"
	extended_desc = "The items are put out as reference, which makes it possible to interact with them. Additionally also gives the amount of items."
	icon_state = "grabber"
	can_be_asked_input = TRUE
	complexity = 6
	spawn_flags = IC_SPAWN_DEFAULT | IC_SPAWN_RESEARCH
	inputs = list(
		"storage" = IC_PINTYPE_REF
	)
	activators = list(
		"examine" = IC_PINTYPE_PULSE_IN,
		"on examined" = IC_PINTYPE_PULSE_OUT
	)
	outputs = list(
		"item amount" = IC_PINTYPE_NUMBER,
		"item list" = IC_PINTYPE_LIST
	)
	power_draw_per_use = 85

/obj/item/integrated_circuit/input/storage_examiner/do_work()
	var/obj/item/storage/storage = get_pin_data_as_type(IC_INPUT, 1, /obj/item/storage)
	if(!istype(storage, /obj/item/storage))
		return

	var/list/inv = storage.return_inv()
	set_pin_data(IC_OUTPUT, 1, inv.len)

	var/list/regurgitated_contents = list()
	for(var/obj/O in inv)
		regurgitated_contents.Add(WEAKREF(O))


	set_pin_data(IC_OUTPUT, 2, regurgitated_contents)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser. This allows the machine to track some vital signs."
	icon_state = "medscan"
	complexity = 4
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"brain activity" = IC_PINTYPE_BOOLEAN,
		"pulse" = IC_PINTYPE_NUMBER,
		"is conscious" = IC_PINTYPE_BOOLEAN
		)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return
	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		var/obj/item/organ/internal/brain/brain = H.random_organ_by_process(BP_BRAIN)
		set_pin_data(IC_OUTPUT, 1, (brain && H.stat != DEAD))
		set_pin_data(IC_OUTPUT, 2, H.pulse())
		set_pin_data(IC_OUTPUT, 3, (H.stat == 0))

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/adv_med_scanner
	name = "integrated adv. medical analyser"
	desc = "A very small version of the medbot's medical analyser. This allows the machine to know how healthy someone is. \
	This type is much more precise, allowing the machine to know much more about the target than a normal analyzer."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"brain activity"		= IC_PINTYPE_BOOLEAN,
		"is conscious"	        = IC_PINTYPE_BOOLEAN,
		"brute damage"			= IC_PINTYPE_NUMBER,
		"burn damage"			= IC_PINTYPE_NUMBER,
		"tox damage"			= IC_PINTYPE_NUMBER,
		"oxy damage"			= IC_PINTYPE_NUMBER,
		"clone damage"			= IC_PINTYPE_NUMBER,
		"pulse"                 = IC_PINTYPE_NUMBER,
		"oxygenation level"     = IC_PINTYPE_NUMBER,
		"radiation"             = IC_PINTYPE_NUMBER,
		"name"                  = IC_PINTYPE_STRING,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/adv_med_scanner/proc/damage_to_severity(value)
	if(value < 1)
		return 0
	if(value < 25)
		return 1
	if(value < 50)
		return 2
	if(value < 75)
		return 3
	if(value < 100)
		return 4
	return 5

/obj/item/integrated_circuit/input/adv_med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return
	if(H in view(get_turf(src))) // Like medbot's analyzer it can be used in range..
		var/obj/item/organ/internal/brain/brain = H.random_organ_by_process(BP_BRAIN)
		set_pin_data(IC_OUTPUT, 1, (brain && H.stat != DEAD))
		set_pin_data(IC_OUTPUT, 2, (H.stat == 0))
		set_pin_data(IC_OUTPUT, 3, damage_to_severity(100 * H.getBruteLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 4, damage_to_severity(100 * H.getFireLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 5, damage_to_severity(100 * H.getToxLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 6, damage_to_severity(100 * H.getOxyLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 7, damage_to_severity(100 * H.getCloneLoss() / H.maxHealth))
		set_pin_data(IC_OUTPUT, 8, H.pulse())
		set_pin_data(IC_OUTPUT, 9, H.get_blood_oxygenation())
		set_pin_data(IC_OUTPUT, 10, H.radiation)
		set_pin_data(IC_OUTPUT, 11, H.name)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/atmospheric_analyzer
	name = "atmospheric analyzer"
	desc = "A miniaturized analyzer which can scan anything that contains gases. Leave target as NULL to scan the air around the assembly."
	extended_desc = "The nth element of gas amounts is the number of moles of the \
					nth gas in gas list. \
					Pressure is in kPa, temperature is in Kelvin. \
					Due to programming limitations, scanning an object that does \
					not contain a gas will return the air around it instead."
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
			"target" = IC_PINTYPE_REF
			)
	outputs = list(
			"gas list" = IC_PINTYPE_LIST,
			"gas amounts" = IC_PINTYPE_LIST,
			"total moles" = IC_PINTYPE_NUMBER,
			"pressure" = IC_PINTYPE_NUMBER,
			"temperature" = IC_PINTYPE_NUMBER,
			"volume" = IC_PINTYPE_NUMBER
			)
	activators = list(
			"scan" = IC_PINTYPE_PULSE_IN,
			"on success" = IC_PINTYPE_PULSE_OUT,
			"on failure" = IC_PINTYPE_PULSE_OUT
			)
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/atmospheric_analyzer/do_work()
	for(var/i=1 to 6)
		set_pin_data(IC_OUTPUT, i, null)
	var/atom/target = get_pin_data_as_type(IC_INPUT, 1, /atom)
	if(!target)
		target = get_turf(src)
	if( get_dist(get_turf(target),get_turf(src)) > 1 )
		activate_pin(3)
		return

	var/datum/gas_mixture/air_contents = target.return_air()
	if(!air_contents)
		activate_pin(3)
		return

	var/list/gases = air_contents.gas
	var/list/gas_names = list()
	var/list/gas_amounts = list()
	for(var/id in gases)
		var/name = gas_data.name[id]
		var/amt = round(gases[id], 0.001)
		gas_names.Add(name)
		gas_amounts.Add(amt)

	set_pin_data(IC_OUTPUT, 1, gas_names)
	set_pin_data(IC_OUTPUT, 2, gas_amounts)
	set_pin_data(IC_OUTPUT, 3, round(air_contents.get_total_moles(), 0.001))
	set_pin_data(IC_OUTPUT, 4, round(air_contents.return_pressure(), 0.001))
	set_pin_data(IC_OUTPUT, 5, round(air_contents.temperature, 0.001))
	set_pin_data(IC_OUTPUT, 6, round(air_contents.volume, 0.001))
	push_data()
	activate_pin(2)
