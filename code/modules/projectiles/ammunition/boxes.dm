/*This code for boxes with ammo, you cant use them as magazines, but should be able to fill magazines with them.*/
/obj/item/ammo_magazine/ammobox	//Should not be used bu its own
	name = "ammunition box"
	desc = "Gun ammunition stored in a shiny new box. You can see caliber information on the label."
	mag_type = SPEEDLOADER	//To prevent load in magazine filled guns
	icon = 'icons/obj/ammo.dmi'
	multiple_sprites = 1
	reload_delay = 30
	ammo_mag = "box"
	matter = list(MATERIAL_CARDBOARD = 1)

/obj/item/ammo_magazine/ammobox/resolve_attackby(atom/A, mob/user)
	if(isturf(A) && locate(/obj/item/ammo_casing) in A || istype(A, /obj/item/ammo_casing))
		if(!do_after(user, src.reload_delay, src))
			to_chat(user, SPAN_WARNING("You stoped scooping ammo into [src]."))
			return
		if(collectAmmo(get_turf(A), user))
			return TRUE
	..()

/obj/item/ammo_magazine/ammobox/proc/collectAmmo(var/turf/target, var/mob/user)
	ASSERT(istype(target))
	. = FALSE
	for(var/obj/item/ammo_casing/I in target)
		if(stored_ammo.len >= max_ammo)
			break
		if(I.caliber == src.caliber)
			for(var/j = 1 to I.amount)
				if(stored_ammo.len >= max_ammo)
					break
				. |= TRUE
				insertCasing(I)
	if(user)
		if(.)
			user.visible_message(SPAN_NOTICE("[user] scoopes some ammo in [src]."),SPAN_NOTICE("You scoop some ammo in [src]."),SPAN_NOTICE("You hear metal clanging."))
		else
			to_chat(user, SPAN_NOTICE("You fail to pick anything up with \the [src]."))
	update_icon()

/obj/item/ammo_magazine/ammobox/pistol
	name = "ammunition packet (.35 Auto)"
	icon_state = "pistol_l"
	matter = list(MATERIAL_STEEL = 6, MATERIAL_CARDBOARD = 1)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/pistol/practice
	name = "ammunition packet (.35 Auto practice)"
	icon_state = "pistol_p"
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/ammobox/pistol/hv
	name = "ammunition packet (.35 Auto high-velocity)"
	icon_state = "pistol_hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/ammobox/pistol/rubber
	name = "ammunition packet (.35 Auto rubber)"
	icon_state = "pistol_r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

//// . 40 ////

/obj/item/ammo_magazine/ammobox/magnum
	name = "ammunition packet (.40 Magnum)"
	icon_state = "magnum_l"
	matter = list(MATERIAL_STEEL = 9, MATERIAL_CARDBOARD = 1)
	caliber = CAL_MAGNUM
	ammo_type = /obj/item/ammo_casing/magnum
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/magnum/practice
	name = "ammunition packet (.40 Magnum practice)"
	icon_state = "magnum_p"
	ammo_type = /obj/item/ammo_casing/magnum/practice

/obj/item/ammo_magazine/ammobox/magnum/hv
	name = "ammunition packet (.40 Magnum high-velocity)"
	icon_state = "magnum_hv"
	ammo_type = /obj/item/ammo_casing/magnum/hv

/obj/item/ammo_magazine/ammobox/magnum/rubber
	name = "ammunition packet (.40 Magnum rubber)"
	icon_state = "magnum_r"
	ammo_type = /obj/item/ammo_casing/magnum/rubber

//// . 20 ////

/obj/item/ammo_magazine/ammobox/srifle
	name = "ammunition box (.20 Rifle)"
	icon_state = "box_srifle_l"
	matter = list(MATERIAL_STEEL = 60)
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_SRIFLE
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 240

/obj/item/ammo_magazine/ammobox/srifle/rubber
	name = "ammunition box (.20 Rifle rubber)"
	icon_state = "box_srifle_r"
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/ammobox/srifle_small
	name = "ammunition packet (.20 Rifle)"
	icon_state = "srifle_l"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_CARDBOARD = 1)
	caliber = CAL_SRIFLE
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 60

/obj/item/ammo_magazine/ammobox/srifle_small/practice
	name = "ammunition packet (.20 Rifle practice)"
	icon_state = "srifle_p"
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/ammobox/srifle_small/hv
	name = "ammunition packet (.20 Rifle high-velocity)"
	icon_state = "srifle_hv"
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/ammobox/srifle_small/rubber
	name = "ammunition packet (.20 Rifle high-velocity)"
	icon_state = "srifle_r"
	ammo_type = /obj/item/ammo_casing/srifle/rubber

//// . 25 CASELESS ////

/obj/item/ammo_magazine/ammobox/clrifle
	name = "ammunition box (.25 Caseless Rifle)"
	icon_state = "box_clrifle_l"
	matter = list(MATERIAL_STEEL = 60)
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_CLRIFLE
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 240

/obj/item/ammo_magazine/ammobox/clrifle/rubber
	name = "ammunition box (.25 Caseless Rifle rubber)"
	icon_state = "box_clrifle_r"
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

/obj/item/ammo_magazine/ammobox/clrifle_small
	name = "ammunition packet (.25 Caseless Rifle)"
	icon_state = "clrifle_l"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_CARDBOARD = 1)
	caliber = CAL_CLRIFLE
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 60

/obj/item/ammo_magazine/ammobox/clrifle_small/practice
	name = "ammunition packet (.25 Caseless Rifle practice)"
	icon_state = "clrifle_p"
	ammo_type = /obj/item/ammo_casing/clrifle/practice

/obj/item/ammo_magazine/ammobox/clrifle_small/hv
	name = "ammunition packet (.25 Caseless Rifle high-velocity)"
	icon_state = "clrifle_hv"
	ammo_type = /obj/item/ammo_casing/clrifle/hv

/obj/item/ammo_magazine/ammobox/clrifle_small/rubber
	name = "ammunition packet (.25 Caseless Rifle rubber)"
	icon_state = "clrifle_r"
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

//// . 30 ////

/obj/item/ammo_magazine/ammobox/lrifle
	name = "ammunition box (.30 Rifle lethal)"
	icon_state = "box_lrifle_l"
	matter = list(MATERIAL_STEEL = 60)
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_LRIFLE
	ammo_type = /obj/item/ammo_casing/lrifle
	mag_type = SPEEDLOADER | MAGAZINE
	max_ammo = 240

/obj/item/ammo_magazine/ammobox/lrifle_small
	name = "ammunition packet (.30 Rifle lethal)"
	icon_state = "lrifle_l"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_CARDBOARD = 1)
	caliber = CAL_LRIFLE
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 60

/obj/item/ammo_magazine/ammobox/lrifle_small/practice
	name = "ammunition packet (.30 Rifle practice)"
	icon_state = "lrifle_p"
	ammo_type = /obj/item/ammo_casing/lrifle/practice

/obj/item/ammo_magazine/ammobox/lrifle_small/hv
	name = "ammunition packet (.30 Rifle high-velocity)"
	icon_state = "lrifle_hv"
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/ammobox/lrifle_small/rubber
	name = "ammunition packet (.30 Rifle rubber)"
	icon_state = "lrifle_r"
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

//// .60 ////

/obj/item/ammo_magazine/ammobox/antim
	name = "ammunition box (.60 Anti Material)"
	icon_state = "antim"
	matter = list(MATERIAL_STEEL = 24)
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_ANTIM
	ammo_type = /obj/item/ammo_casing/antim
	max_ammo = 30

