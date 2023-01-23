//NO new variables here, might as well not even have this category, many guns outside /automatic use automatic firemodes
/obj/item/gun/projectile/automatic/modular
	name = "\"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price."
	icon = 'icons/obj/guns/projectile/ak.dmi'
	icon_state = "frame"
	item_state = "" // I do not believe this affects anything
	w_class = ITEM_SIZE_BULKY // Stock increases it by 1
	force = WEAPON_FORCE_PAINFUL
	caliber = null // Determined by barrel
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1) // Parts can give better tech
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = null // Long and drum magazines are determined by mechanism
	magazine_type = /obj/item/ammo_magazine/lrifle // Default magazine, only relevant for spawned AKs, not crafted or printed ones
	matter = list(MATERIAL_PLASTEEL = 5) // Gunparts will be stored within the AK as extra material
	price_tag = 1000 // Same reason as matter, albeit this is where the license points matter
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	init_recoil = RIFLE_RECOIL(1) // Default is 0.8 to 0.7 on most AKs, we will reduce this value with relevant gun parts
	damage_multiplier = 1 // Mechanism + Barrel can modify
	penetration_multiplier = 0 // Mechanism + Barrel can modify
	spawn_blacklisted = TRUE

	// Will be regenerated on init, used to determine what sprites to display
	gun_parts = list()

	// Determines what parts the modular gun accepts and required. 0 means required, -1 means optional. Order matters.
	var/list/required_parts = list(/obj/item/part/gun/modular/mechanism/autorifle = 0, /obj/item/part/gun/modular/barrel = 0, /obj/item/part/gun/modular/grip = 0, /obj/item/part/gun/modular/stock = -1)

	init_offset = 15 // Removed by grip, this is present just in case you don't want one for style reasons

	gun_tags = list(GUN_SILENCABLE, GUN_MODULAR)
	var/spriteTags = PARTMOD_STRIPPED // Tags to attach to sprites
	var/statusTags = PARTMOD_STRIPPED
	var/grip_type = ""

	init_firemodes = list( // Determined by mechanism
		SEMI_AUTO_300,
		)

	serial_type = "Excelsior"

	var/stock = STOCK_MISSING
	max_upgrades = 6

/obj/item/gun/projectile/automatic/modular/refresh_upgrades()
	caliber = initial(caliber)
	name = initial(name)
	mag_well = initial(mag_well)
	spriteTags = initial(spriteTags)
	grip_type = initial(grip_type)
	..()

/obj/item/gun/projectile/automatic/modular/ak

/obj/item/gun/projectile/automatic/modular/ak/update_icon() // V2
	..()
	cut_overlays() // This is where the fun begins

	// Determine base using the current stock status
	var/iconstring = initial(icon_state)
	var/itemstring = ""

	// Define "-" tags
	var/dashTag = ""
	if((PARTMOD_STOCK & spriteTags) && (PARTMOD_STOCK & statusTags))
		dashTag += "-st"

	// Add dashTag to iconstring
	iconstring += dashTag

	for(var/obj/item/part/gun/modular/gun_part in gun_parts) // Cycle through all parts
		if(gun_part.part_overlay) // Safety check

			if(gun_part.needs_grip_type) // Will be replaced with a more modular system once V3 comes
				overlays += gun_part.part_overlay + "_" + grip_type + dashTag
			else
				overlays += gun_part.part_overlay + dashTag // Add the part's overlay, with respect to tags

			if(gun_part.part_itemstring) // Part also wants to modify itemstring
				itemstring += "_" + gun_part.part_overlay // Add their overlay name


	if (ammo_magazine) // Warning! If a sprite is missing from the DMI despite being possible to insert ingame, it might have unforeseen consequences (no magazine showing up)
		itemstring += "_full"
		overlays += "mag_[ammo_magazine.mag_well][caliber]" + dashTag

	if(wielded)
		itemstring += "_doble" // Traditions are to be followed

	// Finally, we add the dashTag to the itemstring
	itemstring += dashTag

	visible_message(SPAN_WARNING("[itemstring]"))
	icon_state = iconstring
	wielded_item_state = itemstring // Hacky solution to a hacky system. Reere forgive us. V3 will fix this.
	set_item_state(itemstring)
