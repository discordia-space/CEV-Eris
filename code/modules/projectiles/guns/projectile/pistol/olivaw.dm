/obj/item/gun/projectile/olivaw
	name = "FS69P .35 Auto \"Olivaw\""
	desc = "A popular \"Frozen Star\"69achine pistol. This one has a two-round burst-fire69ode and is chambered for .35 auto. It can use69ormal and high capacity69agazines."
	icon = 'icons/obj/guns/projectile/olivawcivil.dmi'
	icon_state = "olivawcivil"
	item_state = "pistol"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	can_dual = TRUE
	caliber = CAL_PISTOL
	load_method =69AGAZINE
	mag_well =69AG_WELL_PISTOL|MAG_WELL_H_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	matter = list(MATERIAL_PLASTEEL = 12,69ATERIAL_WOOD = 6)
	price_tag = 600
	damage_multiplier = 1.2
	penetration_multiplier = 1.2
	recoil_buildup = 2
	init_firemodes = list(
		list(mode_name="semiauto",69ode_desc="Fire almost as fast as you can pull the trigger", burst=1, fire_delay=1.2,69ove_delay=null, 				icon="semi"),
		list(mode_name="2-round bursts",69ode_desc="Not 69uite the69ozambi69ue69ethod", burst=2, fire_delay=0.2,69ove_delay=4,    	icon="burst"),
		)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE

/obj/item/gun/projectile/olivaw/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"
