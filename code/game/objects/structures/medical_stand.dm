/obj/structure/medical_stand
	name = "medical stand"
	icon = 'icons/obj/medical_stand.dmi'
	desc = "Medical stand used to hang reagents for transfusion and to hold anesthetic tank."
	icon_state = "medical_stand_empty"

	//gas stuff
	var/obj/item/weapon/tank/tank
	var/mob/living/carbon/human/breather
	var/obj/screen/internalsHud
	var/obj/item/clothing/mask/breath/contained

	var/spawn_type = null
	var/mask_type = /obj/item/clothing/mask/breath/medical

	var/is_loosen = TRUE
	var/valve_opened = FALSE
	//blood stuff
	var/mob/living/carbon/attached
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/obj/item/weapon/reagent_containers/beaker
	var/list/transfer_amounts = list(REM, 1, 2)
	var/transfer_amount = 1

/obj/structure/medical_stand/New()
	..()
	if (spawn_type)
		tank = new spawn_type (src)
	contained = new mask_type (src)
	update_icon()

/obj/structure/medical_stand/update_icon()
	overlays.Cut()

	if (tank)
		if (breather)
			overlays += "tube_active"
		else
			overlays += "tube"
		if(istype(tank,/obj/item/weapon/tank/anesthetic))
			overlays += "tank_anest"
		else if(istype(tank,/obj/item/weapon/tank/nitrogen))
			overlays += "tank_nitro"
		else if(istype(tank,/obj/item/weapon/tank/oxygen))
			overlays += "tank_oxyg"
		else if(istype(tank,/obj/item/weapon/tank/plasma))
			overlays += "tank_plasma"
		//else if(istype(tank,/obj/item/weapon/tank/hydrogen))
		//	overlays += "tank_hydro"
		else
			overlays += "tank_other"

	if(beaker)
		overlays += "beaker"
		if(attached)
			overlays += "line_active"
		else
			overlays += "line"
		var/datum/reagents/reagents = beaker.reagents
		var/percent = round((reagents.total_volume / beaker.volume) * 100)
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/medical_stand.dmi', src, "reagent")

			switch(percent)
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to INFINITY)	filling.icon_state = "reagent100"
			if (filling.icon)
				filling.icon += reagents.get_color()
				overlays += filling

/obj/structure/medical_stand/Destroy()
	STOP_PROCESSING(SSobj,src)
	if(breather)
		breather.internal = null
		if(internalsHud)
			internalsHud.icon_state = "internal0"
	if(tank)
		qdel(tank)
	if(breather)
		breather.remove_from_mob(contained)
		src.visible_message("<span class='notice'>The mask rapidly retracts just before /the [src] is destroyed!</span>")
	qdel(contained)
	contained = null
	breather = null

	attached = null
	qdel(beaker)
	beaker = null
	return ..()

/obj/structure/medical_stand/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/medical_stand/MouseDrop(var/mob/living/carbon/human/target, src_location, over_location)
	..()
	if(istype(target))
		if(usr.stat == DEAD || !CanMouseDrop(target))
			return
		var/list/available_options = list()
		if (tank)
			available_options += "Gas mask"
		if (beaker)
			available_options += "Drip needle"

		var/action_type
		if(available_options.len > 1)
			action_type = input(usr, "What do you want to attach/detach?") as null|anything in available_options
		else if(available_options.len)
			action_type = available_options[1]
		if(usr.stat == DEAD || !CanMouseDrop(target))
			return
		switch (action_type)
			if("Gas mask")
				if(!can_apply_to_target(target, usr)) // There is no point in attempting to apply a mask if it's impossible.
					return
				if (breather)
					src.add_fingerprint(usr)
					if(!do_mob(usr, target, 30) || !can_apply_to_target(target, usr))
						return
					if(tank)
						tank.forceMove(src)
					if (breather.wear_mask == contained)
						breather.remove_from_mob(contained)
						contained.forceMove(src)
					else
						qdel(contained)
						contained = new mask_type(src)
					breather = null
					src.visible_message("<span class='notice'>\The [contained] slips to \the [src]!</span>")
					update_icon()
					return
				usr.visible_message("<span class='notice'>\The [usr] begins carefully placing the mask onto [target].</span>",
							"<span class='notice'>You begin carefully placing the mask onto [target].</span>")
				if(!do_mob(usr, target, 100) || !can_apply_to_target(target, usr))
					return
				// place mask and add fingerprints
				usr.visible_message("<span class='notice'>\The [usr] has placed \the mask on [target]'s mouth.</span>",
									"<span class='notice'>You have placed \the mask on [target]'s mouth.</span>")
				if(attach_mask(target))
					src.add_fingerprint(usr)
					update_icon()
					START_PROCESSING(SSobj,src)
				return
			if("Drip needle")
				if(attached)
					if(!do_mob(usr, target, 20))
						return
					visible_message("\The [attached] is taken off \the [src]")
					attached = null
				else if(ishuman(target))
					usr.visible_message("<span class='notice'>\The [usr] begins inserting needle into [target]'s vein.</span>",
									"<span class='notice'>You begin inserting needle into [target]'s vein.</span>")
					if(!do_mob(usr, target, 50))
						usr.visible_message("<span class='notice'>\The [usr]'s hand slips and pricks \the [target].</span>",
									"<span class='notice'>Your hand slips and pricks \the [target].</span>")
						target.apply_damage(3, BRUTE, pick(BP_R_ARM, BP_L_ARM))
						return
					usr.visible_message("<span class='notice'>\The [usr] hooks \the [target] up to \the [src].</span>",
									"<span class='notice'>You hook \the [target] up to \the [src].</span>")
					attached = target
					START_PROCESSING(SSobj,src)
				update_icon()


