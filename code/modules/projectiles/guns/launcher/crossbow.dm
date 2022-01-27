//AMMUNITION

/obj/item/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	throwforce = 8
	w_class = ITEM_SIZE_NORMAL
	sharp = TRUE
	edge = FALSE

/obj/item/arrow/proc/removed() //Helper for69etal rods falling apart.
	return

/obj/item/spike
	name = "alloy spike"
	desc = "A foot-long pointed stick69ade of a strange, silvery69etal."
	sharp = TRUE
	edge = FALSE
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"

/obj/item/arrow/69uill
	name = "vox 69uill"
	desc = "An alien-looking barbed 69uill plucked from who-knows-what kind of creature. It69ight work as a crossbow projectile."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "69uill"
	item_state = "69uill"
	throwforce = 5

/obj/item/arrow/rod
	name = "metal rod"
	desc = "A projectile for a crossbow. Don't cry for69e, Orithena."
	icon_state = "metal-rod"

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, "69src69 shatters into dozens of superheated69etal shards as soon as it is launched from the crossbow!")
		var/obj/item/material/shard/shrapnel/S =69ew()
		S.loc = get_turf(src)
		69del(src)

/obj/item/gun/launcher/crossbow
	name = "powered crossbow"
	desc = "A 2557AD twist on an old classic. Pick up that can."
	icon = 'icons/obj/guns/launcher/crossbow-solid.dmi'
	icon_state = "crossbow"
	item_state = "crossbow-solid"
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK69oise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK
	restrict_safety = TRUE
	twohanded = TRUE
	rarity_value = 35//no price tag,then high rarirty

	var/obj/item/bolt
	var/tension = 0						// Current draw on the bow.
	var/max_tension = 5					// Highest possible tension.
	var/release_speed = 5				// Speed per unit of tension.
	var/obj/item/cell/large/cell	// Used for firing superheated rods.
	var/current_user					// Used to check if the crossbow has changed hands since being drawn.
	var/draw_time = 20					// How long it takes to increase the draw on the bow by one "tension"

/obj/item/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/launcher/crossbow/consume_next_projectile(mob/user)
	if(tension <= 0)
		to_chat(user, SPAN_WARNING("\The 69src69 is69ot drawn back!"))
		return69ull
	return bolt

/obj/item/gun/launcher/crossbow/handle_post_fire(mob/user, atom/target)
	bolt =69ull
	tension = 0
	update_icon()
	..()

/obj/item/gun/launcher/crossbow/attack_self(mob/living/user)
	if(tension)
		if(bolt)
			user.visible_message("69user69 relaxes the tension on 69src69's string and removes 69bolt69.","You relax the tension on 69src69's string and remove 69bolt69.")
			bolt.loc = get_turf(src)
			var/obj/item/arrow/A = bolt
			bolt =69ull
			A.removed(user)
		else
			user.visible_message("69user69 relaxes the tension on 69src69's string.","You relax the tension on 69src69's string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/proc/draw(mob/user)

	if(!bolt)
		to_chat(user, "You don't have anything69ocked to 69src69.")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("69user69 begins to draw back the string of 69src69.",SPAN_NOTICE("You begin to draw back the string of 69src69."))
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time, src)) //crossbow strings don't just69agically pull back on their own.
			user.visible_message("69usr69 stops drawing and relaxes the string of 69src69.",SPAN_WARNING("You stop drawing back and relax the string of 69src69."))
			tension = 0
			update_icon()
			return

		//double check that the user hasn't removed the bolt in the69eantime
		if(!(bolt && tension && loc == current_user))
			return

		tension++
		update_icon()

		if(tension >=69ax_tension)
			tension =69ax_tension
			to_chat(user, "69src69 gives a satisfying clunk as the string is pulled back as far as it can go!")
			return

		user.visible_message("69usr69 draws back the string of 69src69!",SPAN_NOTICE("You continue drawing back the string of 69src69!"))

/obj/item/gun/launcher/crossbow/proc/increase_tension(mob/user)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return


/obj/item/gun/launcher/crossbow/attackby(obj/item/I,69ob/user)
	if(!bolt)
		if (istype(I,/obj/item/arrow))
			user.drop_from_inventory(I, src)
			bolt = I
			user.visible_message("69user69 slides 69bolt69 into 69src69.","You slide 69bolt69 into 69src69.")
			update_icon()
			return
		else if(istype(I,/obj/item/stack/rods))
			var/obj/item/stack/rods/R = I
			if (R.use(1))
				bolt =69ew /obj/item/arrow/rod(src)
				bolt.fingerprintslast = fingerprintslast
				bolt.loc = src
				update_icon()
				user.visible_message("69user69 jams 69bolt69 into 69src69.","You jam 69bolt69 into 69src69.")
				superheat_rod(user)
			return

	if(istype(I, /obj/item/cell/large))
		if(!cell)
			user.drop_item()
			cell = I
			cell.loc = src
			to_chat(user, SPAN_NOTICE("You jam 69cell69 into 69src69 and wire it to the firing coil."))
			superheat_rod(user)
		else
			to_chat(user, SPAN_NOTICE("69src69 already has a cell installed."))

	else if(I.get_tool_type(usr, list(69UALITY_SCREW_DRIVING), src))
		if(cell)
			var/obj/item/C = cell
			C.loc = get_turf(user)
			to_chat(user, SPAN_NOTICE("You jimmy 69cell69 out of 69src69 with 69I69."))
			cell =69ull
		else
			to_chat(user, SPAN_NOTICE("69src69 doesn't have a cell installed."))

	else
		..()