/*
/obj/item/gun/projectile/automatic/modular/ak/update_icon_defunct() // V1
	..()
	cut_overlays()

	var/iconstring = stock == STOCK_UNFOLDED ? initial(icon_state) + "-st" : initial(icon_state)
	var/itemstring = ""

	if(stock == STOCK_UNFOLDED) // Stock is unfolded
		var/grip_type = ""
		for(var/obj/item/part/gun/gun_part in gun_parts)
			if(gun_part.part_overlay) // TODO: clean this part up to be more modular before adding other modular guns

				if(istype(gun_part, /obj/item/part/gun/modular/grip))
					grip_type = gun_part.part_overlay
					overlays += "grip_" + grip_type + "-st"
					itemstring += "_grip_" + grip_type
				else
					overlays += gun_part.part_overlay + "-st"

				if(gun_part.part_overlay == "stock_frame") // If it is a stock, it'll also attempt to add the grip type
					overlays += "stock_" + grip_type + "-st"

	else // Stock is folded or missing
		for(var/obj/item/part/gun/gun_part in gun_parts)
			if(gun_part.part_overlay)
				if(istype(gun_part, /obj/item/part/gun/modular/grip))
					overlays += "grip_" + gun_part.part_overlay
				else
					overlays += gun_part.part_overlay

	if (ammo_magazine) // Warning! If a sprite is missing from the DMI despite being possible to insert ingame, it might have unforeseen consequences (no magazine showing up)
		itemstring += "_full"
		if(stock)
			overlays += "mag_[ammo_magazine.mag_well][caliber]-st"
		else
			overlays += "mag_[ammo_magazine.mag_well][caliber]"

	if(wielded)
		itemstring += "_doble" // Traditions are to be followed

	if(!(stock == STOCK_UNFOLDED))
		itemstring += "_f"

	visible_message(SPAN_WARNING("[itemstring]"))
	icon_state = iconstring
	set_item_state(itemstring)
*/
/obj/item/part/gun/modularframe
	name = "\"Kalashnikov\" frame"
	desc = "An AK rifle frame. The eternal firearm. Universal design accepts .20, .25 and .30 barrels, as well as any grips. Requires an autorifle mechanism."
	icon_state = "frame_ak"
	generic = FALSE

	// List of parts required to assemble
	var/list/required_parts = list(/obj/item/part/gun/modular/mechanism/autorifle = 0, /obj/item/part/gun/modular/barrel = 0, /obj/item/part/gun/modular/stock = -1, /obj/item/part/gun/modular/grip = 0)

	// The resulting type of modular gun
	var/result = /obj/item/gun/projectile/automatic/modular/ak

	var/serial_type = ""

	// Determines what type of barrels can be installed, dependant on mechanism
	var/list/good_calibers = list()

/obj/item/part/gun/modularframe/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/part/gun))
		for(var/TryPart in required_parts)
			if(istype(I, TryPart))
				handle_install(I, user, TryPart)
				return
		to_chat(user, SPAN_WARNING("This part is not suitable!"))
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
				handle_uninstall(toremove, user)

	return ..()


/obj/item/part/gun/modularframe/proc/handle_install(obj/item/I, mob/living/user, var/InstallPath)
	if(istype(required_parts[InstallPath], InstallPath))
		to_chat(user, SPAN_WARNING("A part of this type is already installed!"))
		return


	// Caliber check coming for barrels
	if(istype(I, /obj/item/part/gun/modular/barrel))
		var/has_mechanism = FALSE
		for(var/Check_Mechanism in required_parts) // Check for presence of mechanism
			if(istype(required_parts[Check_Mechanism], /obj/item/part/gun/modular/mechanism))
				var/obj/item/part/gun/modular/mechanism/M = required_parts[Check_Mechanism]
				var/obj/item/part/gun/modular/barrel/B = I
				if(M.accepted_calibers)
					if(!M.accepted_calibers.Find(B.caliber)) // Check for compatibility, if a mechanism doesn't define a caliber, it is a wildcard
						to_chat(user, SPAN_WARNING("The barrel does not fit the mechanism! The gun fits the following calibers: [english_list(M.accepted_calibers, "None are suitable!", " and ", ", ", ".")]"))
						return
				has_mechanism = TRUE
		if(!has_mechanism)
			to_chat(user, SPAN_WARNING("Install a mechanism before adding a barrel!"))
	else if(istype(I, /obj/item/part/gun/modular/mechanism))
		for(var/Check_Barrel in required_parts) // Check for presence of barrel
			if(istype(required_parts[Check_Barrel], /obj/item/part/gun/modular/barrel))
				var/obj/item/part/gun/modular/barrel/B = required_parts[Check_Barrel]
				var/obj/item/part/gun/modular/mechanism/M = I
				if(M.accepted_calibers)
					if(!M.accepted_calibers.Find(B.caliber)) // Check for compatibility, if a mechanism doesn't define a caliber, it is a wildcard
						to_chat(user, SPAN_WARNING("The barrel does not fit the mechanism! The gun fits the following calibers: [english_list(M.accepted_calibers, "None are suitable!", " and ", ", ", ".")]"))
						return

	// Attempt inserting the item
	if(insert_item(I, user))

		// Set caliber if mechanism


		// Reference the part in our type list
		required_parts[InstallPath] = I
		to_chat(user, SPAN_NOTICE("You attach the [I] to \the [src]."))


