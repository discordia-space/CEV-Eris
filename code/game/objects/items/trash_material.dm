/obj/item/trash/material
	icon = 'icons/obj/material_trash.dmi'
	matter = list()
	bad_type = /obj/item/trash/material
	var/matter_chances = list()	//List of lists: list(material_name, chance, amount)


/obj/item/trash/material/Initialize()
	. = ..()
	if(!matter)
		matter = list()

	for(var/list/L in matter_chances)
		if(prob(L[2]))
			matter |= L[1]
			matter[L[1]] += max(0, L[3] + rand(-2,2))




/obj/item/trash/material/metal
	name = "scrap metal"
	desc = "A piece of metal that can be recycled in an autolathe."
	icon_state = "metal0"
	rarity_value = 3
	matter_chances = list(
		list(MATERIAL_STEEL, 100, 15),
		list(MATERIAL_STEEL, 50, 10),
		list(MATERIAL_STEEL, 10, 20),
		list(MATERIAL_PLASTEEL, 10, 5),
		list(MATERIAL_PLASTEEL, 5, 10),
		list(MATERIAL_PLATINUM, 4, 2),
	)

/obj/item/trash/material/metal/Initialize()
	. = ..()
	icon_state = "metal[rand(4)]"


/obj/item/trash/material/circuit
	name = "burnt circuit"
	desc = "A burnt circuit that can be recycled in an autolathe."
	volumeClass = ITEM_SIZE_SMALL
	icon_state = "circuit0"
	rarity_value = 3.5
	matter_chances = list(
		list(MATERIAL_GLASS, 100, 4),
		list(MATERIAL_GLASS, 50, 3),
		list(MATERIAL_PLASTIC, 40, 3),
		list(MATERIAL_SILVER, 18, 3),
		list(MATERIAL_GOLD, 17, 3),
		list(MATERIAL_DIAMOND, 4, 2),
	)

/obj/item/trash/material/circuit/Initialize()
	. = ..()
	icon_state = "circuit[rand(3)]"


/obj/item/trash/material/device
	name = "broken device"
	desc = "A broken device that can be recycled in an autolathe."
	volumeClass = ITEM_SIZE_SMALL
	icon_state = "device0"
	rarity_value = 4
	matter_chances = list(
		list(MATERIAL_STEEL, 100, 10),
		list(MATERIAL_GLASS, 90, 7),
		list(MATERIAL_PLASTIC, 100, 10),
		list(MATERIAL_SILVER, 16, 7),
		list(MATERIAL_GOLD, 15, 5),
		list(MATERIAL_DIAMOND, 5, 2),
	)

/obj/item/trash/material/device/Initialize()
	. = ..()
	icon_state = "device[rand(3)]"
