/obj/item/weapon/gun/projectile/shotgun/bull
	name = "FS SG \"Bull\""
	desc = "A Frozen Star double-barreled pump action shotgun. Marvel of engineering, this gun  often use by police SWAT teams."
	icon_state = "PeaceWalker"
	item_state = "PW"
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	max_shells = 6
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFULL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	var/reload = 1
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)
	burst_delay = null
	fire_delay = null
	bulletinsert_sound 	= 'sound/weapons/guns/interact/shotgun_instert.ogg'
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	move_delay = null
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/weapon/gun/projectile/shotgun/bull/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(chambered)
		if(!chambered.BB)
			chambered.loc = get_turf(src)//Eject casing
			chambered = null
	if(!chambered)
		if(loaded.len)
			var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
			loaded -= AC //Remove casing from loaded list.
			chambered = AC
			if(chambered.BB != null)
				reload = 0
	update_icon()

/obj/item/weapon/gun/projectile/shotgun/bull/consume_next_projectile()
	if (chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/bull/handle_post_fire()
	..()
	if(chambered)
		chambered.loc = get_turf(src)//Eject casing
		chambered = null
		if(reload == 0)
			if(loaded.len)
				var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
				loaded -= AC //Remove casing from loaded list.
				chambered = AC
	reload = 1

/obj/item/weapon/gun/projectile/shotgun/bull/unload_ammo(user, allow_dump)
	if(chambered)
		chambered.loc = get_turf(src)//Eject casing
		chambered = null
		reload = 1
	..(user, allow_dump=1)

/obj/item/weapon/gun/projectile/shotgun/bull/attack_self(mob/user as mob)
	if(reload == 1)
		pump(user)
	else
		if(firemodes.len > 1)
			..()
		else
			unload_ammo(user)

/obj/item/weapon/gun/projectile/shotgun/bull/proc/update_charge()
	var/ratio = (loaded.len + (chambered? 1 : 0)) / max_shells
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	overlays += "[ratio]_PW"


/obj/item/weapon/gun/projectile/shotgun/bull/update_icon()
	overlays.Cut()
	update_charge()
