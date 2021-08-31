/obj/machinery/excelsior_autodoc
	name = "excelsior autodoc"
	desc = "Medical care for everybody, free, and may no one be left behind!"
	icon = 'icons/obj/machines/excelsior/autodoc.dmi'
	icon_state = "base"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_autodoc
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	var/cover_closed = FALSE
	var/cover_locked = FALSE
	var/cover_moving = FALSE
	var/mob/living/carbon/occupant
	var/datum/autodoc/autodoc_processor
	var/image/screen_state = null
	var/image/cover_state = null


/obj/machinery/excelsior_autodoc/New()
	. = ..()
	autodoc_processor = new/datum/autodoc()
	autodoc_processor.holder = src
	autodoc_processor.damage_heal_amount = 20
	update_icon()
	

/obj/machinery/excelsior_autodoc/Destroy()
	if(occupant)
		occupant.ghostize(0)
		occupant.gib()
	return ..()

/obj/machinery/excelsior_autodoc/relaymove(mob/user)
	if (usr.incapacitated())
		return
	src.go_out()
	return

/obj/machinery/excelsior_autodoc/attackby(obj/item/I, mob/living/user)
	if(default_deconstruction(I, user))
		return
	if(default_part_replacement(I, user))
		return
	..()

/obj/machinery/excelsior_autodoc/verb/eject()
	set src in view(1)
	set category = "Object"
	set name = "Eject Occupant"

	if (usr.incapacitated())
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/excelsior_autodoc/verb/move_inside()
	set src in view(1)
	set category = "Object"
	set name = "Enter Autodoc"

	if(usr.incapacitated())
		return
	if(occupant)
		to_chat(usr, SPAN_WARNING("The autodoc is already occupied!"))
		return
	if(usr.abiotic())
		to_chat(usr, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	set_occupant(usr)
	src.add_fingerprint(usr)
	return

/obj/machinery/excelsior_autodoc/proc/go_out()
	if (!occupant || cover_locked)
		return
	if(autodoc_processor.active)
		to_chat(usr, SPAN_WARNING("Comrade, autodoc is locked down! Wait until all operations is done."))
		return
	if(cover_closed)
		open_cover()

	for(var/obj/O in src)
		O.forceMove(loc)
	occupant.forceMove(loc)
	occupant.reset_view()
	occupant.unset_machine()
	occupant = null
	autodoc_processor.set_patient(null)
	update_use_power(1)
	update_icon()

/obj/machinery/excelsior_autodoc/proc/set_occupant(var/mob/living/L)
	src.add_fingerprint(usr)
	if(is_neotheology_disciple(L))
		playsound(src.loc, 'sound/mechs/internaldmgalarm.ogg', 50, 1)
		return
	L.forceMove(src)
	src.occupant = L
	autodoc_processor.set_patient(L)
	update_use_power(2)
	L.set_machine(src)
	cover_state = image(icon, "opened")
	cover_state.layer = 4.5

	if(!is_excelsior(L) && !emagged) // Let non-NT use emagged autodoc without brainwashing
		cover_locked = TRUE
		close_cover()
		sleep(30)
		to_chat(L, SPAN_DANGER("Autodoc is implanting you!"))
		sleep(50)
		var/obj/item/implant/excelsior/implant = new(L)
		if (!implant.install(L, BP_HEAD))
			qdel(implant)
		var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)
		var/datum/objective/timed/excelsior/E = (locate(/datum/objective/timed/excelsior) in F.objectives)
		if(E)
			if(!E.active)
				E.start_excel_timer()
			else
				E.on_convert()
		cover_locked = FALSE
	else
		update_icon()

/obj/machinery/excelsior_autodoc/attack_hand(mob/user)
	if(occupant)
		if(!cover_closed)
			close_cover()

		ui_interact(user)

