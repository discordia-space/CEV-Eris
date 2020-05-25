//CLOTH RANDOM
/obj/random/cloth/masks
	name = "random mask"
	desc = "This is a random mask."
	icon_state = "armor-grey"

/obj/random/cloth/masks/item_to_spawn()
	return pickweight(list(/obj/item/clothing/mask/balaclava = 15,
				/obj/item/clothing/mask/balaclava/tactical = 20,
				/obj/item/clothing/mask/bandana = 2,
				/obj/item/clothing/mask/bandana/blue = 1,
				/obj/item/clothing/mask/bandana/botany = 1,
				/obj/item/clothing/mask/bandana/camo = 1,
				/obj/item/clothing/mask/bandana/gold = 1,
				/obj/item/clothing/mask/bandana/green = 1,
				/obj/item/clothing/mask/bandana/orange = 1,
				/obj/item/clothing/mask/bandana/purple = 1,
				/obj/item/clothing/mask/bandana/red = 1,
				/obj/item/clothing/mask/bandana/skull = 1,
				/obj/item/clothing/mask/breath = 20,
				/obj/item/clothing/mask/breath/medical = 5,
				/obj/item/clothing/mask/gas = 20,
				/obj/item/clothing/mask/gas/clown_hat = 10,
				/obj/item/clothing/mask/gas/ihs = 10,
				/obj/item/clothing/mask/gas/swat = 2,
				/obj/item/clothing/mask/gas/voice = 2,
				/obj/item/clothing/mask/luchador = 2,
				/obj/item/clothing/mask/luchador/rudos = 2,
				/obj/item/clothing/mask/luchador/tecnicos = 2,
				/obj/item/clothing/mask/muzzle = 2,
				/obj/item/clothing/mask/scarf = 2,
				/obj/item/clothing/mask/scarf/green = 2,
				/obj/item/clothing/mask/scarf/ninja = 2,
				/obj/item/clothing/mask/scarf/red = 2,
				/obj/item/clothing/mask/scarf/redwhite = 2,
				/obj/item/clothing/mask/scarf/stripedblue = 2,
				/obj/item/clothing/mask/scarf/stripedgreen = 2,
				/obj/item/clothing/mask/scarf/stripedred = 2,
				/obj/item/clothing/mask/surgical = 8))

/obj/random/cloth/masks/low_chance
	name = "low chance random mask"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60





/obj/random/cloth/armor
	name = "random armor"
	desc = "This is a random armor."
	icon_state = "armor-grey"

/obj/random/cloth/armor/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/armor/vest = 20,
				/obj/item/clothing/suit/armor/vest/security = 15,
				/obj/item/clothing/suit/armor/vest/detective  = 10,
				/obj/item/clothing/suit/armor/vest/ironhammer = 2,
				/obj/item/clothing/suit/armor/vest/handmade = 5,
				/obj/item/clothing/suit/armor/flak = 5,
				/obj/item/clothing/suit/armor/flak/green = 5,
				/obj/item/clothing/suit/armor/bulletproof = 10,
				/obj/item/clothing/suit/armor/bulletproof/ironhammer = 2,
				/obj/item/clothing/suit/armor/bulletproof/serbian = 2,
				/obj/item/clothing/suit/armor/bulletproof/serbian/green = 2,
				/obj/item/clothing/suit/armor/bulletproof/serbian/tan = 2,
				/obj/item/clothing/suit/armor/laserproof = 4,
				/obj/item/clothing/suit/armor/heavy = 2,
				/obj/item/clothing/suit/armor/heavy/riot = 4,
				/obj/item/clothing/suit/storage/vest/merc = 2))

/obj/random/cloth/armor/low_chance
	name = "low chance random armor"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60




/obj/random/cloth/suit
	name = "random suit"
	desc = "This is a random suit."
	icon_state = "armor-grey"

/obj/random/cloth/suit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/poncho = 10,
				/obj/item/clothing/suit/storage/ass_jacket = 10,
				/obj/item/clothing/suit/storage/cargo_jacket = 10,
				/obj/item/clothing/suit/storage/detective = 5,
				/obj/item/clothing/suit/storage/hazardvest = 10,
				/obj/item/clothing/suit/storage/detective/ironhammer  = 3,
				/obj/item/clothing/suit/storage/leather_jacket = 3,
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
				/obj/item/clothing/suit/storage/cyberpunksleek = 8))

/obj/random/cloth/suit/low_chance
	name = "low chance random suit"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60





/obj/random/cloth/hazmatsuit
	name = "random hazmat suit"
	desc = "This is a random hazmat suit."
	icon_state = "armor-grey"

/obj/random/cloth/hazmatsuit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/bio_suit = 5,
				/obj/item/clothing/suit/bio_suit/cmo = 5,
				/obj/item/clothing/suit/bio_suit/general = 5,
				/obj/item/clothing/suit/bio_suit/janitor = 5,
				/obj/item/clothing/suit/bio_suit/scientist = 5,
				/obj/item/clothing/suit/bio_suit/security = 5,
				/obj/item/clothing/suit/bio_suit/virology = 5,
				/obj/item/clothing/suit/radiation = 15,
				/obj/item/clothing/suit/space/bomb = 10))

