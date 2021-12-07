/obj/item/part/gun/frame
	name = "gun frame"
	desc = "a generic gun frame. consider debug"
	icon_state = "frame_olivaw"
	generic = FALSE
	bad_type = /obj/item/part/gun/frame
	matter = list(MATERIAL_PLASTEEL = 4)

	var/result = /obj/item/gun/projectile

	var/grip = /obj/item/part/gun/grip
	var/grip_attached = FALSE

	var/variant_grip = FALSE
	var/gripvar1 = /obj/item/part/gun/grip/wood
	var/gripvar2 = /obj/item/part/gun/grip/black
	var/gripvar3
	var/gripvar4

	var/resultvar1 = /obj/item/gun/projectile
	var/resultvar2 = /obj/item/gun/projectile
	var/resultvar3
	var/resultvar4

	var/mechanism = /obj/item/part/gun/mechanism
	var/mechanism_attached = FALSE
	var/barrel = /obj/item/part/gun/barrel
	var/barrel_attached = FALSE

/obj/item/part/gun/frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/part/gun/grip))
		if(grip_attached)
			to_chat(user, SPAN_WARNING("[src] already has a grip attached!"))
			return
		else if(variant_grip) 
			if(istype(I, gripvar1))
				result = resultvar1
			else if(istype(I, gripvar2))
				result = resultvar2
			else if(istype(I, gripvar3))
				result = resultvar3
			else if(istype(I, gripvar4))
				result = resultvar4
			else
				to_chat(user, SPAN_WARNING("This grip does not fit!"))
				return
			if(insert_item(I, user))
				grip_attached = TRUE
				to_chat(user, SPAN_NOTICE("You have attached the grip to \the [src]."))
				return
		else if(istype(I, grip))
			if(insert_item(I, user))
				grip_attached = TRUE
				to_chat(user, SPAN_NOTICE("You have attached the grip to \the [src]."))
				return
		else
			to_chat(user, SPAN_WARNING("You cannot attach this to \the [src]!"))	

	if(istype(I, mechanism))
		if(mechanism_attached)
			to_chat(user, SPAN_WARNING("[src] already has a mechanism attached!"))
			return
		else if(insert_item(I, user))
			mechanism_attached = TRUE
			to_chat(user, SPAN_NOTICE("You have attached the mechanism to \the [src]."))
			return

	if(istype(I, barrel))
		if(barrel_attached)
			to_chat(user, SPAN_WARNING("[src] already has a barrel attached!"))
			return
		else if(insert_item(I, user))
			barrel_attached = TRUE
			to_chat(user, SPAN_NOTICE("You have attached the barrel to \the [src]."))
			return
	return ..()

/obj/item/part/gun/frame/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	if(!grip_attached)
		to_chat(user, SPAN_WARNING("\the [src] does not have a grip!"))
		return
	if(!mechanism_attached)
		to_chat(user, SPAN_WARNING("\the [src] does not have a mechanism!"))
		return
	if(!barrel_attached)
		to_chat(user, SPAN_WARNING("\the [src] does not have a barrel!"))
		return
	new result(T)
	qdel(src)
	return

/obj/item/part/gun/frame/examine(user, distance)
	. = ..()
	if(.)
		if(grip_attached)
			to_chat(user, SPAN_NOTICE("\the [src] has a grip installed."))
		else
			to_chat(user, SPAN_NOTICE("\the [src] does not have a grip installed."))
		if(mechanism_attached)
			to_chat(user, SPAN_NOTICE("\the [src] has a mechanism installed."))
		else
			to_chat(user, SPAN_NOTICE("\the [src] does not have a mechanism installed."))
		if(barrel_attached)
			to_chat(user, SPAN_NOTICE("\the [src] has a barrel installed."))
		else
			to_chat(user, SPAN_NOTICE("\the [src] does not have a barrel installed."))

//Grips
/obj/item/part/gun/grip
	name = "generic grip"
	desc = "A generic firearm grip, unattached from a firearm."
	icon_state = "grip_wood"
	generic = FALSE
	bad_type = /obj/item/part/gun/grip
	matter = list(MATERIAL_PLASTIC = 6)

/obj/item/part/gun/grip/wood
	name = "wood grip"
	desc = "A wood firearm grip, unattached from a firearm."
	icon_state = "grip_wood"
	matter = list(MATERIAL_WOOD = 6)

