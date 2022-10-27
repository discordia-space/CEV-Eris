/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/////.35 .40 pistols and smgs/////

/datum/uplink_item/item/ammo/pistol/highvelocity
	name = "Holdout .35 Auto HV magazine"
	desc = "Holdout .35 magazine, loaded with high velocity ammunition.  Can fit 10 bullets."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/pistol/highvelocity

/datum/uplink_item/item/ammo/hpistol/highvelocity
	name = "Highcap .35 Auto HV magazine"
	desc = "Highcap .35 magazine, loaded with high velocity ammunition.  Can fit 16 bullets."
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/hpistol/highvelocity

/datum/uplink_item/item/ammo/smg/highvelocity
	name = "SMG .35 Auto HV magazine"
	desc = "SMG .35 magazine, loaded with high velocity ammunition. Can fit 35 bullets."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/smg/hv

/datum/uplink_item/item/ammo/magnum/hv
	name = "Standard .40 HV magazine"
	desc = "Standard .40 magazine, loaded with high velocity ammunition. Can fit 10 bullets."
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/magnum/hv

/datum/uplink_item/item/ammo/magnum/msmg/hv
	name = "SMG .40 HV magazine"
	desc = "SMG .40 magazine, loaded with high velocity ammunition. Can fit 25 bullets."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/msmg/hv

///// .35 and .40 revolvers////

/datum/uplink_item/item/ammo/slpistol

/datum/uplink_item/item/ammo/slpistol/highvelocity
	name = ".35 Auto HV SL"
	desc = "Contains 3 standard .35 Auto speed loaders, loaded with high-velocity ammunition. Can fit 6 bullets."
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/slpistol/hv


/datum/uplink_item/item/ammo/slmagnum/highvelocity
	name = ".40 magnum HV SL box"
	desc = "Contains 3 .40 magnum HV speed loaders, loaded with high velocity ammunition. Can fit 6 bullets."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/slmagnum/highvelocity


/////.20 . 25 .30 Rifles/////

/datum/uplink_item/item/ammo/srifle

/datum/uplink_item/item/ammo/srifle/highvelocity
	name = ".20 Rifle HV magazine"
	desc = "Standard .20 magazine with high velocity ammunition. Well known for it's armor penetrating capabilities. Can fit 25 bullets."
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/srifle/hv

/datum/uplink_item/item/ammo/sl_srifle/highvelocity
	name = ".20 Rifle HV ammo strip"
	desc = "Contains 2 standard .20 ammo strips, loaded with high velocity ammunition. Can fit 5 bullets."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/slsrifle/hv
	
/datum/uplink_item/item/ammo/ihclrifle/highvelocity
	name = ".25 caseless HV magazine"
	desc = "Standard .25 magazine with high velocity ammunition. Used mostly in IHS carbines. Can fit 30 bullets."
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ihclrifle/hv

/datum/uplink_item/item/ammo/cspistol/highvelocity
	name = ".25 caseless HV pistol magazine"
	desc = "Pistol .25 magazine with high-velocity ammunition. Used solely in Mandella. Can fit 10 bullets."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/cspistol/hv

/datum/uplink_item/item/ammo/lrifle/highvelocity
	name = ".30 Rifle HV magazine"
	desc = "Long .30 magazine with high velocity ammunition. Can fit 30 bullets."
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/lrifle/highvelocity

/datum/uplink_item/item/ammo/sl_lrifle/highvelocity
	name = ".30 Rifle HV ammo strip"
	desc = "Contains 2 standard .30 ammo strips, loaded with high velocity ammunition. Can fit 5 bullets."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/sllrifle/hv
	
//// HV ammo packets ////

/datum/uplink_item/item/ammo/pistol_hv
	name = ".35 Auto HV ammo packet"
	desc = ".35 ammo packet with high velocity ammunition. Contains 70 bullets. Cheaper than buying in magazines."
	item_cost = 6
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ammobox/pistol/hv