/obj/random/cloth/hazmatsuit/low_chance
	name = "low chance random hazmat suit"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60





/obj/random/cloth/under
	name = "random under"
	desc = "This is a random under."
	icon_state = "armor-grey"

/obj/random/cloth/under/item_to_spawn()
	return pickweight(list(/obj/item/clothing/under/aqua = 5,
				/obj/item/clothing/under/assistantformal = 5,
				/obj/item/clothing/under/blackskirt = 5,
				/obj/item/clothing/under/blazer = 5,
				/obj/item/clothing/under/bluepyjamas = 5,
				/obj/item/clothing/under/brown = 5,
				/obj/item/clothing/under/captainformal = 2,
				/obj/item/clothing/under/color/yellow = 5,
				/obj/item/clothing/under/color/yellow = 5,
				/obj/item/clothing/under/color/red = 5,
				/obj/item/clothing/under/color/pink = 5,
				/obj/item/clothing/under/color/orange = 5,
				/obj/item/clothing/under/color/green = 5,
				/obj/item/clothing/under/color/grey = 5,
				/obj/item/clothing/under/color/black = 5,
				/obj/item/clothing/under/darkblue = 5,
				/obj/item/clothing/under/darkred = 5,
				/obj/item/clothing/under/librarian = 5,
				/obj/item/clothing/under/lightblue = 5,
				/obj/item/clothing/under/lightbrown = 5,
				/obj/item/clothing/under/lightgreen = 5,
				/obj/item/clothing/under/lightpurple = 5,
				/obj/item/clothing/under/lightred = 5,
				/obj/item/clothing/under/overalls = 5,
				/obj/item/clothing/under/pirate = 5,
				/obj/item/clothing/under/purple = 5,
				/obj/item/clothing/under/rainbow = 5,
				/obj/item/clothing/under/redpyjamas = 5,
				/obj/item/clothing/under/schoolgirl = 5,
				/obj/item/clothing/under/suit_jacket/red = 5,
				/obj/item/clothing/under/suit_jacket = 5,
				/obj/item/clothing/under/turtleneck = 5,
				/obj/item/clothing/under/syndicate = 5))

/obj/random/cloth/under/low_chance
	name = "low chance random under"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60





/obj/random/cloth/helmet
	name = "random helmet"
	desc = "This is a random helmet."
	icon_state = "armor-grey"

/obj/random/cloth/helmet/item_to_spawn()
	return pickweight(list(/obj/item/clothing/head/armor/helmet = 20,
				/obj/item/clothing/head/armor/helmet/visor = 15,
				/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg = 10,
				/obj/item/clothing/head/armor/helmet/dermal = 2,
				/obj/item/clothing/head/armor/helmet/ironhammer = 2,
				/obj/item/clothing/head/armor/bulletproof = 10,
				/obj/item/clothing/head/armor/laserproof = 4,
				/obj/item/clothing/head/armor/riot = 4,
				/obj/item/clothing/head/armor/steelpot = 10,
				/obj/item/clothing/head/armor/altyn = 2,
				/obj/item/clothing/head/armor/altyn/brown = 2,
				/obj/item/clothing/head/armor/altyn/black = 2,
				/obj/item/clothing/head/armor/altyn/maska = 1,
				/obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle = 18))

/obj/random/cloth/helmet/low_chance
	name = "low chance random helmet"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60




/obj/random/cloth/head
	name = "random head"
	desc = "This is a random head."
	icon_state = "armor-grey"

/obj/random/cloth/head/item_to_spawn()
	return pickweight(list(/obj/item/clothing/head/kitty = 1,    //God forgive us
				/obj/item/clothing/head/greenbandana = 5,
				/obj/item/clothing/head/beret = 5,
				/obj/item/clothing/head/HoS = 1,
				/obj/item/clothing/head/bearpelt = 5,
				/obj/item/clothing/head/bowler = 5,
				/obj/item/clothing/head/bowlerhat = 5,
				/obj/item/clothing/head/cakehat = 5,
				/obj/item/clothing/head/chaplain_hood = 5,
				/obj/item/clothing/head/chefhat = 5,
				/obj/item/clothing/head/feathertrilby = 5,
				/obj/item/clothing/head/flatcap = 5,
				/obj/item/clothing/head/fez = 5,
				/obj/item/clothing/head/fedora = 5,
				/obj/item/clothing/head/hardhat/white = 5,
				/obj/item/clothing/head/hardhat = 5,
				/obj/item/clothing/head/nun_hood = 5,
				/obj/item/clothing/head/philosopher_wig = 5,
				/obj/item/clothing/head/orangebandana = 5,
				/obj/item/clothing/head/greenbandana = 5,
				/obj/item/clothing/head/nun_hood = 5,
				/obj/item/clothing/head/det/grey = 5,
				/obj/item/clothing/head/det = 5,
				/obj/item/clothing/head/soft/yellow = 1,
				/obj/item/clothing/head/soft/red = 1,
				/obj/item/clothing/head/soft/rainbow = 1,
				/obj/item/clothing/head/soft/purple = 1,
				/obj/item/clothing/head/soft/orange = 1,
				/obj/item/clothing/head/soft/mime = 1,
				/obj/item/clothing/head/soft/grey = 1,
				/obj/item/clothing/head/soft/green = 1,
				/obj/item/clothing/head/soft/blue = 1,
				/obj/item/clothing/head/soft = 5,
				/obj/item/clothing/head/that = 5,
				/obj/item/clothing/head/ushanka = 3,
				/obj/item/clothing/head/welding = 5))

