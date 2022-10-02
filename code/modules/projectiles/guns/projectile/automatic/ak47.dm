/obj/item/gun/projectile/automatic/ak47
	name = "Excelsior .30 \"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
		 This is a high-quality copy, which has an automatic fire mode."
	icon = 'icons/obj/guns/projectile/ak/excel.dmi'
	icon_state = "AK"
	item_state = "AK"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_COVERT = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/lrifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	init_recoil = RIFLE_RECOIL(0.8)
	damage_multiplier = 1
	penetration_multiplier = 0
	spawn_blacklisted = TRUE
	gun_parts = list(/obj/item/part/gun/frame/ak47 = 1, /obj/item/part/gun/grip/excel = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/lrifle = 1)

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300,
		BURST_5_ROUND
		)
	serial_type = "Excelsior"

	var/folded = FALSE

/obj/item/part/gun/frame/ak47
	name = "AK frame"
	desc = "An AK rifle frame. The eternal firearm."
	icon_state = "frame_ak"
	result = /obj/item/gun/projectile/automatic/ak47
	gripvars = list(/obj/item/part/gun/grip/excel, /obj/item/part/gun/grip/serb, /obj/item/part/gun/grip/wood, /obj/item/part/gun/grip/rubber)
	resultvars = list(/obj/item/gun/projectile/automatic/ak47, /obj/item/gun/projectile/automatic/ak47/sa, /obj/item/gun/projectile/automatic/ak47/fs, /obj/item/gun/projectile/automatic/ak47/fs/ih)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle
	barrelvars = list(/obj/item/part/gun/barrel/lrifle)

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

//////////////////////////////////////////SA//////////////////////////////////////////

/obj/item/gun/projectile/automatic/ak47/sa
	name = "SA Car .30 \"Krinkov\""					// US nickname for AKSu
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
			This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
			It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
			This shortened rifle was made specifically for boarding actions with a folding stock and short barrel. \
			The flexible design also fits drum magazines."
	icon = 'icons/obj/guns/projectile/ak/krinkov.dmi'
	w_class = ITEM_SIZE_BULKY	// Small rifle, also because it's basically an smg now
	init_recoil = CARBINE_RECOIL(0.7)
	damage_multiplier = 0.9 // Better control, worse damage
	penetration_multiplier = 0.2
	mag_well = MAG_WELL_RIFLE|MAG_WELL_RIFLE_D

	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)

	gun_parts = list(/obj/item/part/gun/frame/ak47 = 1, /obj/item/part/gun/grip/serb = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/lrifle = 1)

	price_tag = 3500
	serial_type = "SA"


/obj/item/gun/projectile/automatic/ak47/sa/CtrlShiftClick(mob/user)
	. = ..()

	var/able = can_interact(user)

	if(able == 1)
		return

	if(able == 2)
		to_chat(user, SPAN_NOTICE("You cannot [folded ? "unfold" : "fold"] the stock while \the [src] is in a container."))
		return

	fold()


/obj/item/gun/projectile/automatic/ak47/sa/verb/quick_fold(mob/user)
	set name = "Fold or Unfold Stock"
	set category = "Object"
	set src in view(1)

	if(can_interact(user) == 1)
		return

	fold(user)

/obj/item/gun/projectile/automatic/ak47/sa/proc/fold(user)

	if(folded)
		to_chat(user, SPAN_NOTICE("You unfold the stock on \the [src]."))
		w_class = ITEM_SIZE_BULKY
		folded = FALSE
		init_recoil = CARBINE_RECOIL(0.7)
	else
		to_chat(user, SPAN_NOTICE("You fold the stock on \the [src]."))
		w_class = ITEM_SIZE_NORMAL
		folded = TRUE
		init_recoil = SMG_RECOIL(0.7)

	playsound(loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
	update_icon()

//////////////////////////////////////////FS//////////////////////////////////////////

/obj/item/gun/projectile/automatic/ak47/fs
	name = "FS AR .30 \"Vipr\""						// Vipr like a play on Viper and Vepr
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
			This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
			It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
			This cheap copy has been made to look as least militaristic as possible to be sold to as many civilian populations as possible."
	icon = 'icons/obj/guns/projectile/ak/vipr.dmi'
	w_class = ITEM_SIZE_HUGE
	init_recoil = RIFLE_RECOIL(0.7)
	damage_multiplier = 0.9 // civilian, you get what you get
	penetration_multiplier = 0

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	gun_tags = list(GUN_FA_MODDABLE, GUN_GILDABLE)

	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND,
		BURST_5_ROUND
	)

	price_tag = 1600
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	spawn_blacklisted = FALSE
	gun_parts = list(/obj/item/part/gun/frame/ak47 = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/lrifle = 1)
	serial_type = "FS"



