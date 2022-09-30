/obj/item/part/gun/frame
	name = "gun frame"
	desc = "a generic gun frame. consider debug"
	icon_state = "frame_olivaw"
	generic = FALSE
	bad_type = /obj/item/part/gun/frame
	matter = list(MATERIAL_PLASTEEL = 5)
	rarity_value = 10

	// What gun the frame makes when it only accepts one grip
	var/result = /obj/item/gun/projectile

	// Currently installed grip
	var/obj/item/part/gun/grip/InstalledGrip

	// Which grips does the frame accept?
	var/list/gripvars = list(/obj/item/part/gun/grip/wood, /obj/item/part/gun/grip/black)
	// What are the results (in order relative to gripvars)?
	var/list/resultvars = list(/obj/item/gun/projectile, /obj/item/gun/energy)

	// Currently installed mechanism
	var/obj/item/part/gun/grip/InstalledMechanism
	// Which mechanism the frame accepts?
	var/list/mechanismvar = /obj/item/part/gun/mechanism

	// Currently installed barrel
	var/obj/item/part/gun/barrel/InstalledBarrel
	// Which barrels does the frame accept?
	var/list/barrelvars = list(/obj/item/part/gun/barrel)

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
		var/list/parts_list = list("mechanism", "barrel", "grip")

		pick_n_take(parts_list)
		if(prob(50))
			pick_n_take(parts_list)

		for(var/part in parts_list)
			switch(part)
				if("mechanism")
					InstalledMechanism = new mechanismvar(src)
				if("barrel")
					var/select = pick(barrelvars)
					InstalledBarrel = new select(src)
				if("grip")
					var/select = pick(gripvars)
					InstalledGrip = new select(src)

/obj/item/part/gun/frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/part/gun/grip))
		if(InstalledGrip)
			to_chat(user, SPAN_WARNING("[src] already has a grip attached!"))
			return
		else
			handle_gripvar(I, user)

	if(istype(I, /obj/item/part/gun/mechanism))
		if(InstalledMechanism)
			to_chat(user, SPAN_WARNING("[src] already has a mechanism attached!"))
			return
		else
			handle_mechanismvar(I, user)

	if(istype(I, /obj/item/part/gun/barrel))
		if(InstalledBarrel)
			to_chat(user, SPAN_WARNING("[src] already has a barrel attached!"))
			return
		else
			handle_barrelvar(I, user)

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
				if(istype(toremove, /obj/item/part/gun/grip))
					InstalledGrip = null
				else if(istype(toremove, /obj/item/part/gun/barrel))
					InstalledBarrel = FALSE
				else if(istype(toremove, /obj/item/part/gun/mechanism))
					InstalledMechanism = FALSE

	return ..()

/obj/item/part/gun/frame/proc/handle_gripvar(obj/item/I, mob/living/user)
	if(I.type in gripvars)
		var/variantnum = gripvars.Find(I.type)
		result = resultvars[variantnum]
		if(insert_item(I, user))
			InstalledGrip = I
			to_chat(user, SPAN_NOTICE("You have attached the grip to \the [src]."))
			return
	else
		to_chat(user, SPAN_WARNING("This grip does not fit!"))
		return

/obj/item/part/gun/frame/proc/handle_mechanismvar(obj/item/I, mob/living/user)
	if(I.type == mechanismvar)
		if(insert_item(I, user))
			InstalledMechanism = I
			to_chat(user, SPAN_NOTICE("You have attached the mechanism to \the [src]."))
			return
	else
		to_chat(user, SPAN_WARNING("This mechanism does not fit!"))
		return

/obj/item/part/gun/frame/proc/handle_barrelvar(obj/item/I, mob/living/user)
	if(I.type in barrelvars)
		if(insert_item(I, user))
			InstalledBarrel = I
			to_chat(user, SPAN_NOTICE("You have attached the barrel to \the [src]."))
			return
	else
		to_chat(user, SPAN_WARNING("This barrel does not fit!"))
		return

