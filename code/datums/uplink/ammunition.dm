/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/mc9mm
	name = "Magazine (9mm)"
	item_cost = 4
	path = /obj/item/ammo_magazine/mc9mm

/datum/uplink_item/item/ammo/mc9mm/highvelocity
	name = "Magazine (9mm high velocity)"
	item_cost = 8
	path = /obj/item/ammo_magazine/mc9mm/highvelocity

/datum/uplink_item/item/ammo/a357
	name = "Speed Loader (.357)"
	item_cost = 10
	path = /obj/item/ammo_magazine/sl357

/datum/uplink_item/item/ammo/a357/highvelocity
	name = "Speed Loader (.357 high velocity)"
	item_cost = 20
	path = /obj/item/ammo_magazine/sl357/highvelocity

/datum/uplink_item/item/ammo/smg10mm
	name = "SMG Magazine (10mm)"
	item_cost = 14
	path = /obj/item/ammo_magazine/smg10mm

/datum/uplink_item/item/ammo/smg10mm/highvelocity
	name = "SMG Magazine (10mm high velocity)"
	item_cost = 28
	path = /obj/item/ammo_magazine/smg10mm/hv

/datum/uplink_item/item/ammo/a762
	name = "Long Magazine (7.62)"
	item_cost = 18
	path = /obj/item/ammo_magazine/c762_long

/datum/uplink_item/item/ammo/a762/highvelocity
	name = "Long Magazine (7.62 high velocity)"
	item_cost = 36
	path = /obj/item/ammo_magazine/c762_long/highvelocity

/datum/uplink_item/item/ammo/sniperammo
	name = "Five 14.5mm shells"
	item_cost = 30
	path = /obj/item/ammo_casing/a145/prespawned

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	item_cost = 20
	path = /obj/item/ammo_magazine/chemdart

//Super-class cells, better than what you'll find in a vendor,
//but not as good as the best maint loot, so scavenging is still encouraged
//keep in mind you can buy them from hacked vendor, so they should be cheap in general
/datum/uplink_item/item/ammo/cell/small
	name = "Small Power Cell (300)"
	item_cost = 10
	path = /obj/item/weapon/cell/small/super

/datum/uplink_item/item/ammo/cell/medium
	name = "Medium Power Cell (1000)"
	item_cost = 20
	path = /obj/item/weapon/cell/medium/super

/datum/uplink_item/item/ammo/cell/large
	name = "Large Power Cell (15000)"
	item_cost = 30
	path = /obj/item/weapon/cell/large/super