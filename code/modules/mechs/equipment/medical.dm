/obj/item/mech_e69uipment/sleeper
	name = "\improper exosuit sleeper"
	desc = "An exosuit-mounted sleeper designed to69antain patients stabilized on their way to69edical facilities."
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	e69uipment_delay = 30 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really re69uire power. We don't want people stuck inside
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	passive_power_use = 1.5 KILOWATTS
	var/obj/machinery/sleeper/mounted/sleeper =69ull

/obj/item/mech_e69uipment/sleeper/Initialize()
	. = ..()
	sleeper =69ew /obj/machinery/sleeper/mounted(src)
	sleeper.forceMove(src)

/obj/item/mech_e69uipment/sleeper/Destroy()
	sleeper.go_out() //If for any reason you weren't outside already.
	69DEL_NULL(sleeper)
	. = ..()

/obj/item/mech_e69uipment/sleeper/uninstalled()
	. = ..()
	sleeper.go_out()

/obj/item/mech_e69uipment/sleeper/attack_self(var/mob/user)
	. = ..()
	if(.)
		sleeper.ui_interact(user)

/obj/item/mech_e69uipment/sleeper/attackby(var/obj/item/I,69ar/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		sleeper.attackby(I, user)
	else return ..()

/obj/item/mech_e69uipment/sleeper/afterattack(atom/target,69ob/living/user, inrange, params)
	if(!inrange) return
	. = ..()
	if(.)
		if(ishuman(target) && !sleeper.occupant)
			owner.visible_message(SPAN_NOTICE("\The 69src69 is lowered down to load 69target69"))
			sleeper.go_in(target, user)
		else to_chat(user, SPAN_WARNING("You cannot load that in!"))

/obj/item/mech_e69uipment/sleeper/get_hardpoint_maptext()
	if(sleeper && sleeper.occupant)
		return "69sleeper.occupant69"

/obj/machinery/sleeper/mounted
	name = "\improper69ounted sleeper"
	density = FALSE
	anchored = FALSE
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for69ow all power is consumed by69ech sleeper object
	interact_offline = TRUE
	use_power =69O_POWER_USE
	spawn_blacklisted = TRUE

/obj/machinery/sleeper/mounted/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, datum/topic_state/state = GLOB.mech_state)
	. = ..()

/obj/machinery/sleeper/mounted/nano_host()
	var/obj/item/mech_e69uipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return69ull

//You cannot69odify these, it'd probably end with something in69ullspace. In any case basic69eds are plenty for an ambulance
/obj/machinery/sleeper/mounted/attackby(var/obj/item/I,69ar/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!user.unE69uip(I, src))
			return

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message("<span class='notice'>\The 69user69 removes \the 69beaker69 from \the 69src69.</span>", "<span class='notice'>You remove \the 69beaker69 from \the 69src69.</span>")
		beaker = I
		user.visible_message("<span class='notice'>\The 69user69 adds \a 69I69 to \the 69src69.</span>", "<span class='notice'>You add \a 69I69 to \the 69src69.</span>")