/obj/item/part/gun/frame/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	if(!InstalledGrip)
		to_chat(user, SPAN_WARNING("\the [src] does not have a grip!"))
		return
	if(!InstalledMechanism)
		to_chat(user, SPAN_WARNING("\the [src] does not have a mechanism!"))
		return
	if(!InstalledBarrel)
		to_chat(user, SPAN_WARNING("\the [src] does not have a barrel!"))
		return
	var/obj/item/gun/G = new result(T)
	G.serial_type = serial_type
	if(barrelvars.len > 1 && istype(G, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/P = G
		P.caliber = InstalledBarrel.caliber
		G.gun_parts = list(src.type = 1, InstalledGrip.type = 1, InstalledMechanism.type = 1, InstalledBarrel.type = 1)
	qdel(src)
	return

/obj/item/part/gun/frame/examine(user, distance)
	. = ..()
	if(.)
		if(InstalledGrip)
			to_chat(user, SPAN_NOTICE("\the [src] has \a [InstalledGrip] installed."))
		else
			to_chat(user, SPAN_NOTICE("\the [src] does not have a grip installed."))
		if(InstalledMechanism)
			to_chat(user, SPAN_NOTICE("\the [src] has \a [InstalledMechanism] installed."))
		else
			to_chat(user, SPAN_NOTICE("\the [src] does not have a mechanism installed."))
		if(InstalledBarrel)
			to_chat(user, SPAN_NOTICE("\the [src] has \a [InstalledBarrel] installed."))
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
	matter = list(MATERIAL_PLASTEEL = 5)
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
	matter = list(MATERIAL_PLASTEEL = 10)

/obj/item/part/gun/mechanism/smg
	name = "SMG mechanism"
	desc = "All the bits that makes the bullet go bang, in a speedy package."
	icon_state = "mechanism_smg"

/obj/item/part/gun/mechanism/autorifle
	name = "self-loading mechanism"
	desc = "All the bits that makes the bullet go bang, for all the military hardware you know and love."
	icon_state = "mechanism_autorifle"
	matter = list(MATERIAL_PLASTEEL = 10)

/obj/item/part/gun/mechanism/machinegun
	name = "machine gun mechanism"
	desc = "All the bits that makes the bullet go bang. Now I have a machine gun, Ho, Ho, Ho."
	icon_state = "mechanism_machinegun"
	matter = list(MATERIAL_PLASTEEL = 16)
	rarity_value = 8

// steel mechanisms
/obj/item/part/gun/mechanism/pistol/steel
	name = "cheap pistol mechanism"
	desc = "All the bits that makes the bullet go bang, all in a small, convenient frame. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 5)

/obj/item/part/gun/mechanism/revolver/steel
	name = "cheap revolver mechanism"
	desc = "All the bits that makes the bullet go bang, rolling round and round. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 5)

/obj/item/part/gun/mechanism/shotgun/steel
	name = "cheap shotgun mechanism"
	desc = "All the bits that makes the bullet go bang, perfect for long shells.  \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 10)

/obj/item/part/gun/mechanism/smg/steel
	name = "cheap SMG mechanism"
	desc = "All the bits that makes the bullet go bang, in a speedy package. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 5)

/obj/item/part/gun/mechanism/boltgun // fits better in this category despite not being a steel variant
	name = "manual-action mechanism"
	desc = "All the bits that makes the bullet go bang, slow and methodical."
	icon_state = "mechanism_boltaction"
	matter = list(MATERIAL_STEEL = 10)

/obj/item/part/gun/mechanism/autorifle/steel
	name = "cheap self-loading mechanism"
	desc = "All the bits that makes the bullet go bang, for all the military hardware you know and love. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 10)

//Barrels
/obj/item/part/gun/barrel
	name = "generic barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction."
	icon_state = "barrel_35"
	generic = FALSE
	bad_type = /obj/item/part/gun/barrel
	matter = list(MATERIAL_PLASTEEL = 8)
	price_tag = 200
	rarity_value = 15
	var/caliber = CAL_357

/obj/item/part/gun/barrel/pistol
	name = ".35 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .35 caliber."
	icon_state = "barrel_35"
	matter = list(MATERIAL_PLASTEEL = 4)
	price_tag = 100
	caliber = CAL_PISTOL

/obj/item/part/gun/barrel/magnum
	name = ".40 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .40 caliber."
	icon_state = "barrel_40"
	matter = list(MATERIAL_PLASTEEL = 4)
	price_tag = 100
	caliber = CAL_MAGNUM

/obj/item/part/gun/barrel/srifle
	name = ".20 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .20 caliber."
	icon_state = "barrel_20"
	matter = list(MATERIAL_PLASTEEL = 8)
	caliber = CAL_SRIFLE

/obj/item/part/gun/barrel/clrifle
	name = ".25 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .25 caliber."
	icon_state = "barrel_25"
	matter = list(MATERIAL_PLASTEEL = 8)
	caliber = CAL_CLRIFLE
 
/obj/item/part/gun/barrel/lrifle
	name = ".30 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .30 caliber."
	icon_state = "barrel_30"
	matter = list(MATERIAL_PLASTEEL = 8)
	caliber = CAL_LRIFLE

/obj/item/part/gun/barrel/shotgun
	name = "shotgun barrel"
	desc = "A gun barrel, which keeps the bullet (or bullets) going in the right direction. Chambered in .50 caliber."
	icon_state = "barrel_50"
	matter = list(MATERIAL_PLASTEEL = 8)
	caliber = CAL_SHOTGUN

/obj/item/part/gun/barrel/antim
	name = ".60 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .60 caliber."
	icon_state = "barrel_60"
	matter = list(MATERIAL_PLASTEEL = 16)
	caliber = CAL_ANTIM

// steel barrels
/obj/item/part/gun/barrel/pistol/steel
	name = "cheap .35 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .35 caliber. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 4)

/obj/item/part/gun/barrel/magnum/steel
	name = "cheap .40 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .40 caliber. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 4)

/obj/item/part/gun/barrel/srifle/steel
	name = "cheap .20 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .20 caliber. \
			 This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 8)

/obj/item/part/gun/barrel/clrifle/steel
	name = "cheap .25 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .25 caliber. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 8)
 
/obj/item/part/gun/barrel/lrifle/steel
	name = "cheap .30 barrel"
	desc = "A gun barrel, which keeps the bullet going in the right direction. Chambered in .30 caliber. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 8)

/obj/item/part/gun/barrel/shotgun/steel
	name = "cheap shotgun barrel"
	desc = "A gun barrel, which keeps the bullet (or bullets) going in the right direction. Chambered in .50 caliber. \
			This one does not look as high quality."
	matter = list(MATERIAL_STEEL = 8)
	