/obj/item/part/gun/modularframe/proc/handle_uninstall(obj/item/I, mob/living/user)
	eject_item(I, user)
	for(var/Part in required_parts)
		if(required_parts[Part] == I)
			required_parts[Part] = 0

/obj/item/part/gun/modularframe/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(src)

	var/obj/item/gun/G = new result(T)
	G.serial_type = serial_type
	for(var/Part in required_parts)
		if(istype(required_parts[Part],Part))
			var/obj/item/part/gun/GunPart = required_parts[Part]
			if(!SEND_SIGNAL(GunPart, COMSIG_IATTACK, G, null))
				to_chat(user, SPAN_WARNING("There was a problem during the assembly! Maybe you should ask a professional for help?")) // Something failed, not a good sign.
			G.gun_parts += required_parts[Part] // Add the item to reference list
		else if(required_parts[Part] == 0)
			to_chat(user, SPAN_WARNING("Something seems wrong... Maybe you should ask a professional for help?"))
	G.update_icon()
	qdel(src)
	return

/obj/item/part/gun/modularframe/examine(user, distance)
	. = ..()
	if(.)
		for(var/ExaminePart in required_parts)
			if(required_parts[ExaminePart])
				to_chat(user, SPAN_NOTICE("\the [src] has \a [required_parts[ExaminePart]] installed."))

		if(in_range(user, src) || isghost(user))
			if(serial_type)
				to_chat(user, SPAN_WARNING("There is a serial number on the frame, it reads [serial_type]."))
			else if(isnull(serial_type))
				to_chat(user, SPAN_DANGER("The serial is scribbled away."))



/*///// YAHHOO
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
					var/obj/item/part/gun/modular/grip/InstalledGrip

					// Which grips does the frame accept?
					var/list/gripvars = list(/obj/item/part/gun/modular/grip/wood, /obj/item/part/gun/modular/grip/black)
					// What are the results (in order relative to gripvars)?
					var/list/resultvars = list(/obj/item/gun/projectile, /obj/item/gun/energy)

					// Currently installed mechanism
					var/obj/item/part/gun/modular/grip/InstalledMechanism
					// Which mechanism the frame accepts?
					var/list/mechanismvar = /obj/item/part/gun/modular/mechanism

					// Currently installed barrel
					var/obj/item/part/gun/modular/barrel/InstalledBarrel
					// Which barrels does the frame accept?
					var/list/barrelvars = list(/obj/item/part/gun/modular/barrel)

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
					if(istype(I, /obj/item/part/gun/modular/grip))
						if(InstalledGrip)
							to_chat(user, SPAN_WARNING("[src] already has a grip attached!"))
							return
						else
							handle_gripvar(I, user)

					if(istype(I, /obj/item/part/gun/modular/mechanism))
						if(InstalledMechanism)
							to_chat(user, SPAN_WARNING("[src] already has a mechanism attached!"))
							return
						else
							handle_mechanismvar(I, user)

					if(istype(I, /obj/item/part/gun/modular/barrel))
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
								if(istype(toremove, /obj/item/part/gun/modular/grip))
									InstalledGrip = null
								else if(istype(toremove, /obj/item/part/gun/modular/barrel))
									InstalledBarrel = FALSE
								else if(istype(toremove, /obj/item/part/gun/modular/mechanism))
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
*/
/*
/obj/item/gun/projectile/automatic/ak47/proc/can_interact(mob/user)
	if((!ishuman(user) && (loc != user)) || user.stat || user.restrained())
		return 1
	if(istype(loc, /obj/item/storage))
		return 2
	return 0

/obj/item/gun/projectile/automatic/ak47/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(gilded)
		iconstring += "_gold"
		itemstring += "_gold"

	if (ammo_magazine)
		itemstring += "_full"
		if (ammo_magazine.mag_well == MAG_WELL_RIFLE_L)
			iconstring += "_l"
		if (ammo_magazine.mag_well == MAG_WELL_RIFLE_D)
			iconstring += "_drum"
		else
			iconstring += "[ammo_magazine? "_mag[ammo_magazine.max_ammo]": ""]"

	if(wielded)
		itemstring += "_doble"

	if(folded)
		iconstring += "_f"
		itemstring += "_f"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/ak47/Initialize()
	. = ..()
	update_icon()
*/
