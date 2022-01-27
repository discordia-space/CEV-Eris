// Stacked resources. They use a69aterial datum for a lot of inherited69alues.
/obj/item/stack/material
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_NORMAL
	icon = 'icons/obj/stack/material.dmi'
	throw_speed = 3
	throw_range = 3
	max_amount = 120
	bad_type = /obj/item/stack/material

	var/default_type =69ATERIAL_STEEL
	var/material/material
	var/apply_colour //temp pending icon rewrite

/obj/item/stack/material/Initialize()
	. = ..()
	pixel_x = rand(0,10)-5
	pixel_y = rand(0,10)-5

	if(!default_type)
		default_type =69ATERIAL_STEEL
	material = get_material_by_name("69default_type69")
	if(!material)
		return INITIALIZE_HINT_QDEL

	stacktype =69aterial.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech =69aterial.stack_origin_tech.Copy()

	if(apply_colour)
		color =69aterial.icon_colour

	if(material.conductive)
		flags |= CONDUCT

	matter =69aterial.get_matter()
	update_strings()

/obj/item/stack/material/attack_self(mob/living/user)
	user.craft_menu()

/obj/item/stack/material/get_material()
	return69aterial

/obj/item/stack/material/proc/get_default_type()
	return default_type

/obj/item/stack/material/proc/update_strings()
	// Update from69aterial datum.
	singular_name =69aterial.sheet_singular_name

	if(amount>1)
		name = "69material.use_name69 69material.sheet_plural_name69"
		desc = "A stack of 69material.use_name69 69material.sheet_plural_name69."
		gender = PLURAL
	else
		name = "69material.use_name69 69material.sheet_singular_name69"
		desc = "A 69material.sheet_singular_name69 of 69material.use_name69."
		gender =69EUTER

/obj/item/stack/material/use(used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, tamount=null, type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) ||69aterial.name !=69.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M)69.update_strings()
	return transfer

