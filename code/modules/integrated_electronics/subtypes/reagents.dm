#define IC_SMOKE_REAGENTS_MINIMUM_UNITS 10
#define IC_REAGENTS_DRAW 0
#define IC_REAGENTS_INJECT 1
#define IC_SPLASH_MAX 3

/obj/item/integrated_circuit/reagent
	category_text = "Reagent"
	unacidable = 1
	cooldown_per_use = 10
	var/volume = 0

/obj/item/integrated_circuit/reagent/Initialize()
	. = ..()
	if(volume)
		create_reagents(volume)
		push_vol()

/obj/item/integrated_circuit/reagent/proc/push_vol()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()


/obj/item/integrated_circuit/reagent/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command. It can also hold liquids inside, which will go \
	into the smoke clouds when activated. The reagents are consumed when the smoke is made."
	ext_cooldown = 1
	reagent_flags = OPENCONTAINER
	volume = 100

	complexity = 20
	cooldown_per_use = 1 SECONDS
	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"create smoke" = IC_PINTYPE_PULSE_IN,
		"on smoked" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20
	var/smoke_radius = 5
	var/notified = FALSE

/obj/item/integrated_circuit/reagent/smoke/on_reagent_change()
	push_vol()

/obj/item/integrated_circuit/reagent/smoke/do_work()
	if(!reagents || (reagents.total_volume < IC_SMOKE_REAGENTS_MINIMUM_UNITS))
		return
	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		var/list/reagent_names_list = list()
		for(var/datum/reagent/R in reagents?.reagent_list)
			reagent_names_list.Add(R.name)
		var/atom/AM = get_object()
		AM.investigate_log("smokes these reagents: [jointext(reagent_names_list, ", ")] with [src].", INVESTIGATE_CIRCUIT)
		S.set_up(reagents, smoke_radius, 0, location)
		if(!notified)
			notified = TRUE
		S.start()
	reagents.clear_reagents()
	activate_pin(2)

/obj/item/integrated_circuit/reagent/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into, or suck liquids out of, whatever it's pointed at."
	icon_state = "injector"
	extended_desc = "This autoinjector can push up to 30 units of reagents into another container or someone else outside of the machine. The target \
	must be adjacent to the machine, and if it is a person, they cannot be wearing thick clothing. Negative given amounts makes the injector suck out reagents instead."

	reagent_flags = OPENCONTAINER
	volume = 30

	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"injection amount" = IC_PINTYPE_NUMBER
		)
	inputs_default = list(
		"2" = 5
		)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"inject" = IC_PINTYPE_PULSE_IN,
		"on injected" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	var/direction_mode = IC_REAGENTS_INJECT
	var/transfer_amount = 10
	var/busy = FALSE

/obj/item/integrated_circuit/reagent/injector/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/injector/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 2)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = IC_REAGENTS_DRAW
	else
		direction_mode = IC_REAGENTS_INJECT
	if(isnum_safe(new_amount))
		new_amount = clamp(new_amount, 0, volume)
		transfer_amount = new_amount


/obj/item/integrated_circuit/reagent/injector/do_work()
	inject()

/obj/item/integrated_circuit/reagent/injector/proc/target_nearby(datum/weakref/target)
	var/mob/living/L = target.resolve()
	if(!L || get_dist(src,L) > 1)
		return
	return L

/obj/item/integrated_circuit/reagent/injector/proc/inject_check(atom/movable/target)
	if(!target.Adjacent(get_turf(src)))
		return FALSE

	if(!target.is_injectable(allowmobs = TRUE))
		return FALSE

	if(!target.reagents.get_free_space())
		return FALSE

	return TRUE

/obj/item/integrated_circuit/reagent/injector/proc/inject_after(datum/weakref/target)
	busy = FALSE
	var/mob/living/L = target_nearby(target)
	if(!L)
		activate_pin(3)
		return
	if(!inject_check(L))
		return
	var/atom/movable/acting_object = get_object()
	log_admin("[key_name(L)] was successfully injected with " + reagents.get_reagents() + " by \the [acting_object]")
	L.visible_message("<span class='warning'>\The [acting_object] injects [L] with its needle!</span>", \
					"<span class='warning'>\The [acting_object] injects you with its needle!</span>")
	reagents.trans_to_mob(L, transfer_amount, CHEM_BLOOD)
	activate_pin(2)