/obj/item/part/gun/grip/black //Nanotrasen, Moebius, Syndicate, Oberth
	name = "plastic grip"
	desc = "A black plastic firearm grip, unattached from a firearm. For sleekness and decorum."
	icon_state = "grip_black"

/obj/item/part/gun/grip/rubber //FS and IH
	name = "rubber grip"
	desc = "A rubber firearm grip, unattached from a firearm. For professionalism and violence of action."
	icon_state = "grip_rubber"

/obj/item/part/gun/grip/excel
	name = "Excelsior plastic grip"
	desc = "A tan plastic firearm grip, unattached from a firearm. To fight for Haven and to spread the unified revolution!"
	icon_state = "grip_excel"

/obj/item/part/gun/grip/serb
	name = "bakelite plastic grip"
	desc = "A brown plastic firearm grip, unattached from a firearm. Classics never go out of style."
	icon_state = "grip_serb"

//Mechanisms
/obj/item/part/gun/mechanism
	name = "generic mechanism"
	desc = "All the bits that makes the bullet go bang."
	icon_state = "mechanism_pistol"
	generic = FALSE
	bad_type = /obj/item/part/gun/mechanism
	matter = list(MATERIAL_PLASTEEL = 4)

/obj/item/part/gun/mechanism/pistol
	name = "pistol mechanism"
	desc = "All the bits that makes the bullet go bang, all in a small, convenient frame."
	icon_state = "mechanism_pistol"

/obj/item/part/gun/mechanism/revolver
	name = "revolver mechanism"
	desc = "All the bits that makes the bullet go bang, rolling round and round."
	icon_state = "mechanism_revolver"

/obj/item/part/gun/mechanism/shotgun
	name = "shotgun mechanism"
	desc = "All the bits that makes the bullet go bang, perfect for long shells."
	icon_state = "mechanism_shotgun"

/obj/item/part/gun/mechanism/smg
	name = "SMG mechanism"
	desc = "All the bits that makes the bullet go bang, in a speedy package."
	icon_state = "mechanism_smg"

/obj/item/part/gun/mechanism/boltgun
	name = "bolt-action mechanism"
	desc = "All the bits that makes the bullet go bang, slow and methodical."
	icon_state = "mechanism_boltaction"
	matter = list(MATERIAL_STEEL = 10)

/obj/item/part/gun/mechanism/autorifle
	name = "self-loading mechanism"
	desc = "All the bits that makes the bullet go bang, for all the military hardware you know and love."
	icon_state = "mechanism_autorifle"

/obj/item/part/gun/mechanism/machinegun
	name = "machine gun mechanism"
	desc = "All the bits that makes the bullet go bang. Now I have a machine gun, Ho, Ho, Ho."
	icon_state = "mechanism_machinegun"

//Barrels
/obj/item/part/gun/barrel
	name = "generic barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction."
	icon_state = "barrel_35"
	generic = FALSE
	bad_type = /obj/item/part/gun/barrel
	matter = list(MATERIAL_PLASTEEL = 4)

/obj/item/part/gun/barrel/pistol
	name = ".35 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .35 caliber."
	icon_state = "barrel_35"

/obj/item/part/gun/barrel/magnum
	name = ".40 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .40 caliber."
	icon_state = "barrel_40"

/obj/item/part/gun/barrel/srifle
	name = ".20 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .20 caliber."
	icon_state = "barrel_20"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/clrifle
	name = ".25 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .25 caliber."
	icon_state = "barrel_25"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/clrifle_silenced
	name = ".25 integrally suppressed barrel"
	desc = "An integrally suppressed gun barrel, which keeps the bullet going in the right direction and the noise down. Chambered in .25 caliber."
	icon_state = "barrel_25_s"

/obj/item/part/gun/barrel/lrifle
	name = ".30 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .30 caliber."
	icon_state = "barrel_30"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/shotgun
	name = "shotgun barrel"
	desc = "A gun barrel, which keeps the bullet (or bullets) going in the right direction. Chambered in .50 caliber."
	icon_state = "barrel_50"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/antim
	name = ".60 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .60 caliber."
	icon_state = "barrel_60"
	matter = list(MATERIAL_PLASTEEL = 16)
