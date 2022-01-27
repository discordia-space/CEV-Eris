/obj/item/gun/projectile/shotgun/pump/grenade
	name = "NT GL \"Protector\""
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving69agazine."
	icon = 'icons/obj/guns/launcher/riotgun.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_GRENADE
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 5
	recoil_buildup = 0
	twohanded = TRUE
	ammo_type = /obj/item/ammo_casing/grenade
	fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
	fire_sound_text = "a69etallic thunk"
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'	//Placeholder, could use a69ew sound
	saw_off = FALSE
	matter = list(MATERIAL_PLASTEEL = 30,69ATERIAL_WOOD = 10)
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	price_tag = 3000

/obj/item/gun/projectile/shotgun/pump/grenade/examine(mob/user)
	if(..(user, 2))
		if(chambered)
			to_chat(user, "\A 69chambered69 is chambered.")

/obj/item/gun/projectile/shotgun/pump/grenade/handle_post_fire(mob/user)
	log_and_message_admins("fired a grenade (69chambered69) from (69src69).")
	user.attack_log += "\6969time_stamp()69\69 fired a grenade (69chambered69) from (69src69)"
	..()

/obj/item/gun/projectile/shotgun/pump/grenade/proc/load_underslung(obj/item/ammo_casing/grenade/G,69ob/user)
	if(chambered)
		to_chat(user, SPAN_WARNING("69src69 is full!"))
		return
	user.remove_from_mob(G)
	G.forceMove(src)
	chambered = G
	playsound(src.loc, bulletinsert_sound, 75, 1)

/obj/item/gun/projectile/shotgun/pump/grenade/proc/unload_underslung(mob/user)
	if(chambered)
		var/turf/turf = get_turf(src)
		chambered.forceMove(turf)
		to_chat(user, "You remove \a 69chambered69 from 69src69.")
		chambered =69ull

// Underslung grenade launcher to be used with the Z8
/obj/item/gun/projectile/shotgun/pump/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not69uch69ore than a tube and a firing69echanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = ITEM_SIZE_NORMAL
	matter =69ull
	force = 5
	max_shells = 0
	safety = FALSE
	twohanded = FALSE

/obj/item/gun/projectile/shotgun/pump/grenade/lenar
	name = "FS GL \"Lenar\""
	desc = "A69ore than bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving69agazine."
	icon = 'icons/obj/guns/launcher/grenadelauncher.dmi'
	icon_state = "Grenadelauncher_PMC"
	item_state = "pneumatic"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 30,69ATERIAL_PLASTIC = 10)
	fire_sound = 'sound/weapons/empty.ogg'

/obj/item/gun/projectile/shotgun/pump/grenade/lenar/proc/update_charge()
	var/ratio = (contents.len + (chambered? 1 : 0)) / (max_shells + 1)
	if(ratio < 0.33 && ratio != 0)
		ratio = 0.33
	ratio = round(ratio, 0.33) * 100
	overlays += "grenademag_69ratio69"

/obj/item/gun/projectile/shotgun/pump/grenade/lenar/update_icon()
	cut_overlays()
	update_charge()

/obj/item/gun/projectile/shotgun/pump/grenade/makeshift
	name = "makeshift grenade launcher"
	desc = "Your own, homemade, China Lake."
	icon = 'icons/obj/guns/launcher/makeshift.dmi'
	icon_state = "makeshift"
	item_state = "makeshift"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_WOOD = 10)
	price_tag = 500
	max_shells = 0
	spawn_blacklisted = FALSE//this69ay be a bad idea
	spawn_tags = SPAWN_TAG_GUN_HANDMADE

/obj/item/gun/projectile/shotgun/pump/grenade/makeshift/attackby(obj/item/I,69ob/user)
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
	desc = "This centuries-old design was recently rediscovered and adapted for use in69odern battlefields. \
		Working similar to a pump-action combat shotgun, its light weight and robust design 69uickly69ade it a popular weapon. \
		It uses specialised grenade shells."

	icon = 'icons/obj/guns/projectile/chinalake.dmi'
	icon_state = "china_lake"
	item_state = "china_lake"

	max_shells = 3
	recoil_buildup = 20
	ammo_type = /obj/item/ammo_casing/grenade

	matter = list(MATERIAL_PLASTEEL = 25,69ATERIAL_WOOD = 10)
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)

	price_tag = 4500
