/obj/item/integrated_circuit/reagent
	category_text = "Reagent"
	var/volume = 0
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/New()
	..()
	if(volume)
		create_reagents(volume)

/obj/item/integrated_circuit/reagent/smoke
	name = "smoke generator"
	desc = "Unlike69ost electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command.  It can also hold liquids inside, which will go \
	into the smoke clouds when activated."
	reagent_flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 30 SECONDS
	inputs = list()
	outputs = list()
	activators = list("create smoke")
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 3)
	volume = 100
	power_draw_per_use = 20

/obj/item/integrated_circuit/reagent/smoke/do_work()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect/effect/system/smoke_spread/chem/smoke_system = new()
	smoke_system.set_up(reagents, 10, 0, get_turf(src))
	spawn(0)
		for(var/i = 1 to 8)
			smoke_system.start()
		reagents.clear_reagents()

/obj/item/integrated_circuit/reagent/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into whatever it's pointed at."
	icon_state = "injector"
	extended_desc = "This autoinjector can push reagents into another container or someone else outside of the69achine.  The target \
	must be adjacent to the69achine, and if it is a person, they cannot be wearing thick clothing."
	reagent_flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list("\<REF\> target", "\<NUM\> injection amount" = 5)
	outputs = list()
	activators = list("\<PULSE IN\> inject")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	volume = 30
	power_draw_per_use = 15

/obj/item/integrated_circuit/reagent/injector/proc/inject_amount()
	var/amount = get_pin_data(IC_INPUT, 2)
	if(isnum(amount))
		return CLAMP(amount, 0, 30)

/obj/item/integrated_circuit/reagent/injector/proc/inject_check(atom/movable/target)
	if(!target.Adjacent(get_turf(src)))
		return FALSE

	if(!target.is_injectable(allowmobs = TRUE))
		return FALSE

	if(!target.reagents.get_free_space())
		return FALSE

	return TRUE

/obj/item/integrated_circuit/reagent/injector/do_work()
	set waitfor = 0 // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing

	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	if(!istype(AM)) //Invalid input
		return
	if(!reagents.total_volume) // Empty
		return
	if(inject_check(AM))
		if(isliving(AM))
			var/mob/living/L = AM
			var/turf/T = get_turf(AM)
			T.visible_message(SPAN_WARNING("69src69 is trying to inject 69L69!"))
			sleep(3 SECONDS)
			if(!inject_check(L))
				return
			var/contained = reagents.log_list()
			var/trans = reagents.trans_to_mob(L, inject_amount(), CHEM_BLOOD)
			message_admins("69src69 injected \the 69L69 with 69trans69u of 69contained69.")
			to_chat(L, SPAN_NOTICE("You feel a tiny prick!"))
			visible_message(SPAN_WARNING("69src69 injects 69L69!"))
		else
			reagents.trans_to(AM, inject_amount())

/obj/item/integrated_circuit/reagent/pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a69achine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump, which will69ove liquids from the source ref to the target ref.  The third pin determines \
	how69uch liquid is69oved per pulse, between 0 and 50.  The pump can69ove reagents to any open container inside the69achine, or \
	outside the69achine if it is next to the69achine.  Note that this cannot be used on entities."
	reagent_flags = OPENCONTAINER
	complexity = 8
	inputs = list("\<REF\> source", "\<REF\> target", "\<NUM\> injection amount" = 10)
	outputs = list()
	activators = list("\<PULSE IN\> transfer reagents", "\<PULSE OUT\> on transfer")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	var/transfer_amount = 10
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/pump/on_data_written()
	var/datum/integrated_io/amount = inputs69369
	if(isnum(amount.data))
		amount.data = CLAMP(amount.data, 0, 50)
		transfer_amount = amount.data

/obj/item/integrated_circuit/reagent/pump/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)

	if(!istype(source) || !istype(target)) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(source.Adjacent(T) && target.Adjacent(T))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_drainable() || !target.is_refillable())
			return
		if(!target.reagents.get_free_space())
			return

		source.reagents.trans_to(target, transfer_amount)
		activate_pin(2)

/obj/item/integrated_circuit/reagent/storage
	name = "reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u."
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal beaker."
	reagent_flags = OPENCONTAINER
	complexity = 4
	inputs = list()
	outputs = list("volume used")
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	volume = 60

/obj/item/integrated_circuit/reagent/storage/on_reagent_change()
	var/datum/integrated_io/A = outputs69169
	A.data = reagents.total_volume
	A.push_data()

/obj/item/integrated_circuit/reagent/storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  This will also suppress reactions."
	icon_state = "reagent_storage_cryo"
	extended_desc = "This is effectively an internal cryo beaker."
	reagent_flags = OPENCONTAINER | NO_REACT
	complexity = 8
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIALS = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)