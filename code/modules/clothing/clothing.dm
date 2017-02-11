/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	var/flash_protection = FLASH_PROTECTION_NONE	// Sets the item's level of flash protection.
	var/tint = TINT_NONE							// Sets the item's level of visual impairment tint.
	var/list/species_restricted = null				// Only these species can wear this kit.
	var/gunshot_residue								// Used by forensics.
	var/initial_name = "clothing"					// For coloring

	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots

//Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	..()
	gunshot_residue = null

///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !istype(user,/mob/living/carbon/human))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = 5.0
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	New(var/obj/O)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		set_dir(O.dir)

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	body_parts_covered = EYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.75
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/clipped = 0
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		if (clipped)
			user << "<span class='notice'>The [src] have already been clipped!</span>"
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("\red [user] cuts the fingertips off of the [src].","\red You cut the fingertips off of the [src].")

		clipped = 1
		name = "modified [name]"
		desc = "[desc]<br>They have had the fingertips cut off of them."
		return

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = 2.0

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]"
			return
		on = !on
		user << "You [on ? "enable" : "disable"] the helmet light."
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(var/mob/user)
	if(!istype(user) || !mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(istype(user, /mob/living/silicon/robot/drone))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		user << "<span class='warning'>You are already wearing a hat.</span>"
	else if(success == 1)
		user << "<span class='notice'>You crawl under \the [src].</span>"
	return 1

/obj/item/clothing/head/update_icon(var/mob/user)

	overlays.Cut()
	var/mob/living/carbon/human/H
	if(istype(user,/mob/living/carbon/human))
		H = user

	if(on)

		// Generate object icon.
		if(!light_overlay_cache["[light_overlay]_icon"])
			light_overlay_cache["[light_overlay]_icon"] = image('icons/obj/light_overlays.dmi', light_overlay)
		overlays |= light_overlay_cache["[light_overlay]_icon"]

		// Generate and cache the on-mob icon, which is used in update_inv_head().
		var/cache_key = "[light_overlay][H ? "_[H.species.get_bodytype()]" : ""]"
		if(!light_overlay_cache[cache_key])
			light_overlay_cache[cache_key] = image('icons/mob/light_overlays.dmi', light_overlay)

	if(H)
		H.update_inv_head()

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	var/can_hold_knife
	var/obj/item/holding

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	force = 2
	var/overshoes = 0

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "IC"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	holding.forceMove(get_turf(usr))

	if(usr.put_in_hands(holding))
		usr.visible_message("<span class='danger'>\The [usr] pulls a knife out of their boot!</span>")
		holding = null
	else
		usr << "<span class='warning'>Your need an empty, unbroken hand to do that.</span>"
		holding.forceMove(src)

	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	update_icon()
	return


/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(can_hold_knife && istype(I, /obj/item/weapon/material/shard) || \
	 istype(I, /obj/item/weapon/material/butterfly) || \
	 istype(I, /obj/item/weapon/material/kitchen/utensil) || \
	 istype(I, /obj/item/weapon/material/hatchet/tacknife))
		if(holding)
			user << "<span class='warning'>\The [src] is already holding \a [holding].</span>"
			return
		user.unEquip(I)
		I.forceMove(src)
		holding = I
		user.visible_message("<span class='notice'>\The [user] shoves \the [I] into \the [src].</span>")
		verbs |= /obj/item/clothing/shoes/proc/draw_knife
		update_icon()
	else
		return ..()

/obj/item/clothing/shoes/update_icon()
	overlays.Cut()
	if(holding)
		overlays += image(icon, "[icon_state]_knife")
	return ..()

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = 3

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	w_class = 3
	var/has_sensor = 1 //For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1

	//convenience var for defining the icon state for the overlay used when the clothing is worn.

	valid_accessory_slots = list("utility","armband","decor")
	restricted_accessory_slots = list("utility", "armband")


/obj/item/clothing/under/attack_hand(var/mob/user)
	if(accessories && accessories.len)
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/New()
	..()
	item_state_slots[slot_w_uniform_str] = icon_state //TODO: drop or gonna use it?

/obj/item/clothing/under/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform()


/obj/item/clothing/under/examine(mob/user)
	..(user)
	switch(src.sensor_mode)
		if(0)
			user << "Its sensors appear to be disabled."
		if(1)
			user << "Its binary life sensors appear to be enabled."
		if(2)
			user << "Its vital tracker appears to be enabled."
		if(3)
			user << "Its vital tracker and tracking beacon appear to be enabled."

/obj/item/clothing/under/proc/set_sensors(var/mob/M)
	if(has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0

	if(sensor_mode == 3)
		sensor_mode = 0
	else
		sensor_mode++

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				usr << "You disable your suit's remote sensing equipment."
			if(1)
				usr << "Your suit will now report whether you are live or dead."
			if(2)
				usr << "Your suit will now report your vital lifesigns."
			if(3)
				usr << "Your suit will now report your vital lifesigns as well as your coordinate position."
	else if (istype(src.loc, /mob))
		switch(sensor_mode)
			if(0)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("\red [usr] disables [src.loc]'s remote sensing equipment.", 1)
			if(1)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] turns [src.loc]'s remote sensors to binary.", 1)
			if(2)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to track vitals.", 1)
			if(3)
				for(var/mob/V in viewers(usr, 1))
					V.show_message("[usr] sets [src.loc]'s sensors to maximum.", 1)


/obj/item/clothing/under/rank/New()
	sensor_mode = 3
	..()

/obj/item/clothing/under/rank/attackby(var/obj/item/I, var/mob/U)
	if(istype(I, /obj/item/weapon/screwdriver) && istype(U, /mob/living/carbon/human))
		set_sensors(U)
	else
		return ..()