/obj/item/integrated_circuit/reagent/injector/proc/draw_after(datum/weakref/target, amount)
	busy = FALSE
	var/mob/living/carbon/C = target_nearby(target)
	if(!C)
		activate_pin(3)
		return
	var/atom/movable/acting_object = get_object()

	C.visible_message("<span class='warning'>\The [acting_object] draws blood from \the [C]</span>",
					"<span class='warning'>\The [acting_object] draws blood from you.</span>"
					)
	C.take_blood(src, amount)
	activate_pin(2)

/obj/item/integrated_circuit/reagent/injector/proc/inject()
	set waitfor = FALSE // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/acting_object = get_object()

	var/list/reagent_names_list = list()
	for(var/datum/reagent/R in reagents?.reagent_list)
		reagent_names_list.Add(R.name)

	if(busy || !check_target(AM))
		activate_pin(3)
		return

	if(!AM.reagents)
		activate_pin(3)
		return

	if(direction_mode == IC_REAGENTS_INJECT)
		if(!reagents.total_volume || !AM.reagents || !AM.reagents.get_free_space())
			activate_pin(3)
			return

		if(isliving(AM) && inject_check(AM))
			var/mob/living/L = AM
			if(!L.can_inject(null, 0))
				activate_pin(3)
				return
			var/injection_status = L.can_inject(null, BP_CHEST)
			// admin logging stuff
			log_admin("[key_name(L)] is getting injected with " + reagents.get_reagents() + " by \the [acting_object]")
			L.visible_message(SPAN("danger", "[acting_object] is trying to inject [L]!"), \
								SPAN("danger", "[acting_object] is trying to inject you!"))
			busy = TRUE
			addtimer(CALLBACK(src, .proc/inject_after, WEAKREF(L)), injection_status * 3 SECONDS)
			return
		else
			if(!AM.is_open_container())
				activate_pin(3)
				return


			reagents.trans_to(AM, transfer_amount)

	if(direction_mode == IC_REAGENTS_DRAW)
		if(reagents.total_volume >= reagents.maximum_volume)
			acting_object.visible_message("[acting_object] tries to draw from [AM], but the injector is full.")
			activate_pin(3)
			return

		var/tramount = abs(transfer_amount)

		if(istype(AM, /mob/living/carbon))
			var/mob/living/carbon/C = AM
			var/injection_status = C.can_inject(null, BP_CHEST)
			if(istype(C, /mob/living/carbon/slime) || !C.b_type || !injection_status)
				activate_pin(3)
				return
			C.visible_message(SPAN("danger", "[acting_object] takes a blood sample from [C]!"), \
			SPAN("danger", "[acting_object] takes a blood sample from you!"))
			busy = TRUE
			addtimer(CALLBACK(src, .proc/draw_after, WEAKREF(C), tramount), injection_status * 3 SECONDS)
			return

		else
			if(!AM.reagents.total_volume)
				acting_object.visible_message(SPAN("notice", "[acting_object] tries to draw from [AM], but it is empty!"))
				activate_pin(3)
				return

			if(!AM.is_open_container())
				activate_pin(3)
				return
			tramount = min(tramount, AM.reagents.total_volume)
			AM.reagents.trans_to(src, tramount)
	acting_object.investigate_log("injected reagents: [jointext(reagent_names_list, ", ")] with [src].", INVESTIGATE_CIRCUIT)
	activate_pin(2)