/obj/machinery/excelsior_autodoc/affect_grab(mob/user, mob/target)
	if (occupant)
		to_chat(user, SPAN_NOTICE("The autodoc is already occupied!"))
		return
	if(target.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attempting to move them."))
		return
	if(target.abiotic())
		to_chat(user, SPAN_NOTICE("Subject cannot have abiotic items on."))
		return
	set_occupant(target)
	src.add_fingerprint(user)
	return TRUE

/obj/machinery/excelsior_autodoc/MouseDrop_T(mob/target, mob/user)
	if(!ismob(target))
		return
	if (occupant)
		to_chat(user, SPAN_WARNING("The autodoc is already occupied!"))
		return
	if (target.abiotic())
		to_chat(user, SPAN_WARNING("Subject cannot have abiotic items on."))
		return
	if (target.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attempting to move them."))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."),
		SPAN_NOTICE("You start placing \the [target] into \the [src].")
	)
	if(!do_after(user, 30, src) || !Adjacent(target))
		return
	set_occupant(target)
	src.add_fingerprint(user)
	return

/obj/machinery/excelsior_autodoc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(emagged)
		return
	emagged = TRUE

/obj/machinery/excelsior_autodoc/Process()
	if(stat & (NOPOWER|BROKEN))
		autodoc_processor.stop()
		update_icon()

/obj/machinery/excelsior_autodoc/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FORCE_OPEN, datum/topic_state/state = GLOB.default_state)
	autodoc_processor.ui_interact(user, ui_key, ui, force_open, state)

/obj/machinery/excelsior_autodoc/Topic(href, href_list)
	return autodoc_processor.Topic(href, href_list)

/obj/machinery/excelsior_autodoc/proc/open_cover()
	cover_state = image(icon, "opening")
	cover_state.layer = 5
	cover_closed = FALSE
	cover_moving = TRUE
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	update_icon()

/obj/machinery/excelsior_autodoc/proc/close_cover()
	cover_state = image(icon, "closing")
	cover_state.layer = 5
	cover_closed = TRUE
	cover_moving = TRUE
	playsound(src.loc, 'sound/machines/medbayscanner1.ogg', 50, 1)
	update_icon()

/obj/machinery/excelsior_autodoc/on_update_icon()

	cut_overlays()

	if(panel_open)
		var/image/panel = image(icon, "panel")
		panel.layer = 4.5
		add_overlays(panel)

	if(occupant)
		var/image/comrade = image(occupant.icon, occupant.icon_state)
		comrade.overlays = occupant.overlays
		comrade.pixel_x = 6
		comrade.layer = 4
		add_overlays(comrade)
		add_overlays(cover_state)
		if(cover_moving)
			sleep (15)
			if(cover_closed)
				cover_state = image(icon, "closed")
				cover_state.layer = 4.5
				cover_moving = FALSE
				update_icon()
			else
				cover_state = image(icon, "opened")
				cover_state.layer = 4.5
				cover_moving = FALSE
				update_icon()

		var/actual_health = occupant.maxHealth - (occupant.getBruteLoss() + occupant.getFireLoss() + occupant.getOxyLoss() + occupant.getToxLoss())
		if(actual_health < 1)
			screen_state = image(icon, "screen_00")
		else if(actual_health < 10)
			screen_state = image(icon, "screen_10")
		else if(actual_health < 20)
			screen_state = image(icon, "screen_20")
		else if(actual_health < 30)
			screen_state = image(icon, "screen_30")
		else if(actual_health < 40)
			screen_state = image(icon, "screen_40")
		else if(actual_health < 50)
			screen_state = image(icon, "screen_50")
		else if(actual_health < 60)
			screen_state = image(icon, "screen_60")
		else if(actual_health < 70)
			screen_state = image(icon, "screen_70")
		else if(actual_health < 80)
			screen_state = image(icon, "screen_80")
		else if(actual_health < 90)
			screen_state = image(icon, "screen_90")
		else if(actual_health <= 100)
			screen_state = image(icon, "screen_100")

	else
		screen_state = image(icon, "screen_idle")

	if(stat & (NOPOWER|BROKEN))
		screen_state = image(icon, "screen_off")
	
	add_overlays(screen_state)
