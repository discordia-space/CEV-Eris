/*
 * Trays - Agouri
 */
/obj/item/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	desc = "A69etal tray to lay food on."
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	flags = CONDUCT
	matter = list(MATERIAL_STEEL = 3)
	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 10

/obj/item/tray/attack(mob/living/carbon/M,69ob/living/carbon/user)

	// Drop all the things. All of them.
	overlays.Cut()
	for(var/obj/item/I in carrying)
		I.loc =69.loc
		carrying.Remove(I)
		if(isturf(I.loc))
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))


	if((CLUMSY in user.mutations) && prob(50))              //What if he's a clown?
		to_chat(M, SPAN_WARNING("You accidentally slam yourself with the 69src69!"))
		M.Weaken(1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			return
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1) //sound playin'
			return //it always returns, but I feel like adding an extra return just for safety's sakes. EDIT; Oh well I won't :3

	var/mob/living/carbon/human/H =69      ///////////////////////////////////// /Let's have this ready for later.


	if(!(user.targeted_organ in list(BP_EYES, BP_HEAD))) //////////////hitting anything else other than the eyes
		if(prob(33))
			src.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)     ///Plik plik, the sound of blood

		M.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been attacked with 69src.name69 by 69user.name69 (69user.ckey69)</font>")
		user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Used the 69src.name69 to attack 69M.name69 (69M.ckey69)</font>")
		msg_admin_attack("69user.name69 (69user.ckey69) used the 69src.name69 to attack 69M.name69 (69M.ckey69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")

		if(prob(15))
			M.Weaken(3)
			M.take_organ_damage(3)
		else
			M.take_organ_damage(5)
		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in69iewers(M, null))
				O.show_message(SPAN_DANGER("69user69 slams 69M69 with the tray!"), 1)
			return
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //we applied the damage, we played the sound, we showed the appropriate69essages. Time to return and stop the proc
			for(var/mob/O in69iewers(M, null))
				O.show_message(SPAN_DANGER("69user69 slams 69M69 with the tray!"), 1)
			return


	var/protected = 0
	for(var/slot in list(slot_head, slot_wear_mask, slot_glasses))
		var/obj/item/protection =69.get_e69uipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & FACE))
			protected = 1
			break

	if(protected)
		to_chat(M, SPAN_WARNING("You get slammed in the face with the tray, against your69ask!"))
		if(prob(33))
			src.add_blood(H)
			if (H.wear_mask)
				H.wear_mask.add_blood(H)
			if (H.head)
				H.head.add_blood(H)
			if (H.glasses && prob(33))
				H.glasses.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))     //Addin' blood! At least on the floor and item :v
				location.add_blood(H)

		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in69iewers(M, null))
				O.show_message(SPAN_DANGER("69user69 slams 69M69 with the tray!"), 1)
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin'
			for(var/mob/O in69iewers(M, null))
				O.show_message(SPAN_DANGER("69user69 slams 69M69 with the tray!"), 1)
		if(prob(10))
			M.Stun(rand(1,3))
			M.take_organ_damage(3)
			return
		else
			M.take_organ_damage(5)
			return

	else //No eye or head protection, tough luck!
		to_chat(M, SPAN_WARNING("You get slammed in the face with the tray!"))
		if(prob(33))
			src.add_blood(M)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)

		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in69iewers(M, null))
				O.show_message(SPAN_DANGER("69user69 slams 69M69 in the face with the tray!"), 1)
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin' again
			for(var/mob/O in69iewers(M, null))
				O.show_message(SPAN_DANGER("69user69 slams 69M69 in the face with the tray!"), 1)
		if(prob(30))
			M.Stun(rand(2,4))
			M.take_organ_damage(4)
			return
		else
			M.take_organ_damage(8)
			if(prob(30))
				M.Weaken(2)
				return
			return

/obj/item/tray/var/cooldown = 0	//shield bash cooldown. based on world.time

/obj/item/tray/attackby(obj/item/W,69ob/user)
	if(istype(W, /obj/item/material/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("69user69 bashes 69src69 with 69W69!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/*
===============~~~~~================================~~~~~====================
=																			=
=  Code for trays carrying things. By Doohl for Doohl erryday Doohl Doohl~  =
=																			=
===============~~~~~================================~~~~~====================
*/
/obj/item/tray/proc/calc_carry()
	// calculate the weight of the items on the tray
	var/val = 0 //69alue to return

	for(var/obj/item/I in carrying)
		if(I.w_class == ITEM_SIZE_TINY)
			val ++
		else if(I.w_class == ITEM_SIZE_SMALL)
			val += 3
		else
			val += 5

	return69al

/obj/item/tray/pre_pickup(mob/user)
	if(!isturf(loc))
		return ..()

	for(var/obj/item/I in loc)
		if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
			var/add = 0
			if(I.w_class == ITEM_SIZE_TINY)
				add = 1
			else if(I.w_class == ITEM_SIZE_SMALL)
				add = 3
			else
				add = 5
			if(calc_carry() + add >=69ax_carry)
				break

			I.loc = src
			carrying.Add(I)
			overlays += image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer, "pixel_x" = I.pixel_x, "pixel_y" = I.pixel_y)

	return ..()

/obj/item/tray/dropped(mob/user)

	spawn(1) //why sleep 1? Because forceMove first drops us on the ground.
		if(!isturf(loc)) //to handle hand switching
			return

		var/foundtable = 0
		for(var/obj/structure/table/T in loc)
			foundtable = 1
			break

		overlays.Cut()

		for(var/obj/item/I in carrying)
			I.loc = loc
			carrying.Remove(I)
			if(!foundtable && isturf(loc))
			// if no table, presume that the person just shittily dropped the tray on the ground and69ade a69ess everywhere!
				spawn()
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))