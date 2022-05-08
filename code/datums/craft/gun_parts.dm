/obj/item/part/gun/frame
	name = "gun frame"
	desc = "a generic gun frame. consider debug"
	icon_state = "frame_olivaw"
	generic = FALSE
	bad_type = /obj/item/part/gun/frame
	matter = list(MATERIAL_PLASTEEL = 4)
	rarity_value = 10

	var/result = /obj/item/gun/projectile

	var/grip = /obj/item/part/gun/grip
	var/grip_attached = FALSE

	var/variant_grip = FALSE
	var/list/gripvars = list(/obj/item/part/gun/grip/wood, /obj/item/part/gun/grip/black)
	var/list/resultvars = list(/obj/item/gun/projectile, /obj/item/gun/energy)

	var/mechanism = /obj/item/part/gun/mechanism
	var/mechanism_attached = FALSE
	var/barrel = /obj/item/part/gun/barrel
	var/barrel_attached = FALSE
	var/serial_type = ""


/obj/item/part/gun/frame/New(loc, ...)
	. = ..()
	var/obj/item/gun/G = new result(null)
	if(G.serial_type)
		serial_type = G.serial_type


/obj/item/part/gun/frame/New(loc)
	..()
	var/spawn_with_preinstalled_parts = FALSE
	if(istype(loc, /obj/structure/scrap_spawner))
		spawn_with_preinstalled_parts = TRUE
	else if(in_maintenance())
		var/turf/T = get_turf(src)
		for(var/atom/A in T.contents)
			if(istype(A, /obj/spawner))
				spawn_with_preinstalled_parts = TRUE

	if(spawn_with_preinstalled_parts)
		var/list/parts_list = list(pick(gripvars), mechanism, barrel)

		pick_n_take(parts_list)
		if(prob(50))
			pick_n_take(parts_list)

		for(var/part in parts_list)
			if(ispath(part, grip))
				new part(src)
				grip_attached = TRUE
			else if(part in gripvars)
				var/variantnum = gripvars.Find(part)
				result = resultvars[variantnum]
				new part(src)
				grip_attached = TRUE
			else if(ispath(part, barrel))
				new part(src)
				barrel_attached = TRUE
			else if(ispath(part, mechanism))
				new part(src)
				mechanism_attached = TRUE

/obj/item/part/gun/frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/part/gun/grip))
		if(grip_attached)
			to_chat(user, SPAN_WARNING("[src] already has a grip attached!"))
			return
		else if(variant_grip) 
			handle_gripvar(I, user)
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

	var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING, serial_type ? QUALITY_HAMMERING : null), src)
	switch(tool_type)
		if(QUALITY_HAMMERING)
			user.visible_message(SPAN_NOTICE("[user] begins scribbling \the [name]'s gun serial number away."), SPAN_NOTICE("You begin removing the serial number from \the [name]."))
			if(I.use_tool(user, src, WORKTIME_SLOW, QUALITY_HAMMERING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				user.visible_message(SPAN_DANGER("[user] removes \the [name]'s gun serial number."), SPAN_NOTICE("You successfully remove the serial number from \the [name]."))
				serial_type = null
				return

		if(QUALITY_SCREW_DRIVING)
			var/list/possibles = contents.Copy()
			var/obj/item/part/gun/toremove = input("Which part would you like to remove?","Removing parts") in possibles
			if(!toremove)
				return
			if(I.use_tool(user, src, WORKTIME_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_ZERO, required_stat = STAT_MEC))
				eject_item(toremove, user)
				if(istype(toremove, grip))
					grip_attached = FALSE
				else if(istype(toremove, barrel))
					barrel_attached = FALSE
				else if(istype(toremove, mechanism))
					mechanism_attached = FALSE

	return ..()

/obj/item/part/gun/frame/proc/handle_gripvar(obj/item/I, mob/living/user)
	if(I.type in gripvars)
		var/variantnum = gripvars.Find(I.type)
		result = resultvars[variantnum]
		if(insert_item(I, user))
			grip_attached = TRUE
			to_chat(user, SPAN_NOTICE("You have attached the grip to \the [src]."))
			return
	else
		to_chat(user, SPAN_WARNING("This grip does not fit!"))
		return

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
	var/obj/item/gun/G = new result(T)
	G.serial_type = serial_type
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
		if(in_range(user, src) || isghost(user))
			if(serial_type)
				to_chat(user, SPAN_WARNING("There is a serial number on the frame, it reads [serial_type]."))
			else if(isnull(serial_type))
				to_chat(user, SPAN_DANGER("The serial is scribbled away."))

//Grips
/obj/item/part/gun/grip
	name = "generic grip"
	desc = "A generic firearm grip, unattached from a firearm."
	icon_state = "grip_wood"
	generic = FALSE
	bad_type = /obj/item/part/gun/grip
	matter = list(MATERIAL_PLASTIC = 6)
	price_tag = 100
	rarity_value = 5

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
	rarity_value = 7

/obj/item/part/gun/grip/serb
	name = "bakelite plastic grip"
	desc = "A brown plastic firearm grip, unattached from a firearm. Classics never go out of style."
	icon_state = "grip_serb"
	rarity_value = 7

//Mechanisms
/obj/item/part/gun/mechanism
	name = "generic mechanism"
	desc = "All the bits that makes the bullet go bang."
	icon_state = "mechanism_pistol"
	generic = FALSE
	bad_type = /obj/item/part/gun/mechanism
	matter = list(MATERIAL_PLASTEEL = 4)
	price_tag = 100
	rarity_value = 6

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
	rarity_value = 8

//Barrels
/obj/item/part/gun/barrel
	name = "generic barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction."
	icon_state = "barrel_35"
	generic = FALSE
	bad_type = /obj/item/part/gun/barrel
	matter = list(MATERIAL_PLASTEEL = 4)
	price_tag = 200
	rarity_value = 15

/obj/item/part/gun/barrel/pistol
	name = ".35 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .35 caliber."
	icon_state = "barrel_35"
	price_tag = 100

/obj/item/part/gun/barrel/magnum
	name = ".40 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .40 caliber."
	icon_state = "barrel_40"
	price_tag = 100

/obj/item/part/gun/barrel/srifle
	name = ".20 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .20 caliber."
	icon_state = "barrel_20"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/srifle/steel
	matter = list(MATERIAL_STEEL = 8)

/obj/item/part/gun/barrel/clrifle
	name = ".25 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .25 caliber."
	icon_state = "barrel_25"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/lrifle
	name = ".30 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .30 caliber."
	icon_state = "barrel_30"
	matter = list(MATERIAL_PLASTEEL = 8)

/obj/item/part/gun/barrel/lrifle/steel
	matter = list(MATERIAL_STEEL = 8)

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
