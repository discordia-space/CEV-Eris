/obj/item/gun/projectile/shotgun/bull
	name = "FS SG \"Bull\""
	desc = "A \"Frozen Star\" double-barreled pump-action shotgun. Marvel of engineering, this gun is often used by Ironhammer tactical units. \
			Due to shorter than usual barrels, damage are somewhat lower and recoil kicks slightly harder, but possibility to fire two barrels at once overshadows all bad design flaws. Can hold up to 7+2 shells."
	icon = 'icons/obj/guns/projectile/bull.dmi'
	icon_state = "bull"
	item_state = "bull"
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	max_shells = 7
	volumeClass = ITEM_SIZE_HUGE
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	var/reload = 1
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 6)
	damage_multiplier = 1.1
	init_recoil = CARBINE_RECOIL(1.5)
	burst_delay = null
	fire_delay = 4
	bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	init_firemodes = list(
		list(mode_name="Single-fire", mode_desc="Send Vagabonds flying back several paces", burst=1, icon="semi"),
		list(mode_name="Both Barrels", mode_desc="Give them the side-by-side", burst=2, icon="burst"),
		)

	spawn_tags = SPANW_TAG_FS_SHOTGUN
	price_tag = 2000 //gives tactical advantage with beanbags, but consumes more ammo and hits less harder with lethal ammo, so Gladstone or Regulator would be better for lethal takedowns in general
	gun_parts = list(/obj/item/part/gun/frame/bull = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/shotgun = 1, /obj/item/part/gun/modular/barrel/shotgun = 1)
	serial_type = "FS"

/obj/item/gun/projectile/shotgun/bull/proc/pump(mob/M as mob)
	var/turf/newloc = get_turf(src)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(chambered)
		if(!chambered.BB)
			chambered.forceMove(newloc) //Eject casing
			chambered = null
	if(!chambered)
		if(loaded.len)
			var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
			loaded -= AC //Remove casing from loaded list.
			chambered = AC
			if(chambered.BB != null)
				reload = 0
	update_icon()

/obj/item/gun/projectile/shotgun/bull/consume_next_projectile()
	if (chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/bull/handle_post_fire()
	..()
	var/turf/newloc = get_turf(src)
	if(chambered)
		chambered.forceMove(newloc) //Eject casing
		chambered = null
		if(!reload)
			if(loaded.len)
				var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
				loaded -= AC //Remove casing from loaded list.
				chambered = AC
	reload = 1

/obj/item/gun/projectile/shotgun/bull/unload_ammo(user, allow_dump)
	var/turf/newloc = get_turf(src)
	if(chambered)
		chambered.forceMove(newloc) //Eject casing
		chambered = null
		reload = 1
	..(user, allow_dump=1)

/obj/item/gun/projectile/shotgun/bull/attack_self(mob/user as mob)
	if(reload)
		pump(user)
	else
		if(firemodes.len > 1)
			..()
		else
			unload_ammo(user)

/obj/item/gun/projectile/shotgun/bull/proc/update_charge()
	var/ratio = get_ammo() / (max_shells + 1)//1 in the chamber
	ratio = round(ratio, 0.25) * 100
	overlays += "[ratio]_PW"

/obj/item/gun/projectile/shotgun/bull/update_icon()
	..()
	var/ratio = get_ammo() / (max_shells + 1)
	ratio = round(ratio, 0.25) * 100
	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(ratio > 0)
		wielded_item_state = "_doble_mag"
	else
		wielded_item_state = "_doble"
		itemstring += "_empty"

	icon_state = iconstring
	set_item_state(itemstring)
	cut_overlays()
	update_held_icon()
	update_charge()

/obj/item/part/gun/frame/bull
	name = "Bull frame"
	desc = "A Bull shotgun frame. Double-barrel and pump action, through a miracle of engineering."
	icon_state = "frame_bull"
	resultvars = list(/obj/item/gun/projectile/shotgun/bull)
	gripvars = list(/obj/item/part/gun/modular/grip/rubber)
	mechanismvar = /obj/item/part/gun/modular/mechanism/shotgun
	barrelvars = list(/obj/item/part/gun/modular/barrel/shotgun)
