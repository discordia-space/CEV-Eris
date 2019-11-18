/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/pistol
	name = ".35 Auto"
	item_cost = 1
	path = /obj/item/ammo_magazine/pistol/highvelocity

/datum/uplink_item/item/ammo/smg
	name = "smg .35 Auto"
	item_cost = 2
	path = /obj/item/ammo_magazine/smg/hv

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	item_cost = 1
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/magnum
	name = ".40 magnum speed loader"
	item_cost = 1
	path = /obj/item/ammo_magazine/magnum/hv

/datum/uplink_item/item/ammo/lrifle
	name = ".30 Rifle"
	item_cost = 3
	path = /obj/item/ammo_magazine/lrifle_long/highvelocity

/datum/uplink_item/item/ammo/sniperammo
	name = ".60 Anti Material"
	item_cost = 3
	path = /obj/item/weapon/storage/box/sniperammo


//Super-class cells, better than what you'll find in a vendor,
//but not as good as the best maint loot, so scavenging is still encouraged
/datum/uplink_item/item/ammo/cell/small
	name = "Small Power Cell"
	item_cost = 2
	path = /obj/item/weapon/cell/small/super

/datum/uplink_item/item/ammo/cell/medium
	name = "Medium Power Cell"
	item_cost = 3
	path = /obj/item/weapon/cell/medium/super

/datum/uplink_item/item/ammo/cell/large
	name = "Large Power Cell"
	item_cost = 4
	path = /obj/item/weapon/cell/large/super