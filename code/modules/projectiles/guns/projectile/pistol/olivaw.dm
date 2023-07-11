/obj/item/gun/projectile/olivaw
	name = "FS MP .35 Auto \"Olivaw\""
	desc = "A popular \"Frozen Star\" machine pistol. This one has a two-round burst-fire mode and is chambered for .35 auto. It can use normal and high capacity magazines."
	icon = 'icons/obj/guns/projectile/olivawcivil.dmi'
	icon_state = "olivawcivil"
	item_state = "pistol"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	can_dual = TRUE
	caliber = CAL_PISTOL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 600
	damage_multiplier = 1.2
	penetration_multiplier = 0
	init_recoil = HANDGUN_RECOIL(0.9)
	init_firemodes = list(
		list(mode_name="semiauto", mode_desc="Fire almost as fast as you can pull the trigger", burst=1, fire_delay=1.2, icon="semi"),
		list(mode_name="2-round bursts", mode_desc="Not quite the Mozambique method", burst=2, fire_delay=0.2, icon="burst"),
		)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/olivaw = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "FS"

/obj/item/gun/projectile/olivaw/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"

/obj/item/part/gun/frame/olivaw
	name = "Olivaw frame"
	desc = "An Olivaw pistol frame. Why shoot one bullet when you can shoot two?"
	icon_state = "frame_olivaw"
	resultvars = list(/obj/item/gun/projectile/olivaw)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)
