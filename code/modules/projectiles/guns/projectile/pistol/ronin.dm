/obj/item/gun/projectile/ronin
	name = "SA HG .20 \"Ronin\""
	desc = " A handgun which was designed with hit and run tactics in mind, not the most powerful firearm but its ability to reliably penetrate armor and ricochet rounds of walls make it a choice for celebrities. and playboys looking to be a nuisance..."
	icon = 'icons/obj/guns/projectile/ronin.dmi'
	icon_state = "silverhand"
	item_state = "silverhand"
	w_class = ITEM_SIZE_NORMAL
	can_dual = TRUE
	silenced = TRUE
	fire_sound = 'sound/weapons/guns/fire/revolver_fire.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 5000 //On par with the Dallas in terms of rarity
	caliber = CAL_SRIFLE
	ammo_type = /obj/item/ammo_casing/srifle
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/srifle/short
	proj_step_multiplier = 1.2
	damage_multiplier = 0.8
	penetration_multiplier = 0.5 // penetrates much more reliably than most rifles
	init_recoil = HANDGUN_RECOIL(0.6)
	serial_type = "SA"


/obj/item/gun/projectile/ronin/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		wielded_item_state += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/ronin/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/ronin/tileattack(mob/living/user, turf/targetarea, var/modifier = 1, var/swing_degradation = 0.2, var/original_target)
	new /obj/effect/temp_visual/fire(targetarea)
	return ..()

/obj/item/gun/projectile/ronin/hand_spin(mob/living/carbon/caller)
	swing_attack(get_step(get_turf(src), caller.dir), caller)
	return ..()

/obj/effect/temp_visual/fire
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	light_range = 3
	light_color = "#FAA019"
	color = "#FAA019"
	duration = 10

/obj/effect/temp_visual/fire/Initialize(mapload)
	var/turf/location = get_turf(src)
	// Sets people on fire
	for(var/mob/living/L in location)
		L.adjust_fire_stacks(4)
		L.IgniteMob()
	// Sets items on fire
	if(location)
		location.hotspot_expose(700, 50, 1)
	return ..()