//////////////////////////////////////////IH//////////////////////////////////////////

/obj/item/gun/projectile/automatic/ak47/fs/ih
	name = "FS AR .30 \"Venger\""						// From a song
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
			This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
			It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
			This rifle is from the Frozen Star's Planetary Defence line. Painted in IH blue and black, with a folding stock so it can be stored compactly for years without use."
	icon = 'icons/obj/guns/projectile/ak/venger.dmi'
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	gun_tags = list(GUN_FA_MODDABLE)
	gun_parts = list(/obj/item/part/gun/frame/ak47 = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/lrifle = 1)
	price_tag = 2000
	damage_multiplier = 1.1
	penetration_multiplier = 0

/obj/item/gun/projectile/automatic/ak47/fs/ih/CtrlShiftClick(mob/user)
	. = ..()

	var/able = can_interact(user)

	if(able == 1)
		return

	if(able == 2)
		to_chat(user, SPAN_NOTICE("The stock on \the [src] gets caught on the bag."))
		return

	fold()

/obj/item/gun/projectile/automatic/ak47/fs/ih/verb/quick_fold()	//Easier to redo the proc than redo everything else
	set name = "Fold or Unfold Stock"
	set category = "Object"
	set src in usr

	if(can_interact(usr) == 1)
		return
	fold(usr)

/obj/item/gun/projectile/automatic/ak47/fs/ih/proc/fold(user)

	if(folded)
		to_chat(user, SPAN_NOTICE("You unfold the stock on \the [src]."))
		w_class = ITEM_SIZE_HUGE
		folded = FALSE
		init_recoil = RIFLE_RECOIL(0.7)
	else
		to_chat(user, SPAN_NOTICE("You fold the stock on \the [src]."))
		w_class = ITEM_SIZE_BULKY
		folded = TRUE
		init_recoil = CARBINE_RECOIL(0.7)

	playsound(loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
	update_icon()

//////////////////////////////////////////Makeshift//////////////////////////////////////////

/obj/item/gun/projectile/automatic/ak47/makeshift
	name = "HM AR \"Sermak\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
			This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
			It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
			This crude copy shows just how forgiving the design can be."
	icon = 'icons/obj/guns/projectile/ak/kalash.dmi'
	w_class = ITEM_SIZE_HUGE
	init_recoil = RIFLE_RECOIL(0.7)
	gun_parts = list(/obj/item/part/gun = 3 ,/obj/item/stack/material/plasteel = 7)
	mag_well = MAG_WELL_RIFLE|MAG_WELL_IH|MAG_WELL_RIFLE_L|MAG_WELL_RIFLE_D

	origin_tech = list(TECH_COMBAT = 2)	//bad copies don't give good science
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	gun_tags = list(GUN_FA_MODDABLE)

	damage_multiplier = 1.1
	penetration_multiplier = 0

	init_firemodes = list(
		SEMI_AUTO_300	//too poorly made for burst or automatic
	)
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	matter = list(MATERIAL_STEEL = 22, MATERIAL_PLASTEEL = 18, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 12)
	price_tag = 500
	gun_parts = list(/obj/item/part/gun/frame/kalash = 1, /obj/item/part/gun/grip/wood = 1 , /obj/item/part/gun/mechanism/autorifle/steel = 1, /obj/item/part/gun/barrel/lrifle/steel = 1)
	serial_type = ""

/obj/item/part/gun/frame/kalash
	name = "Sermak frame"
	desc = "A Sermak rifle frame. Cobbled together, but as good as new. Sort of."
	icon_state = "frame_kalash"
	matter = list(MATERIAL_STEEL = 22, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 6)
	resultvars = list(/obj/item/gun/projectile/automatic/ak47/makeshift)
	gripvars = list(/obj/item/part/gun/grip/wood)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle/steel
	barrelvars = list(/obj/item/part/gun/barrel/lrifle/steel, /obj/item/part/gun/barrel/srifle/steel, /obj/item/part/gun/barrel/clrifle/steel)

