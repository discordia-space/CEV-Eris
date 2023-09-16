/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	item_cost = 4
	path = /obj/item/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_compress
	name = "Compressed Matter Implant"
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/imp_compress

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	item_cost = 10
	path = /obj/item/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_spying
	name = "Spying Implant"
	item_cost = 1
	path = /obj/item/storage/box/syndie_kit/imp_spying
	antag_roles = ROLES_CONTRACT_COMPLETE

/datum/uplink_item/item/implants/imp_spying/buy(obj/item/device/uplink/U)
	. = ..()
	if(.)
		var/obj/item/storage/box/syndie_kit/imp_spying/B = .
		var/obj/item/implanter/spying/I = locate() in B
		var/obj/item/implant/spying/S = I.implant
		S.owner = U.uplink_owner

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant"
	path = /obj/item/storage/box/syndie_kit/imp_uplink

/datum/uplink_item/item/implants/imp_uplink/New()
	..()
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "Contains [round((DEFAULT_TELECRYSTAL_AMOUNT / 2) * 0.8)] Telecrystal\s"

//To make new disposable cybernetic applicators, you have to go to the /obj/item/organ_module/* itself, and add the following:
///obj/item/implanter/installer/disposable/CYBERNETIC
//	name = "disposable cybernetic installer (CYBERNETIC)"
//	desc = [CYBERNETIC DESCRIPTION, as the disposable applicator will fill in the uplink description otherwise]
//	mod = /obj/item/organ_module/CYBERNETIC
//	spawn_tags = null
//Then here, you reference the new /obj/item/implanter/instaler/disposable/CYBERNETIC as the path. If this doesn't work, god be with ye.

//For the mod_overlay, go to the cybernetic in question, and add:
//	mod_overlay = "installer_CYBERNETIC"
//Then add the sprites to the items.dmi, named "installer_CYBERNETIC"

/datum/uplink_item/item/implants/energy_blade
	name = "Internal Energy Armblade Cybernetic"
	item_cost = 6
	path = /obj/item/implanter/installer/disposable/energy_blade

/datum/uplink_item/item/implants/subdermal_armor
	name = "Subdermal Armor Cybernetic"
	item_cost = 3
	path = /obj/item/implanter/installer/disposable/armor

/datum/uplink_item/item/implants/leg_muscle
	name = "Leg Muscle Cybernetic"
	item_cost = 3
	path = /obj/item/implanter/installer/disposable/muscle
