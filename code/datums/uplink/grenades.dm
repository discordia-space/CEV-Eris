/***********
* Grenades *
************/

//In general, grenades should be cheaper if bought in bulk by one grenade.
//If we have one smoke for 4, we should have bundle for 20, for example.

/datum/uplink_item/item/grenades
	category = /datum/uplink_category/grenades

/datum/uplink_item/item/grenades/smoke
	name = "Smoke Grenade"
	item_cost = 4
	path = /obj/item/weapon/grenade/smokebomb

/datum/uplink_item/item/grenades/smoke/six
	name = "Six Smoke Grenades"
	item_cost = 20
	path = /obj/item/weapon/storage/box/smokes

/datum/uplink_item/item/grenades/teargas
	name = "Tear gas Grenade"
	item_cost = 8
	path = /obj/item/weapon/grenade/chem_grenade/teargas

/datum/uplink_item/item/grenades/teargas/six
	name = "Six Tear gas Grenades"
	item_cost = 40
	path = /obj/item/weapon/storage/box/teargas

/datum/uplink_item/item/grenades/anti_photon
	name = "Photon Disruption Grenade"
	item_cost = 8
	path = /obj/item/weapon/grenade/anti_photon

/datum/uplink_item/item/grenades/anti_photon/six
	name = "Six Photon Disruption Grenades"
	item_cost = 40
	path = /obj/item/weapon/storage/box/anti_photons

/datum/uplink_item/item/grenades/flashbang
	name = "Flashbang Grenade"
	item_cost = 8
	path = /obj/item/weapon/grenade/flashbang

/datum/uplink_item/item/grenades/flashbangs/six
	name = "Six Flashbang Grenades"
	item_cost = 40
	path = /obj/item/weapon/storage/box/flashbangs

/datum/uplink_item/item/grenades/emp/weak
	name = "Weak EMP Grenade"
	item_cost = 12
	path = /obj/item/weapon/grenade/empgrenade/low_yield

/datum/uplink_item/item/grenades/emp/weak/six
	name = "Six Weak EMP Grenades"
	item_cost = 60
	path = /obj/item/weapon/storage/box/emps/weak

/datum/uplink_item/item/grenades/emp
	name = "EMP Grenade"
	item_cost = 18
	path = /obj/item/weapon/grenade/empgrenade

/datum/uplink_item/item/grenades/emp/six
	name = "Six EMP Grenades"
	item_cost = 90
	path = /obj/item/weapon/storage/box/emps

/datum/uplink_item/item/grenades/frag
	name = "Fragmentation Grenade"
	item_cost = 22
	path = /obj/item/weapon/grenade/frag

/datum/uplink_item/item/grenades/frag/six
	name = "Six Fragmentation Grenades"
	item_cost = 110
	path = /obj/item/weapon/storage/box/frag

/datum/uplink_item/item/grenades/explosive
	name = "Blast Grenade"
	item_cost = 28
	path = /obj/item/weapon/grenade/frag/explosive

/datum/uplink_item/item/grenades/explosive/six
	name = "Six Blast Grenades"
	item_cost = 140
	path = /obj/item/weapon/storage/box/explosive

/datum/uplink_item/item/grenades/blob
	name = "Bioweapon Sample"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/grenade/spawnergrenade/blob