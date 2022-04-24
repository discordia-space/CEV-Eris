/*******************************
* Stealth and Camouflage Items *
*******************************/
/datum/uplink_item/item/stealth_items
	category = /datum/uplink_category/stealth_items

/datum/uplink_item/item/stealth_items/syndigaloshes
	name = "No-Slip sole"
	item_cost = 1
	path = /obj/item/noslipmodule

/datum/uplink_item/item/stealth_items/spy
	name = "Bug Kit"
	item_cost = 2
	path = /obj/item/storage/box/syndie_kit/spy

/datum/uplink_item/item/stealth_items/id
	name = "Agent ID card"
	item_cost = 5
	path = /obj/item/card/id/syndicate
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/item/stealth_items/chameleon_kit
	name = "Chameleon Kit"
	desc = "Comes with all the clothes you need to impersonate most people. Acting lessons sold separately. Wearing the uniform will allow for quick switching between appearances."
	item_cost = 5
	path = /obj/item/storage/backpack/chameleon
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/item/stealth_items/cleanup
	name = "Crime Scene Cleanup Kit"
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR, ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/cleanup_kit

/datum/uplink_item/item/stealth_items/voice
	name = "Chameleon Voice Changer"
	item_cost = 5
	path = /obj/item/clothing/mask/chameleon/voice

/datum/uplink_item/item/stealth_items/chameleon_projector
	name = "Chameleon-Projector"
	item_cost = 8
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/device/chameleon

/datum/uplink_item/item/stealth_items/tool_dampener
	name = "Tool Upgrade: Aural Dampener"
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/tool_upgrade/augment/dampener
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/item/stealth_items/silencer
    name = "Silencer"
    item_cost = 2
    path = /obj/item/gun_upgrade/muzzle/silencer

/datum/uplink_item/item/stealth_items/killer
    name = "Syndicate \"Profesional Killer\" scope"
    item_cost = 2
    path = /obj/item/gun_upgrade/scope/killer
