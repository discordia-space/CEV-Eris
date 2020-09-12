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

	name = get_weapon_name(capitalize = TRUE)

	var/random_icon = rand(1,5)
	icon_state = "artwork_revolver_[random_icon]"
	item_state = "artwork_revolver_[random_icon]"

	max_shells += rand(-2,5)

	var/sanity_value = 0.2 + pick(0,0.1,0.2)
	AddComponent(/datum/component/atom_sanity, sanity_value, "")

	//var/gun_pattern = pick("pistol","magnum","shotgun","rifle","sniper","gyro","cap","rocket","grenade")

	damage_multiplier += pick(-0.2,-0.1,0,0.1,0.2)
	penetration_multiplier += pick(-0.2,-0.1,0,0.1,0.2)
	recoil_buildup += rand(-(recoil_buildup / 5),(recoil_buildup / 5))

	price_tag += rand(-1000,2500)//Sellable to either the Cargo Console or to people onboard the Eris, Temporary value

	desc += " [get_gun_description()] Uses [caliber] rounds." //Temporary description

	.=..()