/datum/uplink_item/item/ammo/magnum_hv
	name = ".40 Magnum HV ammo packet"
	desc = ".40 ammo packet with high velocity ammunition. Contains 50 bullets. Cheaper than buying in magazines."
	item_cost = 6
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ammobox/magnum/hv

/datum/uplink_item/item/ammo/srifle_hv
	name = ".20 Rifle HV ammo packet"
	desc = ".20 ammo packet with high velocity ammunition. Contains 50 bullets. Cheaper than buying in magazines."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ammobox/srifle_small/hv

/datum/uplink_item/item/ammo/clrifle_hv
	name = ".25 Rifle HV ammo packet"
	desc = ".25 ammo packet with high velocity ammunition. Contains 60 bullets. Cheaper than buying in magazines."
	item_cost = 5
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ammobox/clrifle_small/hv

/datum/uplink_item/item/ammo/lrifle_hv
	name = ".30 Rifle HV ammo packet"
	desc = ".30 ammo packet with high velocity ammunition. Contains 60 bullets. Cheaper than buying in magazines."
	item_cost = 5
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ammobox/lrifle_small/hv

////.50 Shotguns////

/datum/uplink_item/item/ammo/m12
	name = "M12 shotgun mag with slugs"
	desc = "M12 shotgun magazine with slug shells loaded. Can fit 8 shells."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/m12

/datum/uplink_item/item/ammo/m12/beanbag
	name = "M12 shotgun mag with beanbags"
	desc = "M12 shotgun magazine with beanbag shells loaded. Can fit 8 shells."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/m12/beanbag

/datum/uplink_item/item/ammo/m12/pellet
	name = "M12 shotgun mag with buckshot"
	desc = "M12 shotgun magazine with buckshot shells loaded. Can fit 8 shells."
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/m12/pellet

////special////

/datum/uplink_item/item/ammo/sniperammo
	name = ".60 Anti material \"Penetrator\""
	desc = "A box full of .60 AMR shells. Have 15 shells inside."
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/sniperammo

/datum/uplink_item/item/ammo/sniperammo/emp
	name = ".60 Anti material \"Blackout\""
	desc = "A box full of .60 AMR EMP shells. EMP shells release an electromagnetic pulse on impact. Have 15 shells inside."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/sniperammo/emp

/datum/uplink_item/item/ammo/sniperammo/uranium
	name = ".60 Anti material \"Meltdown\""
	desc = "A box full of .60 AMR depleted uranium shells with high armor-piercing power. radiation sickness included. Have 15 shells inside."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/sniperammo/uranium

/datum/uplink_item/item/ammo/sniperammo/breach
	name = ".60 Anti material \"Breacher\""
	desc = "A box full of low velocity .60 AMR breaching shells, designed not to pierce, but to destroy structures from a distance. Close-ranged shots have less destructive power. Have 15 shells inside."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/sniperammo/breach

/datum/uplink_item/item/ammo/sniperammo/large
	name = ".60 Anti material \"Penetrator\" crate"
	desc = "A box full of .60 AMR shells. Have 30 shells inside."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/ammobox/antim

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/dallas
	name = ".25 ammo box magazine"
	desc = "A box magazine designed for the use of the uncommon Dallas Pulse Rifle. Contains 99 rounds."
	item_cost = 9
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/c10x24

/datum/uplink_item/item/ammo/pk
	name = ".30 ammo box magazine"
	desc = "A box magazine for Light Machine Guns. Contains 80 rounds"
	item_cost = 8
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/ammo_magazine/lrifle/pk
//hyper-class cells, better than what you'll find in a vendor or maints.

/datum/uplink_item/item/ammo/cell/small
	name = "Small Power Cell"
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/cell/small/hyper

/datum/uplink_item/item/ammo/cell/medium
	name = "Medium Power Cell"
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/cell/medium/hyper

/datum/uplink_item/item/ammo/cell/large
	name = "Large Power Cell"
	item_cost = 5
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/cell/large/hyper