/obj/random/cloth/head/low_chance
	name = "low chance random head"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60




/obj/random/cloth/gloves
	name = "random gloves"
	desc = "This is a random gloves."
	icon_state = "armor-grey"

/obj/random/cloth/gloves/item_to_spawn()
	return pickweight(list(/obj/item/clothing/gloves/botanic_leather = 3,
				/obj/item/clothing/gloves/boxing = 2,
				/obj/item/clothing/gloves/boxing/blue = 5,
				/obj/item/clothing/gloves/boxing/green = 1,
				/obj/item/clothing/gloves/boxing/yellow = 1,
				/obj/item/clothing/gloves/captain = 1,
				/obj/item/clothing/gloves/color/white = 3,
				/obj/item/clothing/gloves/color/blue = 3,
				/obj/item/clothing/gloves/color/brown = 3,
				/obj/item/clothing/gloves/color/green = 3,
				/obj/item/clothing/gloves/color/grey = 3,
				/obj/item/clothing/gloves/color/light_brown = 3,
				/obj/item/clothing/gloves/color/orange = 3,
				/obj/item/clothing/gloves/color/purple = 3,
				/obj/item/clothing/gloves/color/rainbow = 3,
				/obj/item/clothing/gloves/color/red = 3,
				/obj/item/clothing/gloves/color/yellow = 3,
				/obj/item/clothing/gloves/insulated = 6,
				/obj/item/clothing/gloves/insulated/cheap = 7,
				/obj/item/clothing/gloves/latex = 9,
				/obj/item/clothing/gloves/thick = 5,
				/obj/item/clothing/gloves/security/tactical = 1,
				/obj/item/clothing/gloves/security = 2,
				/obj/item/clothing/gloves/stungloves = 1))

/obj/random/cloth/gloves/low_chance
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




/obj/random/cloth/shoes
	name = "random shoes"
	desc = "This is a random pair of shoes."
	icon_state = "armor-grey"

/obj/random/cloth/shoes/item_to_spawn()
	return pickweight(list(/obj/item/clothing/shoes/black = 14,
				/obj/item/clothing/shoes/clown_shoes = 14,
				/obj/item/clothing/shoes/color/blue = 1,   //Those are ugly, so they are rare
				/obj/item/clothing/shoes/color/brown = 1,
				/obj/item/clothing/shoes/color/green = 1,
				/obj/item/clothing/shoes/color/orange = 1,
				/obj/item/clothing/shoes/color/purple = 1,
				/obj/item/clothing/shoes/color/rainbow = 1,
				/obj/item/clothing/shoes/color/white = 1,
				/obj/item/clothing/shoes/color/red = 1,
				/obj/item/clothing/shoes/color/yellow = 1,
				/obj/item/clothing/shoes/galoshes = 8,
				/obj/item/clothing/shoes/jackboots = 14,
				/obj/item/clothing/shoes/leather = 14,
				/obj/item/clothing/shoes/reinforced = 14,
				/obj/item/clothing/shoes/workboots = 4))

/obj/random/cloth/shoes/low_chance
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

/obj/random/cloth/belt
	name = "random belt"
	desc = "This is a random belt."
	icon_state = "armor-grey"

/obj/random/cloth/belt/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/belt/medical = 8,
				/obj/item/weapon/storage/belt/medical/emt = 8,
				/obj/item/weapon/storage/belt/tactical = 4,
				/obj/item/weapon/storage/belt/tactical/neotheology = 2,
				/obj/item/weapon/storage/belt/utility = 8,
				/obj/item/weapon/storage/belt/utility/neotheology = 4))

/obj/random/cloth/belt/low_chance
	name = "low chance random belt"
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60

/obj/random/cloth/holster
	name = "random holster"
	desc = "This is a random holster."
	icon_state = "armor-grey"

/obj/random/cloth/holster/item_to_spawn()
	return pickweight(list(/obj/item/clothing/accessory/holster = 1,
				/obj/item/clothing/accessory/holster/armpit = 1,
				/obj/item/clothing/accessory/holster/waist = 1,
				/obj/item/clothing/accessory/holster/hip = 1,))

/obj/random/cloth/holster/low_chance
	name = "low chance random holster"
	desc = "This is a random holster."
	icon_state = "armor-grey-low"
	spawn_nothing_percentage = 60