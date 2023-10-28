/decl/hierarchy/outfit/antagonist/pirate

	hierarchy_type = /decl/hierarchy/outfit/antagonist/pirate

	uniform = /obj/item/clothing/under/pirate
	l_ear = /obj/item/device/radio/headset/pirates
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/bandana
	pda_slot = slot_belt
	pda_type = /obj/item/modular_computer/pda

//The outfit that mercs spawn in. They get their armor and weapons from the merc base
/decl/hierarchy/outfit/antagonist/pirate/casual
	name = "Pirate garb"

//He gets a snazzy beret
/decl/hierarchy/outfit/antagonist/pirate/commander
	name = "Pirate Quartermaster garb"
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/pirate

//This outfit is just for admin fun. Spawns them fully equipped
//Actual pirates equip themselves by picking up their garb from their base
/decl/hierarchy/outfit/antagonist/pirate/equipped
	name = "Pirate plundering gear"

	suit = /obj/item/clothing/suit/pirate
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/melee/energy/sword/pirate