/obj/item/stack/material/attack_self(mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(obj/item/W,69ob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()

/obj/item/stack/material/add(extra)
	..()
	update_strings()


/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-iron"
	default_type =69ATERIAL_IRON
	price_tag = 2
	novariants = FALSE

/obj/item/stack/material/iron/random
	rand_min = 3
	rand_max = 30
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES
	rarity_value = 45

/obj/item/stack/material/iron/full
	amount = 120

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_type =69ATERIAL_SANDSTONE
	price_tag = 1

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_type =69ATERIAL_MARBLE

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_type =69ATERIAL_DIAMOND
	price_tag = 100
	novariants = FALSE

/obj/item/stack/material/diamond/random
	rand_min = 1
	rand_max = 8
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_RARE
	rarity_value = 90

/obj/item/stack/material/diamond/full
	amount = 120

/obj/item/stack/material/uranium
	name =69ATERIAL_URANIUM
	icon_state = "sheet-uranium"
	default_type =69ATERIAL_URANIUM
	price_tag = 50
	novariants = FALSE

/obj/item/stack/material/uranium/random
	rand_min = 2
	rand_max = 15
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_RARE
	rarity_value = 90

/obj/item/stack/material/uranium/full
	amount = 120

/obj/item/stack/material/plasma
	name = "solid plasma"
	icon_state = "sheet-plasma"
	default_type =69ATERIAL_PLASMA
	price_tag = 30
	novariants = FALSE

/obj/item/stack/material/plasma/random
	rand_min = 3
	rand_max = 20
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES
	rarity_value = 30

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	default_type =69ATERIAL_PLASTIC
	price_tag = 2
	novariants = FALSE

/obj/item/stack/material/plastic/random
	rand_min = 3
	rand_max = 30
	rarity_value = 10
	spawn_tags = SPAWN_TAG_MATERIAL_BUILDING

/obj/item/stack/material/plastic/full
	amount = 120

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	default_type =69ATERIAL_GOLD
	price_tag = 50
	novariants = FALSE

/obj/item/stack/material/gold/random
	rand_min = 2
	rand_max = 15
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_RARE
	rarity_value = 45

/obj/item/stack/material/gold/full
	amount = 120

/obj/item/stack/material/silver
	name =69ATERIAL_SILVER
	icon_state = "sheet-silver"
	default_type =69ATERIAL_SILVER
	price_tag = 40
	novariants = FALSE

/obj/item/stack/material/silver/random
	rand_min = 3
	rand_max = 30
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_RARE
	rarity_value = 45

/obj/item/stack/material/silver/full
	amount = 120

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-platinum"
	default_type =69ATERIAL_PLATINUM
	price_tag = 80
	novariants = FALSE

/obj/item/stack/material/platinum/random
	rand_min = 1
	rand_max = 10
	//spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_RARE
	//rarity_value = 45

/obj/item/stack/material/platinum/full
	amount = 120

//Extremely69aluable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-hydrogen"
	default_type =69ATERIAL_MHYDROGEN
	price_tag = 50
	novariants = FALSE

/obj/item/stack/material/mhydrogen/full
	amount = 120

//Fuel for69RSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	default_type =69ATERIAL_TRITIUM
	apply_colour = 1
	price_tag = 50

/obj/item/stack/material/tritium/full
	amount = 120

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_type =69ATERIAL_OSMIUM
	apply_colour = 1
	price_tag = 50

/obj/item/stack/material/osmium/full
	amount = 120

/obj/item/stack/material/steel
	name =69ATERIAL_STEEL
	icon_state = "sheet-metal"
	default_type =69ATERIAL_STEEL
	price_tag = 2
	novariants = FALSE

//A stack which starts with the69ax amount
/obj/item/stack/material/steel/full
	amount = 120

/obj/item/stack/material/steel/random
	rand_min = 3
	rand_max = 30
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_BULDING
	rarity_value = 18

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	item_state = "sheet-metal"
	default_type =69ATERIAL_PLASTEEL
	price_tag = 30
	novariants = FALSE

/obj/item/stack/material/plasteel/random
	rand_min = 3
	rand_max = 20
	spawn_tags = SPAWN_TAG_MATERIAL_BUILDING
	rarity_value = 10

/obj/item/stack/material/plasteel/full
	amount = 120

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type =69ATERIAL_WOOD
	price_tag = 20

/obj/item/stack/material/wood/random
	rand_min = 3
	rand_max = 30
	rarity_value = 10
	spawn_tags = SPAWN_TAG_MATERIAL_BUILDING

/obj/item/stack/material/wood/full
	amount = 120

/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	default_type =69ATERIAL_CLOTH
	price_tag = 20

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	default_type =69ATERIAL_CARDBOARD
	price_tag = 5
	rarity_value = 6.66
	spawn_tags = SPAWN_TAG_JUNK

/obj/item/stack/material/cardboard/random
	rand_min = 5
	rand_max = 50
	rarity_value = 10
	spawn_tags = SPAWN_TAG_MATERIAL_BUILDING

/obj/item/stack/material/cardboard/full
	amount = 120

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of69ob grinding."
	icon_state = "sheet-leather"
	default_type =69ATERIAL_LEATHER
	price_tag = 10

/obj/item/stack/material/glass
	name =69ATERIAL_GLASS
	icon_state = "sheet-glass"
	default_type =69ATERIAL_GLASS
	price_tag = 2

/obj/item/stack/material/glass/random
	rand_min = 3
	rand_max = 30
	spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_BULDING
	rarity_value = 22.5

/obj/item/stack/material/glass/full
	amount = 120

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	default_type =69ATERIAL_RGLASS

/obj/item/stack/material/glass/plasmaglass
	name = "borosilicate glass"
	desc = "This sheet is special plasma-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-plasmaglass"
	default_type =69ATERIAL_PLASMAGLASS
	price_tag = 10

/obj/item/stack/material/glass/plasmaglass/random
	rand_min = 3
	rand_max = 30
	//spawn_tags = SPAWN_TAG_MATERIAL_RESOURCES_RARE
	//rarity_value = 50

/obj/item/stack/material/glass/plasmarglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special plasma-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-plasmarglass"
	default_type =69ATERIAL_RPLASMAGLASS
	price_tag = 12

/obj/item/stack/material/biomatter
	name = "biomatter"
	desc = "An another by-product of69ob grinding. Feels soft and... Strange."
	singular_name = "biomatter sheet"
	icon_state = "sheet-biomatter"
	default_type =69ATERIAL_BIOMATTER
	price_tag = 10
	novariants = FALSE
	var/biomatter_in_sheet = BIOMATTER_PER_SHEET // defined in solidifier.dm

/obj/item/stack/material/biomatter/random
	rand_min = 5
	rand_max = 25
	spawn_tags = SPAWN_TAG_MATERIAL
	rarity_value = 10

/obj/item/stack/material/biomatter/full
	amount = 120

/obj/item/stack/material/compressed
	name = "compressed69atter"
	desc = "Useful69atter that has been compressed and squeezed into cartridges."
	singular_name = "compressed69atter cartridge"
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	default_type =69ATERIAL_COMPRESSED
	price_tag = 30
