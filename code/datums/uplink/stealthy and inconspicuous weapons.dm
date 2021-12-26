/*************************************
* Stealthy and Inconspicuous Weapons *
*************************************/
/datum/uplink_item/item/stealthy_weapons
	category = /datum/uplink_category/stealthy_weapons

/datum/uplink_item/item/stealthy_weapons/cigarette_kit
	name = "Cigarette Kit"
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/cigarette

/datum/uplink_item/item/stealthy_weapons/random_toxin
	name = "Random Toxin - Beaker"
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/toxin

/datum/uplink_item/item/stealthy_weapons/boot_knife
	name = "Boot Knife"
	item_cost = 2
	path = /obj/item/tool/knife/boot

/datum/uplink_item/item/stealthy_weapons/infuser
	name = "\"Glass Widow\" radiation infuser"
	item_cost = 2
	path = /obj/item/gun_upgrade/mechanism/glass_widow

/*
/datum/uplink_item/item/stealthy_weapons/eye_banger
	name = "\"Sparkly clean\" explosive lenses"
	item_cost = 5
	path = /obj/item/clothing/glasses/attachable_lenses/explosive
*/

/*
/datum/uplink_item/item/stealthy_weapons/assassin_dagger
	name = "Assassin's Dagger"
	item_cost = 4
	path = /obj/item/tool/knife/dagger/assassin
Removed since it’s either useless or 1 hit with right chems. Will be re-added after melee rework or after having a look at chems. Maybe both.
*/
