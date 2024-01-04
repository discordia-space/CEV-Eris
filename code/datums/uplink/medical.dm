/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/sinpockets
	name = "Box of Sin-Pockets"
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/sinpockets

/datum/uplink_item/item/medical/surgery
	name = "Surgery kit"
	item_cost = 5
	path = /obj/item/storage/firstaid/surgery/contractor
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/item/medical/combat
	name = "Combat medical kit"
	item_cost = 6
	path = /obj/item/storage/firstaid/combat

/datum/uplink_item/item/medical/nanites
	name = "Raw nanites vial"
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/reagent_containers/glass/beaker/vial/nanites

/datum/uplink_item/item/medical/uncapnanites
	name = "Raw uncapped nanites vial"
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/reagent_containers/glass/beaker/vial/uncapnanites

/datum/uplink_item/item/medical/randomstim
	name = "5 Random Stims Kit"
	item_cost = 5
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/randomstim

/datum/uplink_item/item/medical/gene_vial
	name = "Genetic material vial"
	item_cost = 5
	path = /obj/item/gene_vial
	antag_roles = list(ROLE_CARRION)

/datum/uplink_item/item/medical/interface_implanter
	name = "Cyberinterface implanter"
	item_cost = 10
	path = /obj/item/implanter/cyberinterface_contractor
	antag_roles = list(ROLE_CONTRACTOR, ROLE_MERCENARY)

/obj/item/implanter/cyberinterface_contractor
	name = "implanter (C)"
	desc = "A implanter with a cyberinterface inside. Aim it where your brain is!"
	implant = /obj/item/implant/cyberinterface/contractor

/datum/uplink_item/item/medical/interface_disk
	name = "Cyberdisk - Combat booster (Toughness and Vigilance)"
	item_cost = 20
	path = /obj/item/cyberstick/syndicate
	antag_roles = list(ROLE_CONTRACTOR, ROLE_MERCENARY, ROLE_CARRION)

/datum/uplink_item/item/medical/nanopaste
	name = "Nanopaste"
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/stack/nanopaste
