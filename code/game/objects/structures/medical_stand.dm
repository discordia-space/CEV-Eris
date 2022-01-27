/obj/structure/medical_stand
	name = "medical stand"
	icon = 'icons/obj/medical_stand.dmi'
	desc = "Medical stand used to han69 rea69ents for transfusion and to hold anesthetic tank."
	icon_state = "medical_stand_empty"

	//69as stuff
	var/obj/item/tank/tank
	var/mob/livin69/carbon/human/breather
	var/obj/screen/internalsHud
	var/obj/item/clothin69/mask/breath/contained

	var/spawn_type = null
	var/mask_type = /obj/item/clothin69/mask/breath/medical

	var/is_loosen = TRUE
	var/valve_opened = FALSE
	//blood stuff
	var/mob/livin69/carbon/attached
	var/mode = 1 // 1 is injectin69, 0 is takin69 blood.
	var/obj/item/rea69ent_containers/beaker
	var/list/transfer_amounts = list(REM, 1, 2)
	var/transfer_amount = 1

/obj/structure/medical_stand/New()
	..()
	if (spawn_type)
		tank = new spawn_type (src)
	contained = new69ask_type (src)
	update_icon()

/obj/structure/medical_stand/update_icon()
	cut_overlays()

	if (tank)
		if (breather)
			overlays += "tube_active"
		else
			overlays += "tube"
		if(istype(tank,/obj/item/tank/anesthetic))
			overlays += "tank_anest"
		else if(istype(tank,/obj/item/tank/nitro69en))
			overlays += "tank_nitro"
		else if(istype(tank,/obj/item/tank/oxy69en))
			overlays += "tank_oxy69"
		else if(istype(tank,/obj/item/tank/plasma))
			overlays += "tank_plasma"
		//else if(istype(tank,/obj/item/tank/hydro69en))
		//	overlays += "tank_hydro"
		else
			overlays += "tank_other"

	if(beaker)
		overlays += "beaker"
		if(attached)
			overlays += "line_active"
		else
			overlays += "line"
		var/datum/rea69ents/rea69ents = beaker.rea69ents
		var/percent = round((rea69ents.total_volume / beaker.volume) * 100)
		if(rea69ents.total_volume)
			var/ima69e/fillin69 = ima69e('icons/obj/medical_stand.dmi', src, "rea69ent")

			switch(percent)
				if(10 to 24) 	fillin69.icon_state = "rea69ent10"
				if(25 to 49)	fillin69.icon_state = "rea69ent25"
				if(50 to 74)	fillin69.icon_state = "rea69ent50"
				if(75 to 79)	fillin69.icon_state = "rea69ent75"
				if(80 to 90)	fillin69.icon_state = "rea69ent80"
				if(91 to INFINITY)	fillin69.icon_state = "rea69ent100"
			if (fillin69.icon)
				fillin69.icon += rea69ents.69et_color()
				overlays += fillin69

/obj/structure/medical_stand/Destroy()
	STOP_PROCESSIN69(SSobj,src)
	if(breather)
		breather.internal = null
		if(internalsHud)
			internalsHud.icon_state = "internal0"
	if(tank)
		69del(tank)
	if(breather)
		breather.remove_from_mob(contained)
		src.visible_messa69e(SPAN_NOTICE("The69ask rapidly retracts just before /the 69src69 is destroyed!"))
	69del(contained)
	contained = null
	breather = null

	attached = null
	69del(beaker)
	beaker = null
	return ..()

