/obj/item/device/lighting/toggleable/flashlight
	action_button_name = "Toggle Flashlight"
	var/tick_cost = 0.5
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small

/obj/item/device/lighting/toggleable/flashlight/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/device/lighting/toggleable/flashlight/turn_on(mob/user)
	if(!cell || !cell.check_charge(tick_cost))
		playsound(loc, 'sound/machines/button.ogg', 50, 1)
		user << SPAN_WARNING("[src] battery is dead or missing.")
		return FALSE
	. = ..()
	if(. && user)
		START_PROCESSING(SSobj, src)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/turn_off(mob/user)
	. = ..()
	if(. && user)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/Process()
	if(on)
		if(!cell || !cell.checked_use(tick_cost))
			if(ismob(src.loc))
				src.loc << SPAN_WARNING("Your flashlight dies. You are alone now.")
			turn_off()

/obj/item/device/lighting/toggleable/flashlight/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/lighting/toggleable/flashlight/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

/obj/item/device/lighting/toggleable/flashlight/attack(mob/living/M, mob/living/user)
	add_fingerprint(user)
	if(on && user.targeted_organ == O_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					user << SPAN_WARNING("You're going to need to remove [C.name] first.")
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				user << "<span class='warning'>You can't find any [H.species.vision_organ ? H.species.vision_organ : O_EYES] on [H]!</span>"

			user.visible_message(SPAN_NOTICE("\The [user] directs [src] to [M]'s eyes."), \
							 	 SPAN_NOTICE("You direct [src] to [M]'s eyes."))
			if(H == user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					user << SPAN_WARNING("\The [M]'s pupils do not react to the light!")
					return
				if(XRAY in M.mutations)
					user << SPAN_NOTICE("\The [M] pupils give an eerie glow!")
				if(vision.damage)
					user << SPAN_WARNING("There's visible damage to [M]'s [vision.name]!")
				else if(M.eye_blurry)
					user << SPAN_NOTICE("\The [M]'s pupils react slower than normally.")
				if(M.getBrainLoss() > 15)
					user << SPAN_NOTICE("There's visible lag between left and right pupils' reactions.")

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					user << SPAN_NOTICE("\The [M]'s pupils are already pinpoint and cannot narrow any more.")
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					user << SPAN_NOTICE("\The [M]'s pupils narrow slightly, but are still very dilated.")
				else
					user << SPAN_NOTICE("\The [M]'s pupils narrow.")

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			if(M.HUDtech.Find("flash"))
				flick("flash", M.HUDtech["flash"])
	else
		return ..()





/obj/item/device/lighting/toggleable/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	slot_flags = SLOT_EARS
	brightness_on = 2
	w_class = ITEM_SIZE_TINY

/obj/item/device/lighting/toggleable/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A hand-held heavy-duty light."
	icon_state = "heavyduty"
	item_state = "heavyduty"
	brightness_on = 6
	tick_cost = 1
	suitable_cell = /obj/item/weapon/cell/medium

/obj/item/device/lighting/toggleable/flashlight/seclite
	name = "Ironhammer flashlight"
	desc = "A hand-held security flashlight."
	icon_state = "seclite"
	item_state = "seclite"
