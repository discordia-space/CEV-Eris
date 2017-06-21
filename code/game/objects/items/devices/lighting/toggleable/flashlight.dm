/obj/item/device/lighting/toggleable/flashlight
	action_button_name = "Toggle Flashlight"
	var/tick_cost = 5
	var/obj/item/weapon/cell/cell = new

/obj/item/device/lighting/toggleable/flashlight/turn_on(mob/user)
	. = ..()
	if(.)
		processing_objects |= src
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/turn_off(mob/user)
	. = ..()
	if(.)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/process()
	if(on)
		if(!cell || !cell.checked_use(tick_cost))
			turn_off()

/obj/item/device/lighting/toggleable/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.targeted_organ == "eyes")

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					user << "<span class='warning'>You're going to need to remove [C.name] first.</span>"
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				user << "<span class='warning'>You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!</span>"

			user.visible_message("<span class='notice'>\The [user] directs [src] to [M]'s eyes.</span>", \
							 	 "<span class='notice'>You direct [src] to [M]'s eyes.</span>")
			if(H == user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					user << "<span class='warning'>\The [M]'s pupils do not react to the light!</span>"
					return
				if(XRAY in M.mutations)
					user << "<span class='notice'>\The [M] pupils give an eerie glow!</span>"
				if(vision.damage)
					user << "<span class='warning'>There's visible damage to [M]'s [vision.name]!</span>"
				else if(M.eye_blurry)
					user << "<span class='notice'>\The [M]'s pupils react slower than normally.</span>"
				if(M.getBrainLoss() > 15)
					user << "<span class='notice'>There's visible lag between left and right pupils' reactions.</span>"

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					user << "<span class='notice'>\The [M]'s pupils are already pinpoint and cannot narrow any more.</span>"
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					user << "<span class='notice'>\The [M]'s pupils narrow slightly, but are still very dilated.</span>"
				else
					user << "<span class='notice'>\The [M]'s pupils narrow.</span>"

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
	w_class = 1

/obj/item/device/lighting/toggleable/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A hand-held heavy-duty light."
	icon_state = "heavyduty"
	brightness_on = 6

/obj/item/device/lighting/toggleable/flashlight/seclite
	name = "security flashlight"
	desc = "A hand-held security flashlight. Very robust."
	icon_state = "seclite"
	brightness_on = 5
	force = WEAPON_FORCE_NORMAL
	hitsound = 'sound/weapons/genhit1.ogg'