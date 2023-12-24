/obj/item/gun/projectile/shotgun/pump/grenade
	name = "NT GL \"Protector\""
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon = 'icons/obj/guns/launcher/riotgun.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	volumeClass = ITEM_SIZE_BULKY
	caliber = CAL_GRENADE
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 5
	init_recoil = CARBINE_RECOIL(2)
	twohanded = TRUE
	ammo_type = /obj/item/ammo_casing/grenade
	fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
	fire_sound_text = "a metallic thunk"
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'	//Placeholder, could use a new sound
	saw_off = FALSE
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_WOOD = 10)
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	price_tag = 3000
	gun_parts = list(/obj/item/part/gun = 2, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/shotgun = 1)
	serial_type = "NT"
	move_delay = 3

/obj/item/gun/projectile/shotgun/pump/grenade/update_icon()
	wielded_item_state = "_doble"

/obj/item/gun/projectile/shotgun/pump/grenade/examine(mob/user)
	..(user, afterDesc = chambered ? "\A [chambered] is chambered " : "")

/obj/item/gun/projectile/shotgun/pump/grenade/handle_post_fire(mob/user)
	log_and_message_admins("fired a grenade ([chambered]) from ([src]).")
	user.attack_log += "\[[time_stamp()]\] fired a grenade ([chambered]) from ([src])"
	..()

/obj/item/gun/projectile/shotgun/pump/grenade/proc/load_underslung(obj/item/ammo_casing/grenade/G, mob/user)
	if(chambered)
		to_chat(user, SPAN_WARNING("[src] is full!"))
		return
	user.remove_from_mob(G)
	G.forceMove(src)
	chambered = G
	playsound(src.loc, bulletinsert_sound, 75, 1)

/obj/item/gun/projectile/shotgun/pump/grenade/proc/unload_underslung(mob/user)
	if(chambered)
		var/turf/turf = get_turf(src)
		chambered.forceMove(turf)
		to_chat(user, "You remove \a [chambered] from [src].")
		chambered = null

// Underslung grenade launcher to be used with the Z8
/obj/item/gun/projectile/shotgun/pump/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	volumeClass = ITEM_SIZE_NORMAL
	matter = null
	max_shells = 0
	safety = FALSE
	twohanded = FALSE

/obj/item/gun/projectile/shotgun/pump/grenade/lenar
	name = "FS GL \"Lenar\""
	desc = "A more than bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon = 'icons/obj/guns/launcher/grenadelauncher.dmi'
	icon_state = "Grenadelauncher_PMC"
	item_state = "pneumatic"
	volumeClass = ITEM_SIZE_HUGE
	init_recoil = RIFLE_RECOIL(2)
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_PLASTIC = 10)
	fire_sound = 'sound/weapons/empty.ogg'
	gun_parts = list(/obj/item/part/gun = 2, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/shotgun = 1)
	serial_type = "FS"

/obj/item/gun/projectile/shotgun/pump/grenade/lenar/proc/update_charge()
	var/ratio = (contents.len + (chambered? 1 : 0)) / (max_shells + 1.2)
	if(ratio < 0.33 && ratio != 0)
		ratio = 0.33
	ratio = round(ratio, 0.33) * 100
	overlays += "grenademag_[ratio]"

/obj/item/gun/projectile/shotgun/pump/grenade/lenar/update_icon()
	..()
	wielded_item_state = "_doble"
	set_item_state()
	cut_overlays()
	update_charge()

/obj/item/gun/projectile/shotgun/pump/grenade/makeshift
	name = "HM GL \"Civil Disobedience\""
	desc = "Your own homemade China Lake. Best used to inform the powers that be of your displeasure with the system."
	icon = 'icons/obj/guns/launcher/makeshift.dmi'
	icon_state = "makeshift"
	item_state = "makeshift"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	price_tag = 500
	max_shells = 0
	spawn_blacklisted = FALSE//this may be a bad idea // it wasn't , 2022 - SPCR
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	serial_type = ""

/obj/item/gun/projectile/shotgun/pump/grenade/makeshift/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/grenade)))
		load_underslung(I, user)
	else
		..()

/obj/item/gun/projectile/shotgun/pump/grenade/makeshift/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload_underslung(user)
	else
		..()

/obj/item/gun/projectile/shotgun/pump/grenade/makeshift/pump(mob/user)
	unload_underslung(user)

/obj/item/gun/projectile/shotgun/pump/grenade/china
	name = "China Lake"
	desc = "This centuries-old design was recently rediscovered and adapted for use in modern battlefields. \
		Working similar to a pump-action combat shotgun, its light weight and robust design quickly made it a popular weapon. \
		It uses specialised grenade shells."

	icon = 'icons/obj/guns/projectile/chinalake.dmi'
	icon_state = "china_lake"
	item_state = "china_lake"

	max_shells = 3
	init_recoil = CARBINE_RECOIL(1.5)
	ammo_type = /obj/item/ammo_casing/grenade

	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_WOOD = 10)
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)

	serial_type = "FS"

	price_tag = 4500