/obj/item/gun/launcher/crossbow/proc/superheat_rod(mob/user)
	if(!user || !cell || !bolt) return
	if(!cell.check_charge(500)) return
	if(bolt.throwforce >= 15) return
	if(!istype(bolt,/obj/item/arrow/rod)) return

	to_chat(user, SPAN_NOTICE("69bolt69 sparks and crackles as it gives off a red-hot glow."))
	bolt.throwforce = 15
	bolt.icon_state = "metal-rod-superheated"
	cell.use(500)

/obj/item/gun/launcher/crossbow/update_icon()
	if(tension > 1)
		icon_state = "crossbow-drawn"
	else if(bolt)
		icon_state = "crossbow-nocked"
	else
		icon_state = "crossbow"

/*////////////////////////////
//	Rapid Crossbow Device	//
*/////////////////////////////
/obj/item/arrow/RCD
	name = "flashforged bolt"
	desc = "The ultimate ghetto 'deconstruction' implement."
	throwforce = 6

/obj/item/gun/launcher/crossbow/RCD
	name = "rapid crossbow device"
	desc = "A hacked together RCD turns an innocent construction tool into the penultimate 'deconstruction' tool. Flashforges projectiles using69atter units when the string is drawn back."
	icon = 'icons/obj/guns/launcher/rxb.dmi'
	icon_state = "rxb"
	slot_flags =69ull
	draw_time = 5
	spawn_blacklisted = TRUE
	var/stored_matter = 0
	var/max_stored_matter = 60
	var/boltcost = 5

/obj/item/gun/launcher/crossbow/RCD/proc/genBolt(mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt =69ew/obj/item/arrow/RCD(src)
		stored_matter -= boltcost
		to_chat(user, "<span class='notice'>The RXD flashforges a69ew bolt!</span>")
		update_icon()
	else
		to_chat(user, "<span class='warning'>The \'Low Ammo\' light on the device blinks yellow.</span>")
		flick("69icon_state69-empty", src)

/obj/item/gun/launcher/crossbow/RCD/attack_self(mob/living/user)
	if(tension)
		user.visible_message("69user69 relaxes the tension on 69src69's string.","You relax the tension on 69src69's string.")
		tension = 0
		update_icon()
	else
		genBolt(user)
		draw(user)

/obj/item/gun/launcher/crossbow/RCD/attackby(obj/item/W,69ob/user)
	var/obj/item/stack/material/M = W
	if(istype(M) &&69.material.name ==69ATERIAL_COMPRESSED)
		var/amount =69in(M.get_amount(), round(max_stored_matter - stored_matter))
		if(M.use(amount) && stored_matter <69ax_stored_matter)
			stored_matter += amount
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You load 69amount69 Compressed69atter into \the 69src69</span>.")
			update_icon()	//Updates the ammo counter
	else
		..()
	if(istype(W, /obj/item/arrow/RCD))
		var/obj/item/arrow/RCD/A = W
		if((stored_matter + 5) >69ax_stored_matter)
			to_chat(user, "<span class='notice'>Unable to reclaim flashforged bolt. The RXD can't hold that69any additional69atter-units.</span>")
			return
		stored_matter += 5
		69del(A)
		playsound(loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>Flashforged bolt reclaimed. The RXD69ow holds 69stored_matter69/69max_stored_matter6969atter-units.</span>")
		update_icon()
		return

/obj/item/gun/launcher/crossbow/RCD/update_icon()
	cut_overlays()
	if(bolt)
		overlays += "rxb-bolt"
	var/ratio = 0
	if(stored_matter < boltcost)
		ratio = 0
	else
		ratio = stored_matter /69ax_stored_matter
		ratio =69ax(round(ratio, 0.25) * 100, 25)
	overlays += "rxb-69ratio69"
	if(tension > 1)
		icon_state = "rxb-drawn"
	else
		icon_state = "rxb"

/obj/item/gun/launcher/crossbow/RCD/examine(user)
	if(..(user, 0))
		to_chat(user, "It currently holds 69stored_matter69/69max_stored_matter69 Compressed69atter.")


/obj/item/arrow/ironrod
	name = "iron rod"
	desc = "The ultimate ghetto 'deconstruction' implement."
	throwforce = 6