/obj/structure/medical_stand/attack_hand(mob/user as mob)
	var/list/available_options = list()
	if (tank)
		available_options += "Toggle valve"
		available_options += "Remove tank"
	if (beaker)
		available_options += "Remove vessel"

	var/action_type
	if(available_options.len > 1)
		action_type = input(user, "What do you want to do?") as null|anything in available_options
	else if(available_options.len)
		action_type = available_options[1]
	switch (action_type)
		if ("Remove tank")
			if (!tank)
				to_chat(user, "<span class='warning'>There is no tank in \the [src]!</span>")
				return
			else if (tank && is_loosen)
				user.visible_message("<span class='notice'>\The [user] removes \the [tank] from \the [src].</span>", "<span class='warning'>You remove \the [tank] from \the [src].</span>")
				user.put_in_hands(tank)
				tank = null
				update_icon()
				return
			else if (!is_loosen)
				user.visible_message("<span class='notice'>\The [user] tries to removes \the [tank] from \the [src] but it won't budge.</span>", "<span class='warning'>You try to removes \the [tank] from \the [src] but it won't budge.</span>")
				return
		if ("Toggle valve")
			if (!tank)
				to_chat(user, "<span class='warning'>There is no tank in \the [src]!</span>")
				return
			else
				if (valve_opened)
					src.visible_message("<span class='notice'>\The [user] closes valve on \the [src]!</span>",
						"<span class='notice'>You close valve on \the [src].</span>")
					if(breather)
						if(internalsHud)
							internalsHud.icon_state = "internal0"
						breather.internal = null
					valve_opened = FALSE
					update_icon()
				else
					src.visible_message("<span class='notice'>\The [user] opens valve on \the [src]!</span>",
										"<span class='notice'>You open valve on \the [src].</span>")
					if(breather)
						breather.internal = tank
						if(internalsHud)
							internalsHud.icon_state = "internal1"
					valve_opened = TRUE
					playsound(get_turf(src), 'sound/effects/internals.ogg', 100, 1)
					update_icon()
					START_PROCESSING(SSobj,src)
		if ("Remove vessel")
			if(beaker)
				beaker.forceMove(loc)
				beaker = null
				update_icon()

/obj/structure/medical_stand/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle IV Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(usr.incapacitated())
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/structure/medical_stand/verb/set_APTFT()
	set name = "Set IV transfer amount"
	set category = "Object"
	set src in range(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in transfer_amounts
	if(N)
		transfer_amount = N

/obj/structure/medical_stand/proc/attach_mask(var/mob/living/carbon/C)
	if(C && istype(C))
		if(C.equip_to_slot_if_possible(contained, slot_wear_mask))
			if(tank)
				tank.forceMove(C)
			breather = C
			if(breather.HUDneed.Find("internal"))
				internalsHud = breather.HUDneed["internal"]
			return TRUE

/obj/structure/medical_stand/proc/can_apply_to_target(var/mob/living/carbon/human/target, mob/user as mob)
	if(!user)
		user = target
	// Check target validity
	if(!istype(target))
		to_chat(user, "<span class='warning'>\The [target] not compatible with machine.</span>")
		return
	if(!target.organs_by_name[BP_HEAD])
		to_chat(user, "<span class='warning'>\The [target] doesn't have a head.</span>")
		return
	if(!target.check_has_mouth())
		to_chat(user, "<span class='warning'>\The [target] doesn't have a mouth.</span>")
		return
	if(target.wear_mask && target != breather)
		to_chat(user, "<span class='warning'>\The [target] is already wearing a mask.</span>")
		return
	if(target.head && (target.head.body_parts_covered & FACE))
		to_chat(user, "<span class='warning'>Remove their [target.head] first.</span>")
		return
	if(!tank)
		to_chat(user, "<span class='warning'>There is no tank in \the [src].</span>")
		return
	if(is_loosen)
		to_chat(user, "<span class='warning'>Tighten \the nut with a wrench first.</span>")
		return
	if(!Adjacent(target))
		return
	//when there is a breather:
	if(breather && target != breather)
		to_chat(user, "<span class='warning'>\The [src] is already in use.</span>")
		return
	//Checking if breather is still valid
	if(target == breather && target.wear_mask != contained)
		to_chat(user, "<span class='warning'>\The [target] is not using the supplied mask.</span>")
		return
	return 1

/obj/structure/medical_stand/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/tool/wrench))
		if (valve_opened)
			to_chat(user, "<span class='warning'>Close the valve first.</span>")
			return
		if (tank)
			playsound(get_turf(src), 'sound/items/Ratchet.ogg', 80, 1)
			if (!is_loosen)
				is_loosen = TRUE
			else
				is_loosen = FALSE
				if (valve_opened)
					START_PROCESSING(SSobj,src)
			user.visible_message("<span class='notice'>\The [user] [is_loosen == TRUE ? "loosen" : "tighten"] \the nut holding [tank] in place.</span>", "<span class='notice'>You [is_loosen == TRUE ? "loosen" : "tighten"] \the nut holding [tank] in place.</span>")
			return
		else
			to_chat(user, "<span class='warning'>There is no tank in \the [src].</span>")
			return
	else if(istype(W, /obj/item/weapon/tank))
		if(tank)
			to_chat(user, "<span class='warning'>\The [src] already has a tank installed!</span>")
		else if(!is_loosen)
			to_chat(user, "<span class='warning'>Loosen the nut with a wrench first.</span>")
		else
			user.drop_item()
			W.forceMove(src)
			tank = W
			user.visible_message("<span class='notice'>\The [user] attaches \the [tank] to \the [src].</span>", "<span class='notice'>You attach \the [tank] to \the [src].</span>")
			src.add_fingerprint(user)
			update_icon()

	else if (istype(W, /obj/item/weapon/reagent_containers))
		if(!isnull(src.beaker))
			to_chat(user, "There is already a reagent container loaded!")
			return
		user.drop_item()
		W.forceMove(src)
		beaker = W
		to_chat(user, "You attach \the [W] to \the [src].")
		update_icon()
	else
		return ..()

