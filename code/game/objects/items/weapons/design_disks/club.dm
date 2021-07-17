// Utensils

/obj/item/weapon/computer_hardware/hard_drive/portable/design/club/silverware // spawns in club roundstart
	disk_name = "Chef's Choice Silverware" // it has some other kitchen tools but for the most part its utensils
	icon_state = "club"
	rarity_value = 5 // A little less common than tool disks, but still really common because its pretty useless
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = -1 // supposed to be issued to resteraunts, not civilians, so no need to limit their prints
	designs = list(
	/datum/design/autolathe/tool/metal_fork,
	/datum/design/autolathe/tool/metal_spoon,
	/datum/design/autolathe/tool/knife, // theres no plastic knife as far as im aware, which is why no plastic version of knife is included here
	/datum/design/autolathe/tool/plastic_fork,
	/datum/design/autolathe/tool/plastic_spoon,
	/datum/design/autolathe/tool/rollingpin,
	/datum/design/autolathe/container/freezer
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/club/glassware // spawns in club roundstart
	disk_name = "Barman's Best Glassware" // it's not all glassware but fuck you i can't think of a better name
	icon_state = "club"
	rarity_value = 5
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = -1
	designs = list(
	/datum/design/autolathe/container/drinkingglass,
	/datum/design/autolathe/container/carafe,
	/datum/design/autolathe/container/insulated_pitcher,
	/datum/design/autolathe/container/flask,
	/datum/design/autolathe/container/vacuumflask,
	/datum/design/autolathe/container/white_mug,
	/datum/design/autolathe/container/black_mug,
	/datum/design/autolathe/container/green_mug,
	/datum/design/autolathe/container/blue_mug,
	/datum/design/autolathe/container/red_mug,
	/datum/design/autolathe/container/metal_mug
	)

// Alcohol

/obj/item/weapon/computer_hardware/hard_drive/portable/design/club/basic_barstuff // this one spawns in club roundstart
	disk_name = "Mike's Bar Staples" // better name pending
	// these are the really unique disks for club - they take varying amounts of ethanol, water, and other liquids + glass and make premade bottles -
	// - rarer disks can make stronger alcohols! this is the basic disk so it can only print some of the really common drinks, though
	icon_state = "club"
	rarity_value = 2 // the drinks are nice but the unlimited food printing is really, really useful, so this is a rare find in the common pool
	spawn_tags = SPAWN_TAG_DESIGN_COMMON
	license = -1 // this is the most basic disk and only has bar staples, so it can be used indefinitely
	designs = list(
	/datum/design/autolathe/container/prefilled/beer,
	/datum/design/autolathe/container/prefilled/ale,
	/datum/design/autolathe/container/prefilled/sodawater,
	/datum/design/autolathe/container/prefilled/soda,
	/datum/design/autolathe/container/prefilled/water,
	/datum/design/autolathe/food/packaged/chips,
	/datum/design/autolathe/food/packaged/cheesiehonkers,
	/datum/design/autolathe/food/packaged/candybar
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/club/soda_variety
	disk_name = "Fizzpop's Variety"
	icon_state = "club"
	rarity_value = 20 // one of the most common 'advanced' disks
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED_COMMON
	license = 50 // it's got a freaking huge license limit since it's just soda, but it does have a limit so customer has to buy fresh ones
	designs = list(
	/datum/design/autolathe/container/prefilled/sodawater = 0, // free since it can be printed forever in the basic pack
	/datum/design/autolathe/container/prefilled/soda = 0, // ditto
	/datum/design/autolathe/container/prefilled/spacemountainwind,
	/datum/design/autolathe/container/prefilled/gibb,
	/datum/design/autolathe/container/prefilled/spaceup,
	/datum/design/autolathe/container/prefilled/lemonlime,
	/datum/design/autolathe/container/prefilled/starkist,
	/datum/design/autolathe/container/prefilled/thirteenloko = 5 // can only print 10 of these - company legally had to discourage people from drinking it
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/club/booze_variety
	disk_name = "Uncle Git's Cookbook"
	icon_state = "club"
	rarity_value = 18 // still fairly common in the advanced disks
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED_COMMON
	license = 20 // you really don't need this many bottles of alcohol, but whatever
	designs = list(
	/datum/design/autolathe/container/prefilled/beer = 0,
	/datum/design/autolathe/container/prefilled/ale = 0,
	/datum/design/autolathe/container/prefilled/wine,
	/datum/design/autolathe/container/prefilled/vodka,
	/datum/design/autolathe/container/prefilled/gin,
	/datum/design/autolathe/container/prefilled/rum,
	/datum/design/autolathe/container/prefilled/whiskey
	)

// food

/obj/item/weapon/computer_hardware/hard_drive/portable/design/club/packaged_food_variety
	disk_name = "Sweetie's Pantry"
	icon_state = "club"
	rarity_value = 15 // actually a really useful find since there's no food vendors, so it's one of the mid-tier disks in the rare pool
	spawn_tags = SPAWN_TAG_DESIGN_ADVANCED_COMMON
	license = 10 // should be more than enough to supply someone for a full round
	designs = list(
	/datum/design/autolathe/food/packaged/candybar = 0, // free because it's also free in the basic bar disk
	/datum/design/autolathe/food/packaged/chips = 0,
	/datum/design/autolathe/food/packaged/cheesiehonkers = 0,
	/datum/design/autolathe/food/packaged/breadtube,
	/datum/design/autolathe/food/packaged/raisin,
	/datum/design/autolathe/food/packaged/jerky,
	/datum/design/autolathe/food/packaged/liquidfood = 2 // its got a lot of nutriment so it's worth 2 license points
	)