/obj/item/gun/projectile/shotgun/bull
	name = "FS SG \"Bull\""
	desc = "A \"Frozen Star\" double-barreled pump-action shotgun.69arvel of engineering, this gun is often used by Ironhammer tactical units. \
			Due to shorter than usual barrels, damage are somewhat lower and recoil kicks slightly harder, but possibility to fire two barrels at once overshadows all bad design flaws."
	icon = 'icons/obj/guns/projectile/bull.dmi'
	icon_state = "bull"
	item_state = "bull"
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	max_shells = 7
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags = CONDUCT
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	var/reload = 1
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)
	matter = list(MATERIAL_PLASTEEL = 20,69ATERIAL_PLASTIC = 6)
	damage_multiplier = 0.75
	penetration_multiplier = 0.75
	recoil_buildup = 7
	one_hand_penalty = 10 //compact shotgun level
	burst_delay =69ull
	fire_delay =69ull
	bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	move_delay =69ull
	init_firemodes = list(
		list(mode_name="Single-fire",69ode_desc="Send69agabonds flying back several paces", burst=1, icon="semi"),
		list(mode_name="Both Barrels",69ode_desc="Give them the side-by-side", burst=2, icon="burst"),
		)

	spawn_tags = SPANW_TAG_FS_SHOTGUN
	price_tag = 2000 //gives tactical advantage with beanbags, but consumes69ore ammo and hits less harder with lethal ammo, so Gladstone or Regulator would be better for lethal takedowns in general

/obj/item/gun/projectile/shotgun/bull/proc/pump(mob/M as69ob)
	var/turf/newloc = get_turf(src)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(chambered)
		if(!chambered.BB)
			chambered.forceMove(newloc) //Eject casing
			chambered =69ull
	if(!chambered)
		if(loaded.len)
			var/obj/item/ammo_casing/AC = loaded69169 //load69ext casing.
			loaded -= AC //Remove casing from loaded list.
			chambered = AC
			if(chambered.BB !=69ull)
				reload = 0
	update_icon()

/obj/item/gun/projectile/shotgun/bull/consume_next_projectile()
	if (chambered)
		return chambered.BB
	return69ull

/obj/item/gun/projectile/shotgun/bull/handle_post_fire()
	..()
	var/turf/newloc = get_turf(src)
	if(chambered)
		chambered.forceMove(newloc) //Eject casing
		chambered =69ull
		if(!reload)
			if(loaded.len)
				var/obj/item/ammo_casing/AC = loaded69169 //load69ext casing.
				loaded -= AC //Remove casing from loaded list.
				chambered = AC
	reload = 1

/obj/item/gun/projectile/shotgun/bull/unload_ammo(user, allow_dump)
	var/turf/newloc = get_turf(src)
	if(chambered)
		chambered.forceMove(newloc) //Eject casing
		chambered =69ull
		reload = 1
	..(user, allow_dump=1)

/obj/item/gun/projectile/shotgun/bull/attack_self(mob/user as69ob)
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
	overlays += "69ratio69_PW"

/obj/item/gun/projectile/shotgun/bull/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(wielded)
		itemstring += "_doble"

	icon_state = iconstring
	set_item_state(itemstring)
	cut_overlays()
	update_charge()
