/obj/item/clothing/head/helmet/space/void/SCAF
	name = "SCAF helmet"
	desc = "A thick airtight helmet designed for planetside warfare."
	icon_state = "scaf"
	item_state = "scaf"
	//Headshots OP so these have tons of head protection. Aim for the body or suffer
	//These helmets are essentially an impenetrable fortress for the head
	armor = list(melee = 65, bullet = 78, laser = 65,energy = 45, bomb = 55, bio = 100, rad = 80)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green"

/obj/item/clothing/suit/space/void/SCAF
	icon_state = "scaf"
	name = "SCAF suit"
	desc = "A bulky antique suit of refurbished infantry armour, retrofitted with seals and coatings to make it EVA capable"
	item_state = "scaf"
	slowdown = 1.35
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	w_class = ITEM_SIZE_NORMAL
	//Melee attacks to the torso are the weakness of this armor.  It's optimised for ballistic resistance
	armor = list(melee = 45, bullet = 72, laser = 55, energy = 45, bomb = 55, bio = 100, rad = 80)
	siemens_coefficient = 0.35
	species_restricted = list("Human")



//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state = "syndie_helm"
	armor = list(melee = 60, bullet = 50, laser = 40,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list("Human")
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green"

/obj/item/clothing/suit/space/void/merc
	icon_state = "rig-syndie"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state = "syndie_voidsuit"
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 40, energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.35
	species_restricted = list("Human")