/obj/structure/medical_stand/examine(var/mob/user)
	. = ..()

	if (get_dist(src, user) > 2)
		return

	if(beaker)
		to_chat(user, "The IV drip is [mode ? "injecting" : "taking blood"].")
		to_chat(user, "It is set to transfer [transfer_amount]u of chemicals per cycle.")
		if(beaker.reagents && beaker.reagents.total_volume)
			to_chat(user, "<span class='notice'>Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.</span>")
		else
			to_chat(user, "<span class='notice'>Attached is an empty [beaker].</span>")
		to_chat(user, "<span class='notice'>[attached ? attached : "No one"] is hooked up to it.</span>")
	else
		to_chat(user, "<span class='notice'>There is no vessel.</span>")

	if(tank)
		if (!is_loosen)
			to_chat(user, "\The [tank] connected.")
		to_chat(user, "The meter shows [round(tank.air_contents.return_pressure())]. The valve is [valve_opened == TRUE ? "open" : "closed"].")
		if (tank.distribute_pressure == 0)
			to_chat(user, "Use wrench to replace tank.")
	else
		to_chat(user, "<span class='notice'>There is no tank.</span>")

/obj/structure/medical_stand/Process()
	//Gas Stuff
	if(breather)
		if(!can_apply_to_target(breather))
			if(tank)
				tank.forceMove(src)
			if (breather.wear_mask == contained)
				breather.remove_from_mob(contained)
				contained.forceMove(src)
			else
				qdel(contained)
				contained = new mask_type (src)
			src.visible_message("<span class='notice'>\The [contained] slips to \the [src]!</span>")
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
	else if (valve_opened)
		var/datum/gas_mixture/removed = tank.remove_air(0.01)
		var/datum/gas_mixture/environment = loc.return_air()
		environment.merge(removed)

	//Reagent Stuff
	if(attached)
		if(!Adjacent(attached))
			visible_message("The needle is ripped out of [src.attached], doesn't that hurt?")
			attached.apply_damage(3, BRUTE, pick(BP_R_ARM, BP_L_ARM))
			attached = null
			update_icon()

	if(beaker)
		if(mode) // Give blood
			if(beaker.volume > 0)
				beaker.reagents.trans_to_mob(attached, transfer_amount, CHEM_BLOOD)
				update_icon()
		else // Take blood
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)

			if(amount == 0) // If the beaker is full, ping
				if(prob(5)) visible_message("\The [src] pings.")
				return

			var/mob/living/carbon/human/H = attached
			if(!istype(H))
				return
			if(!H.dna)
				return
			if(NOCLONE in H.mutations)
				return
			if(H.species.flags & NO_BLOOD)
				return
			if(!H.should_have_organ(BP_HEART))
				return

			// If the human is losing too much blood, beep.
			if(H.get_blood_volume() < BLOOD_VOLUME_SAFE * 1.05)
				visible_message("\The [src] beeps loudly.")

			var/datum/reagent/B = H.take_blood(beaker,amount)
			if (B)
				beaker.reagents.reagent_list |= B
				beaker.reagents.update_total()
				beaker.on_reagent_change()
				beaker.reagents.handle_reactions()
				update_icon()

	if ((!valve_opened || tank.distribute_pressure == 0) && !breather && !attached)
		return PROCESS_KILL

/obj/structure/medical_stand/anesthetic
	spawn_type = /obj/item/weapon/tank/anesthetic
	mask_type = /obj/item/clothing/mask/breath/medical
	is_loosen = FALSE

