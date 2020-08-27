//CLOTH RANDOM
/obj/spawner/cloth/masks
	name = "random mask"
	desc = "This is a random mask."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_MASK)

/obj/spawner/cloth/masks/low_chance
	name = "low chance random mask"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60


/obj/spawner/cloth/armor
	name = "random armor"
	desc = "This is a random armor."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_ARMOR)

/obj/spawner/cloth/armor/low_chance
	name = "low chance random armor"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/random/cloth/suit
	name = "random suit"
	desc = "This is a random suit."
	icon_state = "armor-grey"

/obj/random/cloth/suit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/poncho = 10,
				/obj/item/clothing/suit/storage/bomj = 5,
				/obj/item/clothing/suit/storage/ass_jacket = 10,
				/obj/item/clothing/suit/storage/cargo_jacket = 10,
				/obj/item/clothing/suit/storage/detective = 5,
				/obj/item/clothing/suit/storage/hazardvest = 6,
				/obj/item/clothing/suit/storage/hazardvest/orange = 2,
				/obj/item/clothing/suit/storage/hazardvest/black = 2,
				/obj/item/clothing/suit/storage/detective/ironhammer  = 3,
				/obj/item/clothing/suit/storage/drive_jacket = 3,
				/obj/item/clothing/suit/storage/violet_jacket = 3,
				/obj/item/clothing/suit/storage/robotech_jacket = 10,
				/obj/item/clothing/suit/storage/toggle/bomber = 5,
				/obj/item/clothing/suit/storage/toggle/hoodie = 5,
				/obj/item/clothing/suit/storage/toggle/hoodie/black = 5,
				/obj/item/clothing/suit/storage/toggle/labcoat = 3,
				/obj/item/clothing/suit/storage/toggle/labcoat/chemist= 3,
				/obj/item/clothing/suit/storage/toggle/labcoat/cmo = 3,
				/obj/item/clothing/suit/storage/toggle/labcoat/medspec = 3,
				/obj/item/clothing/suit/storage/toggle/labcoat/science = 3,
				/obj/item/clothing/suit/storage/toggle/labcoat/virologist = 3,
				/obj/item/clothing/suit/storage/qm_coat = 2,
				/obj/item/clothing/suit/storage/cyberpunksleek = 8,
				/obj/item/clothing/suit/storage/bladerunner = 8,
				/obj/item/clothing/suit/storage/leather_jacket = 3,
				/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake=2,
				/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_snake=2,
				/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_jager=2))

/obj/random/cloth/suit/low_chance
	name = "low chance random suit"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/hazmatsuit
	name = "random hazmat suit"
	desc = "This is a random hazmat suit."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_HAZMATSUIT)

/obj/spawner/cloth/hazmatsuit/low_chance
	name = "low chance random hazmat suit"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/item/clothing/under/rank
	spawn_blacklisted = TRUE

/obj/spawner/cloth/under
	name = "random under"
	desc = "This is a random under."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_UNDER)

/obj/spawner/cloth/under/low_chance
	name = "low chance random under"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60


/obj/spawner/cloth/helmet
	name = "random helmet"
	desc = "This is a random helmet."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_HEAD_HELMET)

/obj/spawner/cloth/helmet/low_chance
	name = "low chance random helmet"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60


/obj/spawner/cloth/head
	name = "random head"
	desc = "This is a random head."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_CLOTHING_HEAD)
	restristed_tags = list(SPAWN_CLOTHING_HEAD_HELMET)

/obj/spawner/cloth/head/low_chance
	name = "low chance random head"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60


/obj/spawner/cloth/gloves
	name = "random gloves"
	desc = "This is a random gloves."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_GLOVES)

/obj/spawner/cloth/gloves/low_chance
	name = "low chance random gloves"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/random/cloth/glasses
	name = "random glasses"
	desc = "This is a random glasses."
	icon_state = "armor-grey"

