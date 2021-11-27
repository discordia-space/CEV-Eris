/obj/item/part/gun/grip
	name = "wood grip"
	desc = "A wood firearm grip, unattached from a firearm."
	icon_state = "grip_wood"
	generic = FALSE

/obj/item/part/gun/mechanism
	name = "pistol mechanism"
	desc = "All the bits that makes the bullet go bang."
	icon_state = "mechanism_pistol"
	generic = FALSE

/obj/item/part/gun/barrel
	name = ".35 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction."
	icon_state = "barrel_35"
	generic = FALSE

/obj/item/part/gun/frame
	name = "gun frame"
	desc = "a generic gun frame. consider debug"
	icon_state = "frame_olivaw"
	generic = FALSE

	var/result = /obj/item/gun/projectile/automatic/dallas

	var/grip = /obj/item/part/gun/grip
	var/grip_attached = FALSE
	var/mechanism = /obj/item/part/gun/mechanism
	var/mechanism_attached = FALSE
	var/barrel = /obj/item/part/gun/barrel
	var/barrel_attached = FALSE

/obj/item/part/gun/frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, grip))
		if(grip_attached)
			to_chat(user, SPAN_WARNING("[src] already has a grip attached!"))
			return
		else if(insert_item(I, user))
			grip_attached = TRUE
			to_chat(user, SPAN_NOTICE("You have attached [src]."))
			return

	if(istype(I, mechanism))
		if(mechanism_attached)
			to_chat(user, SPAN_WARNING("[src] already has a mechanism attached!"))
			return
		else if(insert_item(I, user))
			mechanism_attached = TRUE
			to_chat(user, SPAN_NOTICE("You have attached [src]."))
			return

	if(istype(I, barrel))
		if(barrel_attached)
			to_chat(user, SPAN_WARNING("[src] already has a barrel attached!"))
			return
		else if(insert_item(I, user))
			barrel_attached = TRUE
			to_chat(user, SPAN_NOTICE("You have attached [src]."))
			return
	return ..()

/obj/item/part/gun/frame/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	if(!grip_attached)
		to_chat(user, SPAN_WARNING("[src] does not have a grip!"))
		return
	if(!mechanism_attached)
		to_chat(user, SPAN_WARNING("[src] does not have a mechanism!"))
		return
	if(!barrel_attached)
		to_chat(user, SPAN_WARNING("[src] does not have a barrel!"))
		return
	new result(T)
	qdel(src)
	return		
