/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/weapon/bananapeel/Crossed(AM as mob|obj)
	if (isliving(AM))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Soap
 */
/obj/item/weapon/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/soap/New()
	..()
	create_reagents(5)
	wet()

/obj/item/weapon/soap/proc/wet()
	reagents.add_reagent("cleaner", 5)

/obj/item/weapon/soap/Crossed(AM as mob|obj)
	if (isliving(AM))
		var/mob/living/M = AM
		M.slip("the [src.name]",3)

/obj/item/weapon/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		user << SPAN_NOTICE("You need to take that [target.name] off before cleaning it.")
	else if(istype(target,/obj/effect/decal/cleanable))
		user << SPAN_NOTICE("You scrub \the [target.name] out.")
		qdel(target)
	else if(istype(target,/turf))
		user << SPAN_NOTICE("You scrub \the [target.name] clean.")
		var/turf/T = target
		T.clean(src, user)
	else if(istype(target,/obj/structure/sink))
		user << SPAN_NOTICE("You wet \the [src] in the sink.")
		wet()
	else
		user << SPAN_NOTICE("You clean \the [target.name].")
		target.clean_blood()
	return

//attack_as_weapon
/obj/item/weapon/soap/attack(mob/living/target, mob/living/user, var/target_zone)
	if(ishuman(target) && ishuman(user) && !target.stat && user.targeted_organ == "mouth")
		user.visible_message(
			SPAN_DANGER("\The [user] washes \the [target]'s mouth out with soap!")
		)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/obj/item/weapon/soap/nanotrasen
	desc = "A NanoTrasen-brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/weapon/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/weapon/soap/deluxe/New()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."
	..()

/obj/item/weapon/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/*
 * Bike Horns
 */
/obj/item/weapon/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0

/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
