/*This code for boxes with ammo, you cant use them as magazines, but should be able to fill magazines with them.*/
/obj/item/ammo_magazine/ammobox	//Should not be used bu its own
	name = "ammunition box"
	desc = "Gun ammunition stored in a shiny new box. You can see caliber information on the label."
	mag_type = SPEEDLOADER	//To prevent load in magazine filled guns
	icon = 'icons/obj/ammo.dmi'
	reload_delay = 30
	ammo_mag = "box"
	matter = list(MATERIAL_CARDBOARD = 1)
	bad_type = /obj/item/ammo_magazine/ammobox
	price_tag = 100

/obj/item/ammo_magazine/ammobox/resolve_attackby(atom/A, mob/user)
	if(isturf(A) && locate(/obj/item/ammo_casing) in A || istype(A, /obj/item/ammo_casing))
		if(!do_after(user, src.reload_delay, src))
			to_chat(user, SPAN_WARNING("You stoped scooping ammo into [src]."))
			return
		if(collectAmmo(get_turf(A), user))
			return TRUE
	..()

/obj/item/ammo_magazine/ammobox/proc/collectAmmo(turf/target, mob/user)
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
	icon_state = "pistol"
	matter = list(MATERIAL_CARDBOARD = 1) // the autofill increases the cost depending on the contents
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 70
	rarity_value = 10
	spawn_tags = SPAWN_TAG_AMMO_COMMON
	ammo_states = list(70)

/obj/item/ammo_magazine/ammobox/pistol/practice
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/ammobox/pistol/hv
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/ammobox/pistol/rubber
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 5

/obj/item/ammo_magazine/ammobox/pistol/scrap
	rarity_value = 5
	ammo_type = /obj/item/ammo_casing/pistol/scrap

//// . 40 ////

/obj/item/ammo_magazine/ammobox/magnum
	name = "ammunition packet (.40 Magnum)"
	icon_state = "magnum"
	matter = list(MATERIAL_CARDBOARD = 1)
	caliber = CAL_MAGNUM
	ammo_type = /obj/item/ammo_casing/magnum
	max_ammo = 50
	ammo_states = list(50)

/obj/item/ammo_magazine/ammobox/magnum/practice
	ammo_type = /obj/item/ammo_casing/magnum/practice

/obj/item/ammo_magazine/ammobox/magnum/hv
	ammo_type = /obj/item/ammo_casing/magnum/hv

/obj/item/ammo_magazine/ammobox/magnum/rubber
	ammo_type = /obj/item/ammo_casing/magnum/rubber

/obj/item/ammo_magazine/ammobox/magnum/scrap
	ammo_type = /obj/item/ammo_casing/magnum/scrap
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_COMMON

//// . 20 ////


/obj/item/ammo_magazine/ammobox/srifle
	name = "ammunition box (.20 Rifle)"
	icon_state = "box_srifle"
	matter = list(MATERIAL_STEEL = 5) // the autofill increases the cost further depending on the contents
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_SRIFLE
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 240
	ammo_states = list(240)

/obj/item/ammo_magazine/ammobox/srifle/rubber
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/ammobox/srifle_small
	name = "ammunition packet (.20 Rifle)"
	icon_state = "srifle"
	matter = list(MATERIAL_CARDBOARD = 1)
	caliber = CAL_SRIFLE
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 50
	ammo_states = list(60)

/obj/item/ammo_magazine/ammobox/srifle_small/practice
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/ammobox/srifle_small/hv
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/ammobox/srifle_small/rubber
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/ammobox/srifle_small/scrap
	ammo_type = /obj/item/ammo_casing/srifle/scrap
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_COMMON

//// . 25 CASELESS ////

/obj/item/ammo_magazine/ammobox/clrifle
	name = "ammunition box (.25 Caseless Rifle)"
	icon_state = "box_clrifle"
	matter = list(MATERIAL_STEEL = 5) // the autofill increases the cost further depending on the contents
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_CLRIFLE
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 240
	spawn_tags = SPAWN_TAG_AMMO_IH
	rarity_value = 5
	ammo_states = list(240)

/obj/item/ammo_magazine/ammobox/clrifle/rubber
	ammo_type = /obj/item/ammo_casing/clrifle/rubber
	spawn_tags = SPAWN_TAG_AMMO_IH

/obj/item/ammo_magazine/ammobox/clrifle_small
	name = "ammunition packet (.25 Caseless Rifle)"
	icon_state = "clrifle"
	matter = list(MATERIAL_CARDBOARD = 1)
	caliber = CAL_CLRIFLE
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 60
	ammo_states = list(60)

/obj/item/ammo_magazine/ammobox/clrifle_small/practice
	ammo_type = /obj/item/ammo_casing/clrifle/practice

/obj/item/ammo_magazine/ammobox/clrifle_small/hv
	ammo_type = /obj/item/ammo_casing/clrifle/hv

/obj/item/ammo_magazine/ammobox/clrifle_small/rubber
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

/obj/item/ammo_magazine/ammobox/clrifle_small/scrap
	ammo_type = /obj/item/ammo_casing/clrifle/scrap
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_COMMON

//// . 30 ////
/obj/item/ammo_magazine/ammobox/lrifle
	name = "ammunition box (.30 Rifle)"
	icon_state = "box_lrifle"
	matter = list(MATERIAL_STEEL = 5) // the autofill increases the cost further depending on the contents
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_LRIFLE
	ammo_type = /obj/item/ammo_casing/lrifle
	mag_type = SPEEDLOADER | MAGAZINE
	max_ammo = 240
	ammo_states = list(240)