/obj/item/integrated_circuit/reagent/pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump which will move liquids from the source ref to the target ref. The third pin determines \
	how much liquid is moved per pulse, between 0 and 50. The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is adjacent to the machine."

	complexity = 8
	inputs = list("source" = IC_PINTYPE_REF, "target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER)
	inputs_default = list("3" = 5)
	outputs = list()
	activators = list("transfer reagents" = IC_PINTYPE_PULSE_IN, "on transfer" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/transfer_amount = 10
	var/direction_mode = IC_REAGENTS_INJECT
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/pump/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = IC_REAGENTS_DRAW
	else
		direction_mode = IC_REAGENTS_INJECT
	if(isnum_safe(new_amount))
		new_amount = clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/pump/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)

	// Check for invalid input.
	if(!check_target(source) || !check_target(target))
		return

	// If the pump is pumping backwards, swap target and source.
	if(!direction_mode)
		var/temp_source = source
		source = target
		target = temp_source

	if(!source.reagents)
		return

	if(!target.reagents)
		return

	if(!source.is_open_container())
		return

	var/list/reagent_names_list = list()
	for(var/datum/reagent/R in source?.reagents?.reagent_list)
		reagent_names_list.Add(R.name)
	var/atom/AM = get_object()
	AM.investigate_log("transfer reagents: [jointext(reagent_names_list, ", ")] from [source] to [target] with [src].", INVESTIGATE_CIRCUIT)

	source.reagents.trans_to(target, transfer_amount)
	activate_pin(2)

/obj/item/integrated_circuit/reagent/storage
	cooldown_per_use = 1
	name = "reagent storage"
	desc = "Stores liquid inside the device away from electrical components. It can store up to 60u."
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal beaker."

	reagent_flags = OPENCONTAINER
	volume = 60

	complexity = 4
	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list("push ref" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH



/obj/item/integrated_circuit/reagent/storage/do_work()
	set_pin_data(IC_OUTPUT, 2, WEAKREF(src))
	push_data()

/obj/item/integrated_circuit/reagent/storage/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/storage/big
	name = "big reagent storage"
	icon_state = "reagent_storage_big"
	desc = "Stores liquid inside the device away from electrical components. Can store up to 180u."

	volume = 180

	complexity = 16
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside the device away from electrical components. It can store up to 60u. This will also prevent reactions."
	icon_state = "reagent_storage_cryo"
	extended_desc = "This is effectively an internal cryo beaker."

	reagent_flags = OPENCONTAINER | NO_REACT
	complexity = 8
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/storage/grinder
	name = "reagent grinder"
	desc = "This is a reagent grinder. It accepts a ref to something, and refines it into reagents. It can store up to 100u."
	icon_state = "blender"
	extended_desc = ""
	inputs = list(
		"target" = IC_PINTYPE_REF,
		)
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"grind" = IC_PINTYPE_PULSE_IN,
		"on grind" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	volume = 100
	power_draw_per_use = 150
	complexity = 16
	spawn_flags = IC_SPAWN_RESEARCH


/obj/item/integrated_circuit/reagent/storage/grinder/do_work()
	grind()

/obj/item/integrated_circuit/reagent/storage/grinder/proc/grind()
	if(reagents.total_volume >= reagents.maximum_volume)
		activate_pin(3)
		return FALSE
	var/obj/item/I = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(istype(I) && (I.reagents.total_volume) && check_target(I))
		var/list/reagent_names_list = list()
		for(var/datum/reagent/R in reagents?.reagent_list)
			reagent_names_list.Add(R.name)
		var/atom/AM = get_object()
		AM.investigate_log("grinded reagents: [jointext(reagent_names_list, ", ")] with [src].", INVESTIGATE_CIRCUIT)
		I.reagents.trans_to(src,I.reagents.total_volume)
		qdel(I)
		activate_pin(2)
		return TRUE
	activate_pin(3)
	return FALSE



/obj/item/integrated_circuit/reagent/storage/scan
	name = "reagent scanner"
	desc = "Stores liquid inside the device away from electrical components. It can store up to 60u. On pulse this beaker will send list of contained reagents."
	icon_state = "reagent_scan"
	extended_desc = "Mostly useful for filtering reagents."

	complexity = 8
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF,
		"list of reagents" = IC_PINTYPE_LIST
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/reagent/storage/scan/do_work(ord)
	var/list/cont = list()
	for(var/datum/reagent/RE in reagents?.reagent_list)
		cont += RE.name
	var/atom/AM = get_object()
	AM.investigate_log("scanned reagents: [jointext(cont, ", ")] with [src].", INVESTIGATE_CIRCUIT)
	set_pin_data(IC_OUTPUT, 3, cont)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/reagent/filter
	name = "reagent filter"
	desc = "Filters liquids by list of desired or unwanted reagents."
	icon_state = "reagent_filter"
	extended_desc = "This is a filter which will move liquids from the source to its target. \
	If the amount in the fourth pin is positive, it will move all reagents except those in the unwanted list. \
	If the amount in the fourth pin is negative, it will only move the reagents in the wanted list. \
	The third pin determines how many reagents are moved per pulse, between 0 and 50. Amount is given for each separate reagent."

	complexity = 8
	inputs = list(
		"source" = IC_PINTYPE_REF,
		"target" = IC_PINTYPE_REF,
		"injection amount" = IC_PINTYPE_NUMBER,
		"list of reagents" = IC_PINTYPE_LIST
		)
	inputs_default = list(
		"3" = 5
		)
	outputs = list()
	activators = list(
		"transfer reagents" = IC_PINTYPE_PULSE_IN,
		"on transfer" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/transfer_amount = 10
	var/direction_mode = IC_REAGENTS_INJECT
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/filter/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direction_mode = IC_REAGENTS_DRAW
	else
		direction_mode = IC_REAGENTS_INJECT
	if(isnum_safe(new_amount))
		new_amount = clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/filter/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	var/list/demand = get_pin_data(IC_INPUT, 4)

	// Check for invalid input.
	if(!check_target(source) || !check_target(target))
		return

	if(!source.reagents || !target.reagents)
		return

	// FALSE in those procs makes mobs invalid targets.
	if(!source.is_open_container(FALSE) || istype(source, /mob))
		return

	if(target.reagents.maximum_volume - target.reagents.total_volume <= 0)
		return

	var/atom/AM = get_object()
	for(var/datum/reagent/G in source.reagents?.reagent_list)
		if(!direction_mode)
			if(G.name in demand)
				AM.investigate_log("transfered [G.id] to [target], amount [transfer_amount] with [src]", INVESTIGATE_CIRCUIT)
				source.reagents.trans_id_to(target, G.id, transfer_amount)
		else
			if(!(G.name in demand))
				AM.investigate_log("transfered [G.id] to [target], amount [transfer_amount] with [src]", INVESTIGATE_CIRCUIT)
				source.reagents.trans_id_to(target, G.id, transfer_amount)
	activate_pin(2)
	push_data()

// This is an input circuit because attackby_react is only called for input circuits
/obj/item/integrated_circuit/input/funnel
	category_text = "Reagent"
	name = "reagent funnel"
	desc = "A funnel with a small pump that lets you refill an internal reagent storage."
	icon_state = "reagent_funnel"

	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	activators = list(
		"on transfer" = IC_PINTYPE_PULSE_OUT
	)

	unacidable = 1
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	complexity = 4
	power_draw_per_use = 5

/obj/item/integrated_circuit/input/funnel/attackby_react(obj/item/I, mob/living/user, intent)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/obj/item/reagent_containers/container = I

	if(!check_target(target) || !istype(container))
		return FALSE

	// Messages are provided by standard_pour_into
	if(container.standard_pour_into(user, target))
		activate_pin(1)
		return TRUE

	return FALSE

// - Integrated extinguisher - //
/obj/item/integrated_circuit/reagent/extinguisher
	name = "integrated extinguisher"
	desc = "This circuit sprays any of its contents out like an extinguisher."
	icon_state = "injector"
	extended_desc = "This circuit can hold up to 1000 units of any given chemicals. On each use, it sprays these reagents to target coords like a extinguisher, the amount for splash per tile is 15 units"
	reagent_flags = OPENCONTAINER
	volume = 1000
	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list(
		"volume" = IC_PINTYPE_NUMBER,
		"self reference" = IC_PINTYPE_SELFREF
		)
	activators = list(
		"spray" = IC_PINTYPE_PULSE_IN,
		"on sprayed" = IC_PINTYPE_PULSE_OUT,
		"on fail" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15
	max_allowed = 2

/obj/item/integrated_circuit/reagent/extinguisher/on_reagent_change(changetype)
	push_vol()

/obj/item/integrated_circuit/reagent/extinguisher/do_work(ord)
	//Check if enough volume
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	if(!reagents || reagents.total_volume < 5)
		push_data()
		activate_pin(3)
		return

	playsound(loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
	//Get the tile on which the water particle spawns
	var/turf/Spawnpoint = get_turf(src)
	if(!Spawnpoint)
		push_data()
		activate_pin(3)
		return

	//Get direction and target turf for each water particle
	var/turf/T = locate(Spawnpoint.x + get_pin_data(IC_INPUT, 1),Spawnpoint.y + get_pin_data(IC_INPUT, 2),Spawnpoint.z)
	if(!T)
		push_data()
		activate_pin(3)
		return
	assembly.visible_message(SPAN("notice", "\The [assembly] sprays their contents to \the [T]."))
	for(var/a = 1 to IC_SPLASH_MAX)
		spawn(0)

			if(reagents.total_volume < 5)
				// at least one time it splashed, so work done succesfully.
				push_data()
				activate_pin(2)
				return

			var/per_particle = min(reagents.total_volume, 15)/IC_SPLASH_MAX

			if(!isnum_safe(per_particle))
				push_data()
				activate_pin(3)
				return

			var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(src))
			W.create_reagents(per_particle)
			reagents.trans_to_obj(W, per_particle)
			W.set_color()
			W.set_up(T)

	var/list/reagent_names_list = list()
	for(var/datum/reagent/R in reagents?.reagent_list)
		reagent_names_list.Add(R.name)
	var/atom/AM = get_object()
	AM.investigate_log("extinguished reagents: [jointext(reagent_names_list, ", ")] with [src].", INVESTIGATE_CIRCUIT)

	push_data()
	activate_pin(2)

// - Beaker Connector - //
/obj/item/integrated_circuit/input/beaker_connector
	category_text = "Reagent"
	cooldown_per_use = 1
	name = "beaker slot"
	desc = "Lets you add a beaker to your assembly and remove it even when the assembly is closed."
	icon_state = "reagent_storage"
	extended_desc = "It can help you extract reagents easier."
	complexity = 4

	inputs = list()
	outputs = list(
		"volume used" = IC_PINTYPE_NUMBER,
		"current beaker" = IC_PINTYPE_REF
		)
	activators = list(
		"on insert" = IC_PINTYPE_PULSE_OUT,
		"on remove" = IC_PINTYPE_PULSE_OUT,
		"push ref" = IC_PINTYPE_PULSE_OUT
		)

	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	can_be_asked_input = TRUE
	demands_object_input = TRUE
	can_input_object_when_closed = TRUE

	var/obj/item/reagent_containers/glass/beaker/current_beaker


/obj/item/integrated_circuit/input/beaker_connector/attackby(obj/item/reagent_containers/glass/beaker/I, mob/living/user)
	//Check if it truly is a reagent container
	if(!istype(I,/obj/item/reagent_containers/glass/beaker))
		to_chat(user, SPAN("warning", "The [I] doesn't seem to fit in here."))
		return

	//Check if there is no other beaker already inside
	if(current_beaker)
		to_chat(user, SPAN("notice", "There is already a reagent container inside."))
		return

	//The current beaker is the one we just attached, its location is inside the circuit
	current_beaker = I
	user.drop_item(I)
	I.forceMove(src)

	to_chat(user, SPAN("warning", "You put the [I] inside the beaker connector."))

	//Set the pin to a weak reference of the current beaker
	push_vol()
	set_pin_data(IC_OUTPUT, 2, WEAKREF(current_beaker))
	push_data()
	activate_pin(1)
	activate_pin(3)


/obj/item/integrated_circuit/input/beaker_connector/ask_for_input(mob/user)
	attack_self(user)


/obj/item/integrated_circuit/input/beaker_connector/attack_self(mob/user)
	//Check if no beaker attached
	if(!current_beaker)
		to_chat(user, SPAN("notice", "There is currently no beaker attached."))
		return

	//Remove beaker and put in user's hands/location
	to_chat(user, SPAN("notice", "You take [current_beaker] out of the beaker connector."))
	user.put_in_hands(current_beaker)
	current_beaker = null
	//Remove beaker reference
	push_vol()
	set_pin_data(IC_OUTPUT, 2, null)
	push_data()
	activate_pin(2)
	activate_pin(3)


/obj/item/integrated_circuit/input/beaker_connector/proc/push_vol()
	var/beakerVolume = 0
	if(current_beaker)
		beakerVolume = current_beaker.reagents.total_volume

	set_pin_data(IC_OUTPUT, 1, beakerVolume)
	push_data()


/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	..()
	if(istype(loc,/obj/item/integrated_circuit/input/beaker_connector))
		var/obj/item/integrated_circuit/input/beaker_connector/current_circuit = loc
		current_circuit.push_vol()

#undef IC_REAGENTS_DRAW
#undef IC_REAGENTS_INJECT
#undef IC_SPLASH_MAX
