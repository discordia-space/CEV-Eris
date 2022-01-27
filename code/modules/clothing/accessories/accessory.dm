/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/inventory/accessory/icon.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	slot_flags = SLOT_ACCESSORY_BUFFER
	w_class = ITEM_SIZE_SMALL
	bad_type = /obj/item/clothing/accessory
	var/slot = "decor"
	var/obj/item/clothing/has_suit		//the suit the tie69ay be attached to
	var/image/inv_overlay	//overlay used when attached to clothing.
	var/image/mob_overlay
	var/overlay_state
	var/isRemovable = TRUE

/obj/item/clothing/accessory/Destroy()
	if(has_suit)
		on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		if(!mob_overlay)
			get_mob_overlay()

		var/tmp_icon_state = "69overlay_state? "69overlay_state69" : "69icon_state69"69"
		if(icon_override)
			if("69tmp_icon_state69_tie" in icon_states(icon_override))
				tmp_icon_state = "69tmp_icon_state69_tie"
		inv_overlay = image(icon =69ob_overlay.icon, icon_state = tmp_icon_state, dir = SOUTH)
	return inv_overlay

/obj/item/clothing/accessory/proc/get_mob_overlay()
	if(!mob_overlay)
		var/tmp_icon_state = "69overlay_state? "69overlay_state69" : "69icon_state69"69"
		if(icon_override)
			if("69tmp_icon_state69_mob" in icon_states(icon_override))
				tmp_icon_state = "69tmp_icon_state69_mob"
			mob_overlay = image("icon" = icon_override, "icon_state" = "69tmp_icon_state69")
		else
			mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "69tmp_icon_state69")
	return69ob_overlay

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S,69ar/mob/user)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.overlays += get_inv_overlay()

	to_chat(user, SPAN_NOTICE("You attach \the 69src69 to \the 69has_suit69."))
	src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		src.forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I,69ob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as69ob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/accessory/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated69edical apparatus for listening to the sounds of the human body. It also69akes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M,69ob/living/user)
	// TODO: baymed, rework this to use something like get_heartbeat()
	if(ishuman(M) && isliving(user))
		if(user.a_intent == I_HELP)
			var/body_part = parse_zone(user.targeted_organ)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)	their = "his"
					if(FEMALE)	their = "her"

				var/sound = "heartbeat"
				var/sound_strength = "cannot hear"
				var/heartbeat = 0
				if(M.species &&69.species.has_process69OP_HEART69)
					var/obj/item/organ/internal/heart/heart =69.random_organ_by_process(OP_HEART)
					if(heart && !BP_IS_ROBOTIC(heart))
						heartbeat = 1
				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					switch(body_part)
						if(BP_CHEST)
							sound_strength = "hear"
							sound = "no heartbeat"
							if(heartbeat)
								var/obj/item/organ/internal/heart/heart =69.random_organ_by_process(OP_HEART)
								if(!heart)
									return
								if(heart.is_bruised() ||69.getOxyLoss() > 50)
									sound = "69pick("odd noises in","weak")69 heartbeat"
								else
									sound = "healthy heartbeat"

							if(!(M.organ_list_by_process(OP_LUNGS).len) ||69.losebreath)
								sound += " and no respiration"
							else if(M.is_lung_ruptured() ||69.getOxyLoss() > 50)
								sound += " and 69pick("wheezing","gurgling")69 sounds"
							else
								sound += " and healthy respiration"
						if(BP_EYES, BP_MOUTH)
							sound_strength = "cannot hear"
							sound = "anything"
						else
							if(heartbeat)
								sound_strength = "hear a weak"
								sound = "pulse"

				user.visible_message("69user69 places 69src69 against 69M69's 69body_part69 and listens attentively.", "You place 69src69 against 69their69 69body_part69. You 69sound_strength69 69sound69.")
	return ..(M,user)


//Medals
/obj/item/clothing/accessory/medal
	name = "bronze69edal"
	desc = "A bronze69edal."
	icon_state = "bronze"
	price_tag = 250

/obj/item/clothing/accessory/medal/conduct
	name = "distinguished conduct69edal"
	desc = "A bronze69edal awarded for distinguished conduct. Whilst a great honor, this is69ost basic award on offer. It is often awarded by a captain to a69ember of their crew."

/obj/item/clothing/accessory/medal/bronze_heart
	name = "bronze heart69edal"
	desc = "A bronze heart-shaped69edal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/nobel_science
	name = "nobel sciences award"
	desc = "A bronze69edal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/silver
	name = "silver69edal"
	desc = "A silver69edal."
	icon_state = "silver"
	price_tag = 500

/obj/item/clothing/accessory/medal/silver/valor
	name = "medal of69alor"
	desc = "A silver69edal awarded for acts of exceptional69alor."

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff."

/obj/item/clothing/accessory/medal/gold
	name = "gold69edal"
	desc = "A prestigious golden69edal."
	icon_state = "gold"
	price_tag = 1000

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden69edal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain, and their undisputable authority over their crew."

/obj/item/clothing/accessory/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden69edal awarded only by company officials. To recieve such a69edal is the highest honor and as such,69ery few exist. This69edal is almost never awarded to anybody but commanders."

/obj/item/clothing/accessory/armor
	name = "armor plates"
	desc = "Plates from an armored69est, now usable to reinforce clothes."
	slot = "armor"
	icon_state = "armor"
	w_class = ITEM_SIZE_NORMAL
	isRemovable = FALSE
	armor = list(
		melee = 30,
		bullet = 30,
		energy = 30,
		bomb = 5,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 8,
		MATERIAL_PLASTEEL = 1,
	)
	slowdown = 0
	stiffness = LIGHT_STIFFNESS

/obj/item/clothing/accessory/armor/on_attached()
	..()
	has_suit.armor = armor
	has_suit.style -= 2
	has_suit.slowdown = slowdown
	has_suit.stiffness = stiffness
	has_suit.body_parts_covered = UPPER_TORSO|LOWER_TORSO // Tears up the clothes

/obj/item/clothing/accessory/armor/bullet
	name = "bulletproof armor plates"
	desc = "Plates from a bulletproof69est, now usable to reinforce clothes."
	icon_state = "armor_bullet"
	armor = list(
		melee = 20,
		bullet = 45,
		energy = 20,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 10,
		MATERIAL_PLASTEEL = 3,
	)
	slowdown = LIGHT_SLOWDOWN
	stiffness =69EDIUM_STIFFNESS

/obj/item/clothing/accessory/armor/platecarrier
	name = "platecarrier armor plates"
	desc = "Plates from a platecarrier, now usable to reinforce clothes."
	icon_state = "armor_platecarrier"
	armor = list(
		melee = 20,
		bullet = 40,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 10,
		MATERIAL_PLASTEEL = 3,
	)
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/accessory/armor/riot
	name = "padded armor plates"
	desc = "Plates from riot armor, now usable to reinforce clothes."
	icon_state = "armor_riot"
	armor = list(
		melee = 50,
		bullet = 25,
		energy = 25,
		bomb = 15,
		bio = 0,
		rad = 0
	)
	slowdown =69EDIUM_SLOWDOWN
	stiffness =69EDIUM_STIFFNESS

/obj/item/clothing/accessory/armor/laser
	name = "ablative armor plates"
	desc = "Sheets from ablative armor, now usable to reinforce clothes. The shape somehow feels off."
	icon_state = "armor_ablative"
	armor = list(
		melee = 20,
		bullet = 20,
		energy = 40,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	slowdown = LIGHT_SLOWDOWN
