//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"

	heat_protection = HEAD
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void
	name = "voidsuit"
	icon_state = "void"
	item_state = "void"
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	slowdown = 1
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	allowed = list(/obj/item/device/lighting/toggleable/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 18
	can_breach = 1

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.
	var/obj/item/weapon/tank/tank = null              // Deployable tank, if any.

/obj/item/clothing/suit/space/void/examine(user)
	..(user)
	var/list/part_list = new
	for(var/obj/item/I in list(helmet,boots,tank))
		part_list += "\a [I]"
	user << "\The [src] has [english_list(part_list)] installed."
	if(tank && in_range(src,user))
		user << SPAN_NOTICE("The wrist-mounted pressure gauge reads [max(round(tank.air_contents.return_pressure()),0)] kPa remaining in \the [tank].")

/obj/item/clothing/suit/space/void/equipped(mob/M)
	..()

	var/mob/living/carbon/human/H = M

	if(!istype(H)) return

	if(H.wear_suit != src)
		return

	if(boots)
		if (H.equip_to_slot_if_possible(boots, slot_shoes))
			boots.canremove = 0

	if(helmet)
		if(H.head)
			M << "You are unable to deploy your suit's helmet as \the [H.head] is in the way."
		else if (H.equip_to_slot_if_possible(helmet, slot_head))
			M << "Your suit's helmet deploys with a hiss."
			helmet.canremove = 0

	if(tank)
		if(H.s_store) //In case someone finds a way.
			M << "Alarmingly, the valve on your suit's installed tank fails to engage."
		else if (H.equip_to_slot_if_possible(tank, slot_s_store))
			M << "The valve on your suit's installed tank safely engages."
			tank.canremove = 0


/obj/item/clothing/suit/space/void/dropped()
	..()

	var/mob/living/carbon/human/H

	if(helmet)
		helmet.canremove = 1
		H = helmet.loc
		if(istype(H))
			if(helmet && H.head == helmet)
				H.drop_from_inventory(helmet)
				helmet.forceMove(src)

	if(boots)
		boots.canremove = 1
		H = boots.loc
		if(istype(H))
			if(boots && H.shoes == boots)
				H.drop_from_inventory(boots)
				boots.forceMove(src)

	if(tank)
		tank.canremove = 1
		tank.forceMove(src)

/obj/item/clothing/suit/space/void/verb/toggle_helmet()

	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	if(!helmet)
		usr << "There is no helmet installed."
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.stat) return
	if(H.wear_suit != src) return

	if(H.head == helmet)
		H << SPAN_NOTICE("You retract your suit helmet.")
		helmet.canremove = 1
		H.drop_from_inventory(helmet)
		helmet.forceMove(src)
	else
		if(H.head)
			H << SPAN_DANGER("You cannot deploy your helmet while wearing \the [H.head].")
			return
		if(H.equip_to_slot_if_possible(helmet, slot_head))
			helmet.pickup(H)
			helmet.canremove = 0
			H << "<span class='info'>You deploy your suit helmet, sealing you off from the world.</span>"
	helmet.update_light(H)

/obj/item/clothing/suit/space/void/verb/eject_tank()

	set name = "Eject Voidsuit Tank"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc))
		return

	if(!tank)
		usr << "There is no tank inserted."
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.wear_suit != src)
		return

	H << "<span class='info'>You press the emergency release, ejecting \the [tank] from your suit.</span>"
	tank.canremove = 1
	H.drop_from_inventory(tank)
	src.tank = null

/obj/item/clothing/suit/space/void/attackby(obj/item/W as obj, mob/user as mob)

	if(!isliving(user))
		return

	if(istype(W,/obj/item/clothing/accessory) || istype(W, /obj/item/weapon/hand_labeler))
		return ..()

	if(isliving(src.loc))
		user << SPAN_WARNING("You cannot modify \the [src] while it is being worn.")
		return

	if(istype(W,/obj/item/weapon/tool/screwdriver))
		if(helmet || boots || tank)
			var/choice = input("What component would you like to remove?") as null|anything in list(helmet,boots,tank)
			if(!choice) return

			if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
				user << "You pop \the [tank] out of \the [src]'s storage compartment."
				tank.forceMove(get_turf(src))
				src.tank = null
			else if(choice == helmet)
				user << "You detatch \the [helmet] from \the [src]'s helmet mount."
				helmet.forceMove(get_turf(src))
				src.helmet = null
			else if(choice == boots)
				user << "You detatch \the [boots] from \the [src]'s boot mounts."
				boots.forceMove(get_turf(src))
				src.boots = null
		else
			user << "\The [src] does not have anything installed."
		return
	else if(istype(W,/obj/item/clothing/head/helmet/space))
		if(helmet)
			user << "\The [src] already has a helmet installed."
		else
			user << "You attach \the [W] to \the [src]'s helmet mount."
			user.drop_item()
			W.forceMove(src)
			src.helmet = W
		return
	else if(istype(W,/obj/item/clothing/shoes/magboots))
		if(boots)
			user << "\The [src] already has magboots installed."
		else
			user << "You attach \the [W] to \the [src]'s boot mounts."
			user.drop_item()
			W.forceMove(src)
			boots = W
		return
	else if(istype(W,/obj/item/weapon/tank))
		if(tank)
			user << "\The [src] already has an airtank installed."
		else if(istype(W,/obj/item/weapon/tank/plasma))
			user << "\The [W] cannot be inserted into \the [src]'s storage compartment."
		else
			user << "You insert \the [W] into \the [src]'s storage compartment."
			user.drop_item()
			W.forceMove(src)
			tank = W
		return

	..()