/obj/random/cloth/glasses/item_to_spawn()
	return pickweight(list(/obj/item/clothing/glasses/eyepatch = 4,
				/obj/item/clothing/glasses/gglasses = 2,
				/obj/item/clothing/glasses/hud/health = 2,
				/obj/item/clothing/glasses/hud/security = 2,
				/obj/item/clothing/glasses/sunglasses/sechud/tactical = 2,
				/obj/item/clothing/glasses/threedglasses = 4,
				/obj/item/clothing/glasses/welding = 4))

/obj/random/cloth/glasses/low_chance
	name = "low chance random glasses"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60


/obj/spawner/cloth/shoes
	name = "random shoes"
	desc = "This is a random pair of shoes."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_SHOES)

/obj/spawner/cloth/shoes/low_chance
	name = "low chance random shoes"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60


/obj/random/cloth/backpack
	name = "random backpack"
	desc = "This is a random backpack"
	icon_state = "armor-grey"

/obj/random/cloth/backpack/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/backpack = 1,
				/obj/item/weapon/storage/backpack/white = 5,
				/obj/item/weapon/storage/backpack/purple = 5,
				/obj/item/weapon/storage/backpack/blue = 5,
				/obj/item/weapon/storage/backpack/green = 5,
				/obj/item/weapon/storage/backpack/orange = 5,
				/obj/item/weapon/storage/backpack/botanist = 4,
				/obj/item/weapon/storage/backpack/captain = 1,
				/obj/item/weapon/storage/backpack/clown = 4,
				/obj/item/weapon/storage/backpack/industrial = 6,
				/obj/item/weapon/storage/backpack/medical = 6,
				/obj/item/weapon/storage/backpack/security = 6,
				/obj/item/weapon/storage/backpack/neotheology = 2,
				/obj/item/weapon/storage/backpack/ironhammer = 2,
				/obj/item/weapon/storage/backpack/military = 6,
				/obj/item/weapon/storage/backpack/sport = 1,
				/obj/item/weapon/storage/backpack/sport/white = 5,
				/obj/item/weapon/storage/backpack/sport/purple = 5,
				/obj/item/weapon/storage/backpack/sport/blue = 5,
				/obj/item/weapon/storage/backpack/sport/green = 5,
				/obj/item/weapon/storage/backpack/sport/orange = 5,
				/obj/item/weapon/storage/backpack/sport/botanist = 4,
				/obj/item/weapon/storage/backpack/sport/neotheology = 2,
				/obj/item/weapon/storage/backpack/sport/ironhammer = 2,
				/obj/item/weapon/storage/backpack/satchel = 1,
				/obj/item/weapon/storage/backpack/satchel/white = 5,
				/obj/item/weapon/storage/backpack/satchel/purple = 5,
				/obj/item/weapon/storage/backpack/satchel/blue = 5,
				/obj/item/weapon/storage/backpack/satchel/green = 5,
				/obj/item/weapon/storage/backpack/satchel/orange = 5,
				/obj/item/weapon/storage/backpack/satchel/botanist = 4,
				/obj/item/weapon/storage/backpack/satchel/captain = 1,
				/obj/item/weapon/storage/backpack/satchel/industrial = 6,
				/obj/item/weapon/storage/backpack/satchel/medical = 6,
				/obj/item/weapon/storage/backpack/satchel/security = 6,
				/obj/item/weapon/storage/backpack/satchel/leather/withwallet = 12,
				/obj/item/weapon/storage/backpack/satchel/ironhammer = 4,
				/obj/item/weapon/storage/backpack/satchel/neotheology = 4,
				/obj/item/weapon/storage/backpack/satchel/military = 6,
				/obj/item/weapon/storage/backpack/duffelbag = 24))

/obj/random/cloth/backpack/low_chance
	name = "low chance random backpack"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/belt
	name = "random belt"
	desc = "This is a random belt."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_BELT)

/obj/spawner/cloth/belt/low_chance
	name = "low chance random belt"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/cloth/holster
	name = "random holster"
	desc = "This is a random holster."
	icon_state = "armor-grey"
	tags_to_spawn = list(SPAWN_HOLSTER)

/obj/spawner/cloth/holster/low_chance
	name = "low chance random holster"
	desc = "This is a random holster."
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60
