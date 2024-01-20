/obj/item/mech_equipment/sleeper
	name = "\improper exosuit sleeper"
	desc = "An exosuit-mounted sleeper designed to mantain patients stabilized on their way to medical facilities."
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 30 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really require power. We don't want people stuck inside
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	passive_power_use = 1.5 KILOWATTS
	var/obj/machinery/sleeper/mounted/sleeper = null

/obj/item/mech_equipment/sleeper/Initialize()
	. = ..()
	sleeper = new /obj/machinery/sleeper/mounted(src)
	sleeper.forceMove(src)

/obj/item/mech_equipment/sleeper/Destroy()
	sleeper.go_out() //If for any reason you weren't outside already.
	QDEL_NULL(sleeper)
	. = ..()

/obj/item/mech_equipment/sleeper/uninstalled()
	. = ..()
	sleeper.go_out()

/obj/item/mech_equipment/sleeper/attack_self(var/mob/user)
	. = ..()
	if(.)
		sleeper.nano_ui_interact(user)

/obj/item/mech_equipment/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		sleeper.attackby(I, user)
	else return ..()

/obj/item/mech_equipment/sleeper/afterattack(atom/target, mob/living/user, inrange, params)
	if(!inrange) return
	. = ..()
	if(.)
		if(ishuman(target) && !sleeper.occupant)
			owner.visible_message(SPAN_NOTICE("\The [src] is lowered down to load [target]"))
			sleeper.go_in(target, user)
		else to_chat(user, SPAN_WARNING("You cannot load that in!"))

/obj/item/mech_equipment/sleeper/get_hardpoint_maptext()
	if(sleeper && sleeper.occupant)
		return "[sleeper.occupant]"

/obj/machinery/sleeper/mounted
	name = "\improper mounted sleeper"
	density = FALSE
	anchored = FALSE
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for now all power is consumed by mech sleeper object
	interact_offline = TRUE
	use_power = NO_POWER_USE
	spawn_blacklisted = TRUE

/obj/machinery/sleeper/mounted/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/nano_topic_state/state = GLOB.mech_state)
	. = ..()

/obj/machinery/sleeper/mounted/nano_host()
	var/obj/item/mech_equipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return null

//You cannot modify these, it'd probably end with something in nullspace. In any case basic meds are plenty for an ambulance
/obj/machinery/sleeper/mounted/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!user.unEquip(I, src))
			return

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message("<span class='notice'>\The [user] removes \the [beaker] from \the [src].</span>", "<span class='notice'>You remove \the [beaker] from \the [src].</span>")
		beaker = I
		user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")

/obj/item/mech_equipment/sleeper/upgraded
	name = "\improper MK2 mounted sleeper"
	desc = "An exosuit-mounted sleeper designed to heal patients"
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 3, TECH_BIO = 5)
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 10, MATERIAL_GLASS = 5, MATERIAL_SILVER = 3, MATERIAL_PLATINUM = 1)

/obj/item/mech_equipment/sleeper/upgraded/Initialize()
	. = ..()
	// delete old one
	qdel(sleeper)
	sleeper = new /obj/machinery/sleeper/mounted/upgraded(src)
	sleeper.forceMove(src)

/obj/machinery/sleeper/mounted/upgraded
	name = "\improper MK2 mounted sleeper"
	available_chemicals = list("inaprovaline2" = "Synth-Inaprovaline",
	"quickclot" = "Quick-Clot",
	"stoxin" = "Soporific",
	"tramadol" = "Tramadol",
	"anti_toxin" = "Dylovene",
	"dexalin" = "Dexalin",
	"tricordrazine" = "Tricordrazine",
	"polystem" = "PolyStem")

/obj/item/mech_equipment/auto_mender
	name = "\improper exosuit auto-mender"
	desc = "A mech-designed and equipped medical system for fast and automatic application of advanced trauma treatments to pacients. Makes use of medical gear found in trauma kits."
	icon_state = "mech_mender"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 10 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really require power.
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 5, TECH_ENGINEERING = 3)
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 8, MATERIAL_GLASS = 5)
	passive_power_use = 1.5 KILOWATTS
	var/mob/living/carbon/human/mending_target = null
	var/mob/living/exosuit/mech = null
	var/obj/item/organ/external/affecting = null
	var/trauma_charges_stored = 0
	var/trauma_storage_max = 30

