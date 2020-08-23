/obj/item/weapon/gun/projectile/revolver/artwork_revolver
	name = "Weird Revolver"
	desc = "This is an artistically-made revolver. On the revolver is "//Temporary description
	icon = 'icons/obj/guns/projectile/artwork_revolver.dmi'
	icon_state = "artwork_revolver"
	item_state = "artwork_revolver"
	drawChargeMeter = FALSE
	max_shells = 5
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4) //Arbitrary values
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 2500 //Temporary value
	damage_multiplier = 1.4 //because pistol round //From havelock.dm
	penetration_multiplier = 1.4
	recoil_buildup = 30 //Arbitrary value


/obj/item/weapon/gun/projectile/revolver/artwork_revolver/Initialize()
	..()

	name = get_weapon_name(capitalize = TRUE)

	var/random_icon = rand(1,5)
	icon_state = "artwork_revolver_[random_icon]"
	item_state = "artwork_revolver_[random_icon]"

	max_shells += rand(-2,5)

	var/sanity_value = 0.2 + pick(0,0.1,0.2)
	AddComponent(/datum/component/atom_sanity, sanity_value, "")

	var/gun_pattern = pick("pistol","magnum","shotgun","rifle","sniper","gyro","cap","rocket","dart",)

	switch(gun_pattern)

		if("pistol") //From havelock.dm, Arbitrary Values
			caliber = pick(CAL_PISTOL, CAL_35A)
			damage_multiplier = 1.4
			penetration_multiplier = 1.4
			recoil_buildup = 18

		if("magnum") //From consul.dm, Arbitrary values
			caliber = CAL_MAGNUM
			damage_multiplier = 1.35
			penetration_multiplier = 1.5
			recoil_buildup = 35

		if("shotgun") //From bull.dm, Arbitrary values
			caliber = CAL_SHOTGUN
			damage_multiplier = 0.75
			penetration_multiplier = 0.75
			recoil_buildup = 38 //from Mateba.dm, Arbitrary values
			bulletinsert_sound = 'sound/weapons/guns/interact/shotgun_insert.ogg'
			fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'

			if(max_shells == 3)
				init_firemodes = list(
					list(mode_name="fire one barrel at a time", burst=1, icon="semi"),
					list(mode_name="fire three barrels at once", burst=3, icon="auto"),
					)

		if("rifle")
			caliber = pick(CAL_CLRIFLE, CAL_SRIFLE, CAL_LRIFLE)
			fire_sound = 'sound/weapons/guns/fire/smg_fire.ogg'
//
//No gun currently uses CAL_357 far as I know
//		if("revolver")
//			caliber = pick(CAL_357)

		if("sniper")//From sniper.dm, Arbitrary values
			caliber = CAL_ANTIM
			bulletinsert_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
			fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
			one_hand_penalty = 15 //From ak47.dm

		if("gyro")//From gyropistol.dm, Arbitrary values
		 caliber = CAL_70
		 recoil_buildup = 0.1

		if("cap")
			caliber = CAL_CAP

		if("rocket")//From RPG.dm, Arbitrary values
			caliber = CAL_ROCKET
			fire_sound = 'sound/effects/bang.ogg'
			bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
			one_hand_penalty = 15 //From ak47.dm
			recoil_buildup = 0.2

			if(max_shells == 3)//From Timesplitters triple-firing RPG far as I know
				init_firemodes = list(
					list(mode_name="fire one barrel at a time", burst=1, icon="semi"),
					list(mode_name="fire three barrels at once", burst=3, icon="auto"),
					)

		if("dart")//from dartgun.dm, Arbitrary values
			caliber = CAL_DART
			fire_sound = 'sound/weapons/empty.ogg'
			recoil_buildup = 0
			silenced = 1

	desc += " [get_gun_description()] Uses [caliber] rounds." //Temporary description
