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
	var/obj/item/clothing/has_suit		//the suit the tie may be attached to
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

		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_tie" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_tie"
		inv_overlay = image(icon = mob_overlay.icon, icon_state = tmp_icon_state, dir = SOUTH)
	return inv_overlay

/obj/item/clothing/accessory/proc/get_mob_overlay()
	if(!mob_overlay)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_mob" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_mob"
			mob_overlay = image("icon" = icon_override, "icon_state" = "[tmp_icon_state]")
		else
			mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "[tmp_icon_state]")
	return mob_overlay

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.overlays += get_inv_overlay()

	to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [has_suit]."))
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
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
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
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
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
				if(M.species && M.species.has_process[OP_HEART])
					var/obj/item/organ/internal/heart/heart = M.random_organ_by_process(OP_HEART)
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
								var/obj/item/organ/internal/heart/heart = M.random_organ_by_process(OP_HEART)
								if(!heart)
									return
								if(heart.is_bruised() || M.getOxyLoss() > 50)
									sound = "[pick("odd noises in","weak")] heartbeat"
								else
									sound = "healthy heartbeat"

							if(!(M.organ_list_by_process(OP_LUNGS).len) || M.losebreath)
								sound += " and no respiration"
							else if(M.getOxyLoss() > 50)
								sound += " and [pick("wheezing","gurgling")] sounds"
							else
								sound += " and healthy respiration"
						if(BP_EYES, BP_MOUTH)
							sound_strength = "cannot hear"
							sound = "anything"
						else
							if(heartbeat)
								sound_strength = "hear a weak"
								sound = "pulse"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
	return ..(M,user)


//Medals
/obj/item/clothing/accessory/medal
	name = "bronze medal"
	desc = "A bronze medal."
	icon_state = "bronze"
	price_tag = 250

/obj/item/clothing/accessory/medal/conduct
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is most basic award on offer. It is often awarded by a captain to a member of their crew."

/obj/item/clothing/accessory/medal/bronze_heart
	name = "bronze heart medal"
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/nobel_science
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"
	price_tag = 500

/obj/item/clothing/accessory/medal/silver/valor
	name = "medal of valor"
	desc = "A silver medal awarded for acts of exceptional valor."

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff."

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"
	price_tag = 1000

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain, and their undisputable authority over their crew."

/obj/item/clothing/accessory/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by company officials. To recieve such a medal is the highest honor and as such, very few exist. This medal is almost never awarded to anybody but commanders."

/obj/item/clothing/accessory/armor
	name = "armor plates"
	desc = "Plates from an armored vest, now usable to reinforce clothes."
	slot = "armor"
	icon_state = "armor"
	w_class = ITEM_SIZE_NORMAL
	isRemovable = FALSE
	armor = list(
		melee = 7,
		bullet = 7,
		energy = 7,
		bomb = 50,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 8,
		MATERIAL_PLASTEEL = 1
	)
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/accessory/armor/on_attached()
	..()
	has_suit.armor = armor
	has_suit.style -= 2
	has_suit.slowdown += slowdown
	has_suit.body_parts_covered = UPPER_TORSO|LOWER_TORSO // Tears up the clothes

/obj/item/clothing/accessory/armor/bullet
	name = "bulletproof armor plates"
	desc = "Plates from a bulletproof vest, now usable to reinforce clothes."
	icon_state = "armor_bullet"
	armor = list(
		melee = 5,
		bullet = 11,
		energy = 5,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 10,
		MATERIAL_PLASTEEL = 3
	)
	slowdown = LIGHT_SLOWDOWN

/obj/item/clothing/accessory/armor/platecarrier
	name = "platecarrier armor plates"
	desc = "Plates from a platecarrier, now usable to reinforce clothes."
	icon_state = "armor_platecarrier"
	armor = list(
		melee = 5,
		bullet = 10,
		energy = 0,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	matter = list(
		MATERIAL_STEEL = 10,
		MATERIAL_PLASTEEL = 3
	)

/obj/item/clothing/accessory/armor/riot
	name = "padded armor plates"
	desc = "Plates from riot armor, now usable to reinforce clothes."
	icon_state = "armor_riot"
	armor = list(
		melee = 13,
		bullet = 6,
		energy = 6,
		bomb = 50,
		bio = 0,
		rad = 0
	)
	slowdown = MEDIUM_SLOWDOWN

/obj/item/clothing/accessory/armor/laser
	name = "ablative armor plates"
	desc = "Sheets from ablative armor, now usable to reinforce clothes. The shape somehow feels off."
	icon_state = "armor_ablative"
	armor = list(
		melee = 5,
		bullet = 5,
		energy = 10,
		bomb = 0,
		bio = 0,
		rad = 0
	)

//Ponchos, Capes and Cloaks//

/obj/item/clothing/accessory/cloak
	name = "oversized poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. More of a fashion statement than anything else."
	icon_state = "oversized_poncho"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/ponchoblue
	name = "blue oversized poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. The tactical choice."
	icon_state = "oversized_poncho_blue"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/ponchored
	name = "red oversized poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. Good for hiding bloodstains."
	icon_state = "oversized_poncho_red"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/ponchogreen
	name = "green oversized poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. The roach guts blend right in."
	icon_state = "oversized_poncho_green"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/ponchopurple
	name = "purple oversized poncho"
	desc = "Meant to be worn over a voidsuit or smaller rigs. For someone wearing a glorified sack, you feel quite regal."
	icon_state = "oversized_poncho_purple"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/ponchoash
	name = "ash oversized poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. Good for stalking the tunnels."
	icon_state = "oversized_poncho_ash"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/ponchowhite
	name = "white oversized poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. A bold move considering how filthy the ship gets."
	icon_state = "oversized_poncho_white"
	slot_flags = SLOT_ACCESSORY_BUFFER

/obj/item/clothing/accessory/cloak/clowncho
	name = "clown poncho"
	desc = "Able to be worn over a voidsuit or smaller rigs. This is certainly a choice."
	icon_state = "clowncho"
	slot_flags = SLOT_ACCESSORY_BUFFER
	style = STYLE_NEG_HIGH
