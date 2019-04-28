/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/mc9mm
	name = "9mm"
	item_cost = 1
	path = /obj/item/ammo_magazine/mc9mm/highvelocity

/datum/uplink_item/item/ammo/a10mm
	name = "10mm"
	item_cost = 1
	path = /obj/item/ammo_magazine/a10mm/hv

/datum/uplink_item/item/ammo/smg10mm
	name = "smg 10mm"
	item_cost = 2
	path = /obj/item/ammo_magazine/smg10mm/hv

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	item_cost = 1
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/a357
	name = ".357"
	item_cost = 1
	path = /obj/item/ammo_magazine/sl357/highvelocity

/datum/uplink_item/item/ammo/a762
	name = "7.62mm"
	item_cost = 3
	path = /obj/item/ammo_magazine/c762_long/highvelocity

/datum/uplink_item/item/ammo/sniperammo
	name = "14.5mm"
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