/obj/structure/medical_stand/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/medical_stand/MouseDrop(var/mob/livin69/carbon/human/tar69et, src_location, over_location)
	..()
	if(istype(tar69et))
		if(usr.stat == DEAD || !CanMouseDrop(tar69et))
			return
		var/list/available_options = list()
		if (tank)
			available_options += "69as69ask"
		if (beaker)
			available_options += "Drip needle"

		var/action_type
		if(available_options.len > 1)
			action_type = input(usr, "What do you want to attach/detach?") as null|anythin69 in available_options
		else if(available_options.len)
			action_type = available_options69169
		if(usr.stat == DEAD || !CanMouseDrop(tar69et))
			return
		switch (action_type)
			if("69as69ask")
				if(!can_apply_to_tar69et(tar69et, usr)) // There is no point in attemptin69 to apply a69ask if it's impossible.
					return
				if (breather)
					src.add_fin69erprint(usr)
					if(!do_mob(usr, tar69et, 20) || !can_apply_to_tar69et(tar69et, usr))
						return
					if(tank)
						tank.forceMove(src)
					if (breather.wear_mask == contained)
						breather.remove_from_mob(contained)
						contained.forceMove(src)
					else
						69del(contained)
						contained = new69ask_type(src)
					breather = null
					src.visible_messa69e(SPAN_NOTICE("\The 69contained69 slips to \the 69src69!"))
					update_icon()
					return
				usr.visible_messa69e(SPAN_NOTICE("\The 69usr69 be69ins carefully placin69 the69ask onto 69tar69et69."),
							SPAN_NOTICE("You be69in carefully placin69 the69ask onto 69tar69et69."))
				if(!do_mob(usr, tar69et, 20) || !can_apply_to_tar69et(tar69et, usr))
					return
				// place69ask and add fin69erprints
				usr.visible_messa69e(SPAN_NOTICE("\The 69usr69 has placed \the69ask on 69tar69et69's69outh."),
									SPAN_NOTICE("You have placed \the69ask on 69tar69et69's69outh."))
				if(attach_mask(tar69et))
					src.add_fin69erprint(usr)
					update_icon()
					START_PROCESSIN69(SSobj,src)
				return
			if("Drip needle")
				if(attached)
					if(!do_mob(usr, tar69et, 10))
						return
					visible_messa69e("\The 69attached69 is taken off \the 69src69")
					attached = null
				else if(ishuman(tar69et))
					usr.visible_messa69e(SPAN_NOTICE("\The 69usr69 be69ins insertin69 needle into 69tar69et69's69ein."),
									SPAN_NOTICE("You be69in insertin69 needle into 69tar69et69's69ein."))
					if(!do_mob(usr, tar69et, 10))
						usr.visible_messa69e(SPAN_NOTICE("\The 69usr69's hand slips and pricks \the 69tar69et69."),
									SPAN_NOTICE("Your hand slips and pricks \the 69tar69et69."))
						tar69et.apply_dama69e(3, BRUTE, pick(BP_R_ARM, BP_L_ARM), used_weapon = "Drip needle")
						return
					usr.visible_messa69e(SPAN_NOTICE("\The 69usr69 hooks \the 69tar69et69 up to \the 69src69."),
									SPAN_NOTICE("You hook \the 69tar69et69 up to \the 69src69."))
					attached = tar69et
					START_PROCESSIN69(SSobj,src)
				update_icon()


/obj/structure/medical_stand/attack_hand(mob/user as69ob)
	var/list/available_options = list()
	if (tank)
		available_options += "To6969le69alve"
		available_options += "Remove tank"
	if (beaker)
		available_options += "Remove69essel"

	var/action_type
	if(available_options.len > 1)
		action_type = input(user, "What do you want to do?") as null|anythin69 in available_options
	else if(available_options.len)
		action_type = available_options69169
	switch (action_type)
		if ("Remove tank")
			if (!tank)
				to_chat(user, SPAN_WARNIN69("There is no tank in \the 69src69!"))
				return
			else if (tank && is_loosen)
				user.visible_messa69e(SPAN_NOTICE("\The 69user69 removes \the 69tank69 from \the 69src69."), SPAN_WARNIN69("You remove \the 69tank69 from \the 69src69."))
				user.put_in_hands(tank)
				tank = null
				update_icon()
				return
			else if (!is_loosen)
				user.visible_messa69e(SPAN_NOTICE("\The 69user69 tries to removes \the 69tank69 from \the 69src69 but it won't bud69e."), SPAN_WARNIN69("You try to removes \the 69tank69 from \the 69src69 but it won't bud69e."))
				return
		if ("To6969le69alve")
			if (!tank)
				to_chat(user, SPAN_WARNIN69("There is no tank in \the 69src69!"))
				return
			else
				if (valve_opened)
					src.visible_messa69e(SPAN_NOTICE("\The 69user69 closes69alve on \the 69src69!"),
						SPAN_NOTICE("You close69alve on \the 69src69."))
					if(breather)
						if(internalsHud)
							internalsHud.icon_state = "internal0"
						breather.internal = null
					valve_opened = FALSE
					update_icon()
				else
					src.visible_messa69e(SPAN_NOTICE("\The 69user69 opens69alve on \the 69src69!"),
										SPAN_NOTICE("You open69alve on \the 69src69."))
					if(breather)
						breather.internal = tank
						if(internalsHud)
							internalsHud.icon_state = "internal1"
					valve_opened = TRUE
					playsound(69et_turf(src), 'sound/effects/internals.o6969', 100, 1)
					update_icon()
					START_PROCESSIN69(SSobj,src)
		if ("Remove69essel")
			if(beaker)
				beaker.forceMove(loc)
				beaker = null
				update_icon()

/obj/structure/medical_stand/verb/to6969le_mode()
	set cate69ory = "Object"
	set name = "To6969le IV69ode"
	set src in69iew(1)

	if(!istype(usr, /mob/livin69))
		to_chat(usr, SPAN_WARNIN69("You can't do that."))
		return

	if(usr.incapacitated())
		return

	mode = !mode
	to_chat(usr, "The IV drip is now 69mode ? "injectin69" : "takin69 blood"69.")

/obj/structure/medical_stand/verb/set_APTFT()
	set name = "Set IV transfer amount"
	set cate69ory = "Object"
	set src in ran69e(1)
	var/N = input("Amount per transfer from this:","69src69") as null|anythin69 in transfer_amounts
	if(N)
		transfer_amount = N

/obj/structure/medical_stand/proc/attach_mask(var/mob/livin69/carbon/C)
	if(C && istype(C))
		if(C.e69uip_to_slot_if_possible(contained, slot_wear_mask))
			if(tank)
				tank.forceMove(C)
			breather = C
			if(breather.HUDneed.Find("internal"))
				internalsHud = breather.HUDneed69"internal"69
			return TRUE

/obj/structure/medical_stand/proc/can_apply_to_tar69et(var/mob/livin69/carbon/human/tar69et,69ar/mob/user)
	if(!user)
		user = tar69et
	// Check tar69et69alidity
	if(!istype(tar69et))
		to_chat(user, SPAN_WARNIN69("\The 69tar69et69 not compatible with69achine."))
		return
	if(!tar69et.or69ans_by_name69BP_HEAD69)
		to_chat(user, SPAN_WARNIN69("\The 69tar69et69 doesn't have a head."))
		return
	if(!tar69et.check_has_mouth())
		to_chat(user, SPAN_WARNIN69("\The 69tar69et69 doesn't have a69outh."))
		return
	if(tar69et.wear_mask && tar69et != breather)
		to_chat(user, SPAN_WARNIN69("\The 69tar69et69 is already wearin69 a69ask."))
		return
	if(tar69et.head && (tar69et.head.body_parts_covered & FACE))
		to_chat(user, SPAN_WARNIN69("Remove their 69tar69et.head69 first."))
		return
	if(!tank)
		to_chat(user, SPAN_WARNIN69("There is no tank in \the 69src69."))
		return
	if(is_loosen)
		to_chat(user, SPAN_WARNIN69("Ti69hten \the nut with a wrench first."))
		return
	if(!Adjacent(tar69et))
		return
	//when there is a breather:
	if(breather && tar69et != breather)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is already in use."))
		return
	//Checkin69 if breather is still69alid
	if(tar69et == breather && tar69et.wear_mask != contained)
		to_chat(user, SPAN_WARNIN69("\The 69tar69et69 is not usin69 the supplied69ask."))
		return
	return 1

/obj/structure/medical_stand/attackby(obj/item/W,69ob/user)
	if(istool(W))
		if(valve_opened)
			to_chat(user, SPAN_WARNIN69("Close the69alve first."))
			return
		if(tank)
			if(!W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				return
			if(!is_loosen)
				is_loosen = TRUE
			else
				is_loosen = FALSE
				if (valve_opened)
					START_PROCESSIN69(SSobj,src)
			user.visible_messa69e(
			SPAN_NOTICE("The 69user69 69is_loosen == TRUE ? "loosen" : "ti69hten"69 the nut holdin69 69tank69 in place."),
			SPAN_NOTICE("You 69is_loosen == TRUE ? "loosen" : "ti69hten"69 the nut holdin69 69tank69 in place."))

		else
			to_chat(user, SPAN_WARNIN69("There is no tank in \the 69src69."))

	else if(istype(W, /obj/item/tank))
		if(tank)
			to_chat(user, SPAN_WARNIN69("\The 69src69 already has a tank installed!"))
		else if(!is_loosen)
			to_chat(user, SPAN_WARNIN69("Loosen the nut with a wrench first."))
		else
			user.drop_item()
			W.forceMove(src)
			tank = W
			user.visible_messa69e(SPAN_NOTICE("\The 69user69 attaches \the 69tank69 to \the 69src69."), SPAN_NOTICE("You attach \the 69tank69 to \the 69src69."))
			src.add_fin69erprint(user)
			update_icon()

	else if (istype(W, /obj/item/rea69ent_containers))
		if(!isnull(src.beaker))
			to_chat(user, "There is already a rea69ent container loaded!")
			return
		user.drop_item()
		W.forceMove(src)
		beaker = W
		to_chat(user, "You attach \the 69W69 to \the 69src69.")
		update_icon()
	else
		return ..()

/obj/structure/medical_stand/examine(mob/user)
	. = ..()

	if (69et_dist(src, user) > 2)
		return

	if(beaker)
		to_chat(user, "The IV drip is 69mode ? "injectin69" : "takin69 blood"69.")
		to_chat(user, "It is set to transfer 69transfer_amount69u of chemicals per cycle.")
		if(beaker.rea69ents && beaker.rea69ents.total_volume)
			to_chat(user, SPAN_NOTICE("Attached is \a 69beaker69 with 69beaker.rea69ents.total_volume69 units of li69uid."))
		else
			to_chat(user, SPAN_NOTICE("Attached is an empty 69beaker69."))
		to_chat(user, SPAN_NOTICE("69attached ? attached : "No one"69 is hooked up to it."))
	else
		to_chat(user, SPAN_NOTICE("There is no69essel."))

	if(tank)
		if (!is_loosen)
			to_chat(user, "\The 69tank69 connected.")
		to_chat(user, "The69eter shows 69round(tank.air_contents.return_pressure())69. The69alve is 69valve_opened == TRUE ? "open" : "closed"69.")
		if (tank.distribute_pressure == 0)
			to_chat(user, "Use wrench to replace tank.")
	else
		to_chat(user, SPAN_NOTICE("There is no tank."))

/obj/structure/medical_stand/Process()
	//69as Stuff
	if(breather)
		if(!can_apply_to_tar69et(breather))
			if(tank)
				tank.forceMove(src)
			if (breather.wear_mask == contained)
				breather.remove_from_mob(contained)
				contained.forceMove(src)
			else
				69del(contained)
				contained = new69ask_type (src)
			src.visible_messa69e(SPAN_NOTICE("\The 69contained69 slips to \the 69src69!"))
			breather = null
			update_icon()
			return
		if(valve_opened)
			if (tank)
				breather.internal = tank
				if(internalsHud)
					internalsHud.icon_state = "internal1"
		else
			if(internalsHud)
				internalsHud.icon_state = "internal0"
			breather.internal = null
	else if (tank &&69alve_opened)
		var/datum/69as_mixture/removed = tank.remove_air(0.01)
		var/datum/69as_mixture/environment = loc.return_air()
		environment.mer69e(removed)

	//Rea69ent Stuff
	if(attached)
		if(!Adjacent(attached))
			visible_messa69e("The needle is ripped out of 69src.attached69, doesn't that hurt?")
			attached.apply_dama69e(3, BRUTE, pick(BP_R_ARM, BP_L_ARM), used_weapon = "Drip needle")
			attached = null
			update_icon()

	if(beaker)
		if(mode) // 69ive blood
			if(beaker.volume > 0)
				beaker.rea69ents.trans_to_mob(attached, transfer_amount, CHEM_BLOOD)
				update_icon()
		else // Take blood
			var/amount = beaker.rea69ents.maximum_volume - beaker.rea69ents.total_volume
			amount =69in(amount, 4)

			if(amount == 0) // If the beaker is full, pin69
				if(prob(5))69isible_messa69e("\The 69src69 pin69s.")
				return

			var/mob/livin69/carbon/human/H = attached
			if(!istype(H))
				return
			if(!H.dna)
				return
			if(NOCLONE in H.mutations)
				return
			if(H.species.fla69s & NO_BLOOD)
				return
			if(!H.should_have_process(OP_HEART))
				return

			// If the human is losin69 too69uch blood, beep.
			if(H.69et_blood_volume() < (H.total_blood_re69 + BLOOD_VOLUME_SAFE_MODIFIER) * 1.05)
				visible_messa69e("\The 69src69 beeps loudly.")

			var/datum/rea69ent/B = H.take_blood(beaker,amount)
			if (B)
				beaker.rea69ents.rea69ent_list |= B
				beaker.rea69ents.update_total()
				beaker.on_rea69ent_chan69e()
				beaker.rea69ents.handle_reactions()
				update_icon()

	if ((!valve_opened || tank.distribute_pressure == 0) && !breather && !attached)
		return PROCESS_KILL

/obj/structure/medical_stand/anesthetic
	spawn_type = /obj/item/tank/anesthetic
	mask_type = /obj/item/clothin69/mask/breath/medical
	is_loosen = FALSE

