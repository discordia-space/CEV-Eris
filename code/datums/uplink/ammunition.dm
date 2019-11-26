/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/////.35 .40 pistols and smgs/////

/datum/uplink_item/item/ammo/pistol
	name = "Standard .35 Auto magazine"
	desc = "Standard .35 magazine, loaded with lethal ammunition. Can fit 10 bullets."
	item_cost = 1
	path = /obj/item/ammo_magazine/pistol

/datum/uplink_item/item/ammo/pistol/highvelocity
	name = "Holdout .35 Auto HV magazine"
	desc = "Holdout .35 magazine, loaded with high velocity ammunition.  Can fit 10 bullets."
	item_cost = 2
	path = /obj/item/ammo_magazine/pistol/highvelocity

/datum/uplink_item/item/ammo/hpistol
	name = "Highcap .35 Auto magazine"
	desc = "Highcap .35 magazine, loaded with lethal ammunition.  Can fit 16 bullets."
	item_cost = 2
	path = /obj/item/ammo_magazine/hpistol

/datum/uplink_item/item/ammo/hpistol/highvelocity
	name = "Highcap .35 Auto HV magazine"
	desc = "Highcap .35 magazine, loaded with high velocity ammunition.  Can fit 16 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/hpistol/highvelocity

/datum/uplink_item/item/ammo/smg/highvelocity
	name = "SMG .35 Auto HV magazine"
	desc = "SMG .35 magazine, loaded with high velocity ammunition. Can fit 35 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/smg/hv

/datum/uplink_item/item/ammo/magnum
	name = "Standard .40 magazine"
	desc = "Standard .40 magazine, loaded with lethal ammunition. Can fit 10 bullets."
	item_cost = 2
	path = /obj/item/ammo_magazine/magnum

/datum/uplink_item/item/ammo/magnum/hv
	name = "Standard .40 HV magazine"
	desc = "Standard .40 magazine, loaded with high velocity ammunition. Can fit 10 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/magnum/hv

///// .35 and .40 revolvers////

/datum/uplink_item/item/ammo/slpistol
	name = ".35 Auto SL"
	desc = "Standard .40 speed loader, loaded with lethal ammunition. Can fit 6 bullets."
	item_cost = 2
	path = /obj/item/ammo_magazine/slpistol

/datum/uplink_item/item/ammo/slmagnum
	name = ".40 magnum SL"
	desc = ".40 magnum speed loader, loaded with lethal ammunition. Can fit 6 bullets."
	item_cost = 2
	path = /obj/item/ammo_magazine/slmagnum

/datum/uplink_item/item/ammo/slmagnum/highvelocity
	name = ".40 magnum HV SL"
	desc = ".40 magnum HV speed loader, loaded with high velocity ammunition. Can fit 6 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/slmagnum/highvelocity


/////.20 . 25 .30 Rifles/////

/datum/uplink_item/item/ammo/srifle
	name = ".20 Rifle magazine"
	desc = "Standard .20 magazine with lethal ammunition. Well known for it's armor penetrating capabilities. Can fit 20 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/srifle

datum/uplink_item/item/ammo/ihsrifle
	name = ".20 Rifle IH magazine"
	desc = "IH issued .20 magazine with lethal ammunition. Well known for it's armor penetrating capabilities. Can fit 30 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/ihsrifle

/datum/uplink_item/item/ammo/ihclrifle
	name = ".25 caseless magazine"
	desc = "Standard .25 magazine with lethal ammunition. Used mostly in IHS carabines. Can fit 30 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/ihclrifle

datum/uplink_item/item/ammo/sllrifle
	name = ".30 Rifle ammo clip"
	desc = ".30 ammo clip with lethal ammunition. Can fit 5 bullets."
	item_cost = 1
	path = /obj/item/ammo_magazine/sllrifle

datum/uplink_item/item/ammo/lrifle_short
	name = ".30 Rifle magazine"
	desc = "Short .30 magazine with lethal ammunition. Can fit 20 bullets."
	item_cost = 2
	path = /obj/item/ammo_magazine/lrifle_short

datum/uplink_item/item/ammo/lrifle_long
	name = ".30 Rifle magazine"
	desc = "Long .30 magazine with lethal ammunition. Can fit 30 bullets."
	item_cost = 3
	path = /obj/item/ammo_magazine/lrifle_long

datum/uplink_item/item/ammo/lrifle_long/highvelocity
	name = ".30 Rifle magazine"
	desc = "Long .30 magazine with high velocity ammunition. Can fit 30 bullets."
	item_cost = 4
	path = /obj/item/ammo_magazine/lrifle_long/highvelocity

////.50 Shotguns////

/datum/uplink_item/item/ammo/m12/empty
	name = "Empty M12 shotgun mag"
	desc = "M12 shotgun magazine without any ammunition. Can fit 8 shells."
	item_cost = 1

/datum/uplink_item/item/ammo/m12
	name = "M12 shotgun mag with slugs"
	desc = "M12 shotgun magazine with slug shells loaded. Can fit 8 shells."
	item_cost = 2
	path = /obj/item/ammo_magazine/m12

/datum/uplink_item/item/ammo/m12/beanbag
	name = "M12 shotgun mag with beanbags"
	desc = "M12 shotgun magazine with beanbag shells loaded. Can fit 8 shells."
	item_cost = 2
	path = /obj/item/ammo_magazine/m12/beanbag

/datum/uplink_item/item/ammo/m12/pellet
	name = "M12 shotgun mag with buckshot"
	desc = "M12 shotgun magazine with buckshot shells loaded. Can fit 8 shells."
	item_cost = 2
	path = /obj/item/ammo_magazine/m12/pellet

/datum/uplink_item/item/ammo/m12/stun
	name = "M12 shotgun mag with taser shells"
	desc = "M12 shotgun magazine with tazer shells loaded. Can fit 8 shells."
	item_cost = 4
	path = /obj/item/ammo_magazine/m12/stun

////special////

/datum/uplink_item/item/ammo/sniperammo
	name = ".60 Anti material"
	desc = "A box full of .60 AMR bullets. Have 5 bullets inside."
	item_cost = 3
	path = /obj/item/weapon/storage/box/sniperammo

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	item_cost = 2
	path = /obj/item/ammo_magazine/chemdart

//hyper-class cells, better than what you'll find in a vendor or maints.

/datum/uplink_item/item/ammo/cell/small
	name = "Small Power Cell"
	item_cost = 3
	path = /obj/item/weapon/cell/small/hyper

/datum/uplink_item/item/ammo/cell/medium
	name = "Medium Power Cell"
	item_cost = 4
	path = /obj/item/weapon/cell/medium/hyper

/datum/uplink_item/item/ammo/cell/large
	name = "Large Power Cell"
	item_cost = 5
	path = /obj/item/weapon/cell/large/hyper