/obj/item/ammo_magazine/ammobox/lrifle/rubber
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

/obj/item/ammo_magazine/ammobox/lrifle_small
	name = "ammunition packet (.30 Rifle)"
	icon_state = "lrifle"
	matter = list(MATERIAL_CARDBOARD = 1)
	caliber = CAL_LRIFLE
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 60
	ammo_states = list(60)

/obj/item/ammo_magazine/ammobox/lrifle_small/practice
	ammo_type = /obj/item/ammo_casing/lrifle/practice

/obj/item/ammo_magazine/ammobox/lrifle_small/hv
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/ammobox/lrifle_small/rubber
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

/obj/item/ammo_magazine/ammobox/lrifle_small/scrap
	ammo_type = /obj/item/ammo_casing/lrifle/scrap
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_COMMON

//// .60 ////

/obj/item/ammo_magazine/ammobox/antim
	name = "ammunition box (.60 Anti Material)"
	icon_state = "antim"
	matter = list(MATERIAL_STEEL = 5) // the autofill increases the cost further depending on the contents
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_ANTIM
	ammo_type = /obj/item/ammo_casing/antim
	max_ammo = 30
	ammo_states = list(30)

/obj/item/ammo_magazine/ammobox/antim/scrap
	ammo_type = /obj/item/ammo_casing/antim/scrap
	max_ammo = 30
	rarity_value = 20

//// SHOTGUN ////

/obj/item/ammo_magazine/ammobox/shotgun
	name = "ammunition box (.50)"
	icon_state = "box_shot"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_BULKY
	caliber = CAL_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 160
	rarity_value = 20
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN
	ammo_states = list(160)
	ammo_names = list(
		"hv" = "slug",
		"r" = "beanbag",
		"l" = "pellet",
		"p" = "practice",
		"f" = "flash",
		"i" = "incendiary",
		"b" = "blank",
		"scrap" = "scrap slug",
		"scrap_r" = "scrap beanbag",
		"scrap_s" = "scrap pellet")

/obj/item/ammo_magazine/ammobox/shotgun/scrap
	ammo_type = /obj/item/ammo_casing/shotgun/scrap
	rarity_value = 10
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON

/obj/item/ammo_magazine/ammobox/shotgun/beanbag
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	rarity_value = 10

/obj/item/ammo_magazine/ammobox/shotgun/beanbag/scrap
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag/scrap
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON

/obj/item/ammo_magazine/ammobox/shotgun/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	rarity_value = 13.33

/obj/item/ammo_magazine/ammobox/shotgun/pellet/scrap
	ammo_type = /obj/item/ammo_casing/shotgun/pellet/scrap
	rarity_value = 6.66
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON

/obj/item/ammo_magazine/ammobox/shotgun/blanks
	ammo_type = /obj/item/ammo_casing/shotgun/blank
	rarity_value = 50

/obj/item/ammo_magazine/ammobox/shotgun/flashshells
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	rarity_value = 40

/obj/item/ammo_magazine/ammobox/shotgun/practiceshells
	ammo_type = /obj/item/ammo_casing/shotgun/practice
	rarity_value = 50

/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary
	rarity_value = 100

/obj/item/ammo_magazine/ammobox/shotgun_small
	name = "ammunition packet (.50)"
	icon_state = "shot"
	matter = list(MATERIAL_STEEL = 5)
	w_class = ITEM_SIZE_SMALL
	caliber = CAL_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 40
	rarity_value = 20
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN
	ammo_states = list(40)
	ammo_names = list(
		"hv" = "slug",
		"r" = "beanbag",
		"l" = "pellet",
		"p" = "practice",
		"f" = "flash",
		"i" = "incendiary",
		"b" = "blank",
		"scrap" = "scrap slug",
		"scrap_r" = "scrap beanbag",
		"scrap_s" = "scrap pellet")

/obj/item/ammo_magazine/ammobox/shotgun_small/scrap
	ammo_type = /obj/item/ammo_casing/shotgun/scrap
	rarity_value = 10
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON

/obj/item/ammo_magazine/ammobox/shotgun_small/beanbag
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	rarity_value = 10

/obj/item/ammo_magazine/ammobox/shotgun_small/beanbag/scrap
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag/scrap
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON

/obj/item/ammo_magazine/ammobox/shotgun_small/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	rarity_value = 13.33

/obj/item/ammo_magazine/ammobox/shotgun_small/pellet/scrap
	ammo_type = /obj/item/ammo_casing/shotgun/pellet/scrap
	rarity_value = 6.66
	spawn_tags = SPAWN_TAG_AMMO_SHOTGUN_COMMON

/obj/item/ammo_magazine/ammobox/shotgun_small/blanks
	ammo_type = /obj/item/ammo_casing/shotgun/blank
	rarity_value = 50

/obj/item/ammo_magazine/ammobox/shotgun_small/flashshells
	ammo_type = /obj/item/ammo_casing/shotgun/flash
	rarity_value = 40

/obj/item/ammo_magazine/ammobox/shotgun_small/practiceshells
	ammo_type = /obj/item/ammo_casing/shotgun/practice
	rarity_value = 50

/obj/item/ammo_magazine/ammobox/shotgun_small/incendiaryshells
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary
	rarity_value = 100
