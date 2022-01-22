/// How much healing is given per rating point of components (micro-laser and manipulator)
#define AUTODOC_HEAL_PER_UNIT 3.3
/// How much time is reduced per given rating point of scanning module components
#define AUTODOC_TIME_PER_UNIT 1.6
/// Default processing time for any wound
#define AUTODOC_DEFAULT_PROCESSING_TIME 35

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
	var/component_heal_multiplier = 0
	var/component_speed_multiplier = 0
	for(var/obj/item/stock_parts/part in component_parts)
		if(istype(part, /obj/item/stock_parts/manipulator) || istype(part, /obj/item/stock_parts/micro_laser))
			component_heal_multiplier += part.rating
		if(istype(part, /obj/item/stock_parts/scanning_module))
			component_speed_multiplier += part.rating
	autodoc_processor.damage_heal_amount = round(AUTODOC_HEAL_PER_UNIT*component_heal_multiplier) // 20 with excel parts  (3.3*6), 7 with stock parts ,  27 with one-star
	autodoc_processor.processing_speed = (max(1,(AUTODOC_DEFAULT_PROCESSING_TIME - round(AUTODOC_TIME_PER_UNIT * component_speed_multiplier)))) SECONDS // 30 with excel parts (35-4.8)
	update_icon()


/obj/machinery/excelsior_autodoc/Destroy()
	if(occupant)
		occupant.ghostize(0)
		occupant.gib()
	return ..()

/obj/machinery/excelsior_autodoc/relaymove(mob/user)
	if (user.incapacitated())
		return
	go_out()
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
	go_out()
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
	add_fingerprint(usr)
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

/obj/machinery/excelsior_autodoc/proc/set_occupant(mob/living/user)
	add_fingerprint(user)
	if(is_neotheology_disciple(user))
		playsound(loc, 'sound/mechs/internaldmgalarm.ogg', 50, 1)
		return
	user.forceMove(src)
	occupant = user
	autodoc_processor.set_patient(user)
	update_use_power(2)
	user.set_machine(src)
	cover_state = image(icon, "opened")
	cover_state.layer = 4.5

	if(!is_excelsior(user) && !emagged) // Let non-NT use emagged autodoc without brainwashing
		cover_locked = TRUE
		close_cover()
		sleep(30)
		to_chat(user, SPAN_DANGER("Autodoc is implanting you!"))
		sleep(50)
		var/obj/item/implant/excelsior/implant = new(user)
		if (!implant.install(user, BP_HEAD))
			qdel(implant)
		var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)
		var/datum/objective/timed/excelsior/excel_timer = (locate(/datum/objective/timed/excelsior) in F.objectives)
		if(excel_timer)
			if(!excel_timer.active)
				excel_timer.start_excel_timer()
			else
				excel_timer.on_convert()
		cover_locked = FALSE
	else
		update_icon()

/obj/machinery/excelsior_autodoc/attack_hand(mob/user)
	if(occupant)
		if(!cover_closed)
			close_cover()

		nano_ui_interact(user)

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
	add_fingerprint(user)
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
	add_fingerprint(user)
	return

/obj/machinery/excelsior_autodoc/emag_act(remaining_charges, mob/user, emag_source)
	if(emagged)
		return
	emagged = TRUE

/obj/machinery/excelsior_autodoc/Process()
	if(stat & (NOPOWER|BROKEN))
		autodoc_processor.stop()
		update_icon()

/obj/machinery/excelsior_autodoc/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FORCE_OPEN, datum/nano_topic_state/state = GLOB.default_state)
	autodoc_processor.nano_ui_interact(user, ui_key, ui, force_open, state)

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

/obj/machinery/excelsior_autodoc/update_icon()

	cut_overlays()

	if(panel_open)
		var/image/panel = image(icon, "panel")
		panel.layer = 4.5
		overlays += panel

	if(occupant)
		var/image/comrade = image(occupant.icon, occupant.icon_state)
		comrade.overlays = occupant.overlays
		comrade.pixel_x = 6
		comrade.layer = 4
		overlays += comrade
		overlays += cover_state
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

		var/actual_health = max(0,round((occupant.maxHealth - (occupant.getBruteLoss() + occupant.getFireLoss() + occupant.getOxyLoss() + occupant.getToxLoss()))/10))
		screen_state = image(icon, "screen_[actual_health]0")
	else
		screen_state = image(icon, "screen_idle")

	if(stat & (NOPOWER|BROKEN))
		screen_state = image(icon, "screen_off")

	overlays += screen_state
