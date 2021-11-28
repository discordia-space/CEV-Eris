/obj/item/part/gun/frame
	name = "gun frame"
	desc = "a generic gun frame. consider debug"
	icon_state = "frame_olivaw"
	generic = FALSE
	bad_type = /obj/item/part/gun/frame

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

//Grips
/obj/item/part/gun/grip
	name = "generic grip"
	desc = "A generic firearm grip, unattached from a firearm."
	icon_state = "grip_wood"
	generic = FALSE
	bad_type = /obj/item/part/gun/grip

/obj/item/part/gun/grip/wood
	name = "wood grip"
	desc = "A wood firearm grip, unattached from a firearm."
	icon_state = "grip_wood"

/obj/item/part/gun/grip/black
	name = "plastic grip"
	desc = "A black plastic firearm grip, unattached from a firearm. For sleekness and decorum."
	icon_state = "grip_black"

/obj/item/part/gun/grip/rubber
	name = "rubber grip"
	desc = "A rubber firearm grip, unattached from a firearm. For professionalism and violence of action."
	icon_state = "grip_rubber"

/obj/item/part/gun/grip/excel
	name = "Excelsior plastic grip"
	desc = "A tan plastic firearm grip, unattached from a firearm. To fight for Haven and to spread the unified revolution!"
	icon_state = "grip_excel"

//Mechanisms
/obj/item/part/gun/mechanism
	name = "generic mechanism"
	desc = "All the bits that makes the bullet go bang."
	icon_state = "mechanism_pistol"
	generic = FALSE
	bad_type = /obj/item/part/gun/mechanism

/obj/item/part/gun/mechanism/pistol
	name = "pistol mechanism"
	desc = "All the bits that makes the bullet go bang, all in a convenient frame."
	icon_state = "mechanism_pistol"

/obj/item/part/gun/mechanism/revolver
	name = "revolver mechanism"
	desc = "All the bits that makes the bullet go bang."
	icon_state = "mechanism_revolver"

//Barrels
/obj/item/part/gun/barrel
	name = "generic barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction."
	icon_state = "barrel_35"
	generic = FALSE
	bad_type = /obj/item/part/gun/barrel

/obj/item/part/gun/barrel/pistol
	name = ".35 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .35 caliber."
	icon_state = "barrel_35"

/obj/item/part/gun/barrel/magnum
	name = ".40 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .40 caliber."
	icon_state = "barrel_40"

/obj/item/part/gun/barrel/csrifle_silenced
	name = ".25 integrally suppressed barrel"
	desc = "An integrally suppressed gun barrel, which keeps the bullet going in the right direction and the noise down. Chambered in .25 caliber."
	icon_state = "barrel_40"
