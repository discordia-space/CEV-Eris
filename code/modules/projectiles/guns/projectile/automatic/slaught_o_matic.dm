/obj/item/gun/projectile/automatic/slaught_o_matic
	name = "FS HG .35 Auto \"Slaught-o-Matic\""
	desc = "This disposable plastic handgun is mass-produced by Frozen Star for civilian use. It often is used by street urchin, thugs, or terrorists on a budget. For what it's worth, it's not an awful handgun - but you only get one magazine before the gun locks up and becomes useless."
	icon = 'icons/obj/guns/projectile/slaught_o_matic.dmi'
	icon_state = "slaught"
	item_state = "slaught"
	volumeClass = ITEM_SIZE_SMALL
	can_dual = 1
	caliber = CAL_PISTOL
	atomFlags = AF_ICONGRABNEEDSINSTANTATION
	max_shells = 0
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	auto_eject = FALSE
	serial_type = "FS"
	magazine_type = /obj/item/ammo_magazine/smg
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 9)
	price_tag = 100
	rarity_value = 40
	gun_parts = list(/obj/item/stack/material/plastic = 2)

	safety = FALSE
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	var/list/possible_colors = list("purple", "magenta", "blue", "cyan", "aqua", "green", "yellow", "orange", "red" )
	var/choosen_color = ""

	damage_multiplier = 0.8
	init_recoil = HANDGUN_RECOIL(1.6)

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_300,
		FULL_AUTO_800
		)
	wield_delay = 0


/obj/item/gun/projectile/automatic/slaught_o_matic/Initialize()
	. = ..()
	ammo_magazine = new magazine_type(src)

	restrict_safety = TRUE // We need safty switch but we can not use him

	choosen_color = pick(possible_colors)
	update_icon()

/obj/item/gun/projectile/automatic/slaught_o_matic/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = "_" + choosen_color

	wielded_item_state = "_doble_" + choosen_color

	icon_state = iconstring + itemstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/slaught_o_matic/load_ammo(obj/item/A, mob/user)
	to_chat(user, SPAN_WARNING("You try to reload the handgun, but the magazine that's already loaded won't come out!"))

/obj/item/gun/projectile/automatic/slaught_o_matic/unload_ammo(mob/user, var/allow_dump=1)
	to_chat(user, SPAN_WARNING("You try to take out the handgun's magazine, but it won't budge!"))