/obj/item/mech_equipment/auto_mender/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if(. && ishuman(target))
		if(!trauma_charges_stored && mending_target)
			mending_target = null
			to_chat(user, SPAN_NOTICE("ERROR: Auto-mender stock is depleted. Refill required."))
			return
		if(mending_target == target)
			mending_target = null
			to_chat(user, SPAN_NOTICE("You cancel \the [src]'s mending on [target]."))
			return
		if(mending_target)
			to_chat(user, SPAN_NOTICE("You stop \the [src] from mending [mending_target]."))
			mending_target = null
		if(!target.Adjacent(mech))
			to_chat(user, SPAN_NOTICE("You need to be next to \the [target] to start mending them!"))
		mending_target = target
		mending_loop()

/obj/item/mech_equipment/auto_mender/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/medical/advanced/bruise_pack))
		var/obj/item/stack/medical/advanced/bruise_pack/pack = I
		var/substract = clamp(pack.amount, 0, trauma_storage_max - trauma_charges_stored)
		if(substract && pack.use(substract))
			trauma_charges_stored += substract
			to_chat(user, SPAN_NOTICE("You restock \the [src]'s internal medicine storage with \the [I], using [substract] charges."))

		if(trauma_charges_stored >= trauma_storage_max)
			to_chat(user, SPAN_NOTICE("The auto-mender's storage is full!"))
			return

/obj/item/mech_equipment/auto_mender/installed(mob/living/exosuit/_owner, hardpoint)
	. = ..()
	mech = _owner

/obj/item/mech_equipment/auto_mender/uninstalled()
	. = ..()
	mech = null

/obj/item/mech_equipment/auto_mender/proc/mending_loop()
	if(!mending_target || !mech)
		return
	if(!mech.Adjacent(mending_target))
		mending_target = null
		affecting = null
		return
	var/obj/item/organ/external/checking
	if(!affecting || (affecting && affecting.is_bandaged()))
		for(var/zone in BP_ALL_LIMBS)
			checking = mending_target.organs_by_name[zone]
			if(checking.is_bandaged() && checking.damage < 1)
				continue
			if(affecting)
				if(checking.damage > affecting.damage)
					affecting = checking
			else
				affecting = checking

	if(!affecting)
		mending_target = null

		return

	for(var/datum/wound/W in affecting.wounds)
		if(!mech.Adjacent(mending_target))
			mending_target = null
			affecting = null
			return
//		if(W.internal || W.bandaged)
//			continue
		if(W.damage < 1)
			continue
		if(!trauma_charges_stored)
			to_chat(mech.get_mob(), SPAN_NOTICE("ERROR: Auto-mender stock is depleted. Refill required."))
			playsound(src, 'sound/mechs/internaldmgalarm.ogg', 50, 1)
			break
		if(!do_mob(mech.get_mob(), mending_target, W.damage/5))
			to_chat(mech.get_mob(), SPAN_NOTICE("You must stand still to bandage wounds."))
			mending_target = null
			affecting = null
			break
//		if(W.internal || W.bandaged)
//			continue
		if (W.current_stage <= W.max_bleeding_stage)
			mech.visible_message(
				SPAN_NOTICE("\The [mech] cleans \a [W.desc] on [mending_target]'s [affecting.name] and seals the edges with bioglue."),
				SPAN_NOTICE("You clean and seal \a [W.desc] on [mending_target]'s [affecting.name].")
			)
		else if (W.damage_type == BRUISE)
			mech.visible_message(
				SPAN_NOTICE("\The [mech] places a medical patch over \a [W.desc] on [mending_target]'s [affecting.name]."),
				SPAN_NOTICE("You place a medical patch over \a [W.desc] on [mending_target]'s [affecting.name].")
			)
		else
			mech.visible_message(
				SPAN_NOTICE("\The [mech] smears some bioglue over \a [W.desc] on [mending_target]'s [affecting.name]."),
				SPAN_NOTICE("You smear some bioglue over \a [W.desc] on [mending_target]'s [affecting.name].")
			)
		W.bandage()
		W.heal_damage(10)
		trauma_charges_stored--
	// If it doesn't cancel or run out of kits just repeat for every external organ.
	if(affecting.is_bandaged() && affecting.damage < 1)
		affecting = null
		mending_loop()



