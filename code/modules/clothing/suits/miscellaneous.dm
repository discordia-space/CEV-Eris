/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "blue laser tag armour"
	desc = "Blue Pride, Station Wide."
	icon_state = "bluetag"
	item_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/blue)
	siemens_coefficient = 3

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	item_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/red)
	siemens_coefficient = 3

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	body_parts_covered = UPPER_TORSO|ARMS


/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/storage/fancy/cigarettes,/obj/item/spacecash)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "wcoat"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO


/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	volumeClass = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/device/lighting/toggleable/flashlight,/obj/item/tank,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	item_flags = COVER_PREVENT_MANIPULATION


/obj/item/clothing/suit/chickensuit
	name = "chicken suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	item_state = "chickensuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2


/obj/item/clothing/suit/monkeysuit
	name = "monkey suit"
	desc = "A suit that looks like a primate"
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2


/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/marisa
	name = "witch robe"
	desc = "Magic is all about the spell power, Ze!"
	icon_state = "marisa"
	item_state = "marisa"
	spawn_blacklisted = TRUE
/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
	desc = "A suit that completely restrains the wearer."
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	allowed = list(/obj/item/tank)


//pyjamas
//originally intended to be pinstripes >.>

/obj/item/clothing/under/bluepyjamas
	name = "blue pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "blue_pyjamas"
	item_state = "blue_pyjamas"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/under/redpyjamas
	name = "red pyjamas"
	desc = "Slightly old-fashioned sleepwear."
	icon_state = "red_pyjamas"
	item_state = "red_pyjamas"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS


/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state = "xenos_helm"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2

//swimsuit
/obj/item/clothing/under/swimsuit
	siemens_coefficient = 1
	body_parts_covered = 0
	bad_type = /obj/item/clothing/under/swimsuit

/obj/item/clothing/under/swimsuit/black
	name = "black swimsuit"
	desc = "An oldfashioned black swimsuit."
	icon_state = "swim_black"

/obj/item/clothing/under/swimsuit/blue
	name = "blue swimsuit"
	desc = "An oldfashioned blue swimsuit."
	icon_state = "swim_blue"

/obj/item/clothing/under/swimsuit/purple
	name = "purple swimsuit"
	desc = "An oldfashioned purple swimsuit."
	icon_state = "swim_purp"

/obj/item/clothing/under/swimsuit/green
	name = "green swimsuit"
	desc = "An oldfashioned green swimsuit."
	icon_state = "swim_green"

/obj/item/clothing/under/swimsuit/red
	name = "red swimsuit"
	desc = "An oldfashioned red swimsuit."
	icon_state = "swim_red"

/obj/item/clothing/suit/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
	spawn_tags = SPAWN_TAG_CLOTHING_SUIT_PONCHO

/obj/item/clothing/suit/poncho/tactical
	name = "blue poncho"
	desc = "A simple, comfortable poncho in blue colors."
	icon_state = "tacticalponcho"
	item_state = "tacticalponcho"

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 style leather bomber jacket."
	icon_state = "bomber"
	item_state = "bomber"
	icon_open = "bomber_open"
	icon_closed = "bomber"
	style = STYLE_LOW
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/storage/toggle/bomber/furred
	name = "furred bomber jacket"
	desc = "A thick, well-worn WW2 style leather bomber jacket, padded with warm fur. It's cold out in space!"
	icon_state = "fur_bomber"
	item_state = "fur_bomber"
	icon_open = "fur_bomber_open"
	icon_closed = "fur_bomber"
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/storage/toggle/service
	name = "Ironhammer service jacket"
	desc = "A blue service jacket with golden badges. Often worn in low threat areas, formal situations, or by veterans."
	icon_state = "service"
	item_state = "service"
	icon_open = "service_open"
	icon_closed = "service"
	style = STYLE_LOW

/obj/item/clothing/suit/storage/jamrock
	name = "disco blazer"
	desc = "A green blazer that looks perfect for a disco party."
	icon_state = "jamrock_blazer"
	item_state = "jamrock_blazer"
	style = STYLE_HIGH
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/aerostatic
	name = "aerostatic bomber jacket"
	desc = "A red bomber jacket that looks like its seen better days."
	icon_state = "aerostatic_bomber_jacket"
	item_state = "aerostatic_bomber_jacket"
	style = STYLE_HIGH
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/khaki
	name = "tactful jacket"
	desc = "A khaki-colored jacket so stylishly casual you might think it sports a tactical vest."
	icon_state = "khaki"
	item_state = "khaki"
	style = STYLE_LOW
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/storage/leather_jacket
	name = "leather jacket"
	desc = "A sturdy, synthetic leather jacket with a high collar. It is able to protect you from a knife slice or a bite, but don't expect too much. More importantly, it makes you look like a really bad boy or girl. And remember, Tunnel Snakes rule!"
	icon_state = "leather_jacket"
	item_state = "leather_jacket"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =10,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake
	name = "sleek leather jacket"
	desc = "A sturdy, synthetic leather jacket with a high collar. It is able to protect you from a knife slice or a bite, but don't expect too much. More importantly, it makes you look like a really bad boy or girl."
	icon_state = "tunnelsnake_blank"
	item_state = "tunnelsnake_blank"

/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_jager
	name = "Jaeger leather jacket"
	desc = "A sturdy, synthetic leather jacket with a high collar. It is able to protect you from a knife slice or a bite, but don't expect too much. More importantly, it makes you look like a really bad boy or girl. This jacket has a Jaeger roach pictured on the back. Jaeger Roach rules!"
	icon_state = "tunnelsnake_jager"
	item_state = "tunnelsnake_jager"

/obj/item/clothing/suit/storage/leather_jacket/tunnelsnake_snake
	name = "Tunnelsnake jacket"
	desc = "Tunnelsnakes Rule! That's us! And we Rule!"
	icon_state = "tunnelsnake"
	item_state = "tunnelsnake"

/obj/item/clothing/suit/storage/leather_jacket/punk
	name = "punk jacket"
	desc = "Authentic leather for an authentic punk."
	icon_state = "punk_highlight"

/obj/item/clothing/suit/storage/leather_jacket/punk/New(loc, jacket_type = "punk_highlight", logo_type, is_natural_spawn = TRUE)
	..()
	if(is_natural_spawn) // From junk pile or some such
		logo_type = pick(list(
			null, null, null, null, // 50% chance of not having any logo
			"punk_over_valentinos",
			"punk_over_samurai",
			"punk_over_jager_roach",
			"punk_over_tunnel_snakes"
		))
		jacket_type = pick(list(
			"punk_bright",
			"punk_dark",
			"punk_highlight"
		))

	if(logo_type)
		var/obj/item/clothing/accessory/logo/logo = new
		logo.icon_state = logo_type
		accessories += logo
		logo.attachedTo = src
		forceMove(src)
		switch(logo_type) // All of the following names associated with some group of people, thus capitalized
			if("punk_over_valentinos")
				name = "Valentinos jacket"
			if("punk_over_samurai")
				name = "Samurai jacket"
			if("punk_over_jager_roach")
				name = "Jager Roaches jacket"
			if("punk_over_tunnel_snakes")
				name = "Tunnel Snakes jacket"

	icon_state = jacket_type
	update_icon()

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "grey hoodie"
	desc = "A warm, grey sweatshirt."
	icon_state = "grey_hoodie"
	item_state = "grey_hoodie"
	icon_open = "grey_hoodie_open"
	icon_closed = "grey_hoodie"
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	icon_state = "black_hoodie"
	item_state = "black_hoodie"
	icon_open = "black_hoodie_open"
	icon_closed = "black_hoodie"

/obj/item/clothing/suit/storage/cyberpunksleek
	name = "\improper Enforcer's Overcoat"
	desc = "A sleek overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek"
	item_state = "brown_jacket"
	armor = list(
		ARMOR_BLUNT = 1,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)


/obj/item/clothing/suit/storage/cyberpunksleek/green
	name = "Enforcer's gray overcoat"
	desc = "A sleek overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_green"
	item_state = "cyberpunksleek_green"


/obj/item/clothing/suit/storage/cyberpunksleek/black
	name = "Enforcer's gray overcoat"
	desc = "A sleek overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_black"
	item_state = "cyberpunksleek_black"

/obj/item/clothing/suit/storage/cyberpunksleek/white
	name = "Enforcer's gray overcoat"
	desc = "A sleek overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_white"
	item_state = "cyberpunksleek_white"

/obj/item/clothing/suit/storage/cyberpunksleek_long
	name = "\improper Enforcer's long Overcoat"
	desc = "A sleek long overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_long"
	item_state = "cyberpunksleek_long"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)


/obj/item/clothing/suit/storage/cyberpunksleek_long/green
	name = "Enforcer's long green overcoat"
	desc = "A sleek long overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_long_green"
	item_state = "cyberpunksleek_long_green"


/obj/item/clothing/suit/storage/cyberpunksleek_long/black
	name = "Enforcer's long black overcoat"
	desc = "A sleek long overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_long_black"
	item_state = "cyberpunksleek_long_black"

/obj/item/clothing/suit/storage/cyberpunksleek_long/white
	name = "Enforcer's long white overcoat"
	desc = "A sleek long overcoat made of neo-laminated fabric. Has a reasonably sized pocket on the inside."
	icon_state = "cyberpunksleek_long_white"
	item_state = "cyberpunksleek_long_white"

/obj/item/clothing/suit/storage/bladerunner
	name = "leather coat"
	desc = "An old leather coat. Has probably seen things you wouldn't believe."
	icon_state = "bladerunner_coat"
	item_state = "bladerunner_coat"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/dante//makes even the devil cry
	name = "exterminator coat"
	desc = "A stylish red leather coat. So stylish, in fact, that it makes you want to dance."
	icon_state = "dante"
	item_state = "dante"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	style = STYLE_HIGH
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/drive_jacket
	name = "white jacket"
	desc = "With the warmth of this jacket you feel like you're a real human being."
	icon_state = "drive_jacket"
	item_state = "drive_jacket"
	style = STYLE_LOW
	body_parts_covered = UPPER_TORSO|ARMS
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/violet_jacket
	name = "violet jacket"
	desc = "Coat that you ride like lightning, and will crash with you like thunder."
	icon_state = "violet_jacket"
	item_state = "violet_jacket"
	style = STYLE_LOW
	body_parts_covered = UPPER_TORSO|ARMS
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/bomj
	name = "bomj coat"
	desc = "A coat padded with synthetic insulation."
	icon_state = "bomj"
	item_state = "bomj"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 4,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/punkvest
	name = "punk vest"
	desc = "A dark vest made out of light, breathable fabric. Feeling lucky, punk?"
	icon_state = "punkvest"
	item_state = "punkvest"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/toggle/windbreaker
	name = "windbreaker"
	desc = "A dark blue jacket with black highlights. You can't think of any reason why someone would need a windbreaker in space, but the jacket looks cool either way. As an added bonus, it looks fairly resistant to stains and caustic chemicals."
	icon_state = "windbreaker_open"
	item_state = "windbreaker" //Is this even used for anything?
	icon_open = "windbreaker_open"
	icon_closed = "windbreaker"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 2,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =0,
		ARMOR_BIO =30,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|ARMS
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/punkvest/cyber
	name = "cyberpunk vest"
	desc = "A red vest with golden streaks. It's made out of tough materials, and can protect fairly well against bullets. Wake the fuck up, Samurai."
	icon_state = "cyberpunk"
	item_state = "cyberpunk"
	armor = list(
		ARMOR_BLUNT = 2,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	rarity_value = 80
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/neojute

	)

/obj/item/clothing/suit/storage/scavengerarmor
	name = "scavenger armor"
	desc = "A sturdy, rigged Scavenger armor. strong and sturdy as most vests. made fully from junk."
	icon_state = "scav_armor"
	item_state = "scav_armor"
	armor = list(
		ARMOR_BLUNT = 13,
		ARMOR_BULLET = 12,
		ARMOR_ENERGY = 6,
		ARMOR_BOMB =15,
		ARMOR_BIO =50,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	siemens_coefficient = 0.7
	spawn_blacklisted = TRUE
	style = STYLE_NEG_LOW
	armorComps = list(
		/obj/item/armor_component/plate/steel
	)

/obj/item/clothing/suit/storage/scavengerarmor/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 3
	pockets.max_volumeClass = ITEM_SIZE_SMALL
	pockets.max_storage_space = 6


/obj/item/clothing/suit/storage/triad
	name = "triad jacket"//RUINER reference
	desc = "A well armoured trench coat. The label on the inside claims it comes from Hanza."
	icon_state = "triadkillers"
	item_state = "triadkillers"
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 5,
		ARMOR_BOMB =15,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	price_tag = 1000
	rarity_value = 80
	style = STYLE_HIGH
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/neojute
	)

/obj/item/clothing/suit/storage/triad/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_volumeClass = ITEM_SIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/akira
	name = "red jacket"//Akira, preety obvious
	desc = "A red jacket designed for riding on a bike. Has a pill icon on the back."
	icon_state = "akira"
	item_state = "akira"
	armor = list(
		ARMOR_BLUNT = 5,
		ARMOR_BULLET = 5,
		ARMOR_ENERGY = 2,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)
	body_parts_covered = UPPER_TORSO|ARMS
	style = STYLE_HIGH
	price_tag = 400
	armorComps = list(
		/obj/item/armor_component/plate/leather,
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/boxer_jacket
	name = "boxer jacket"//Mother Russia Bleeds reference
	desc = "Uppercut their heads off."
	icon_state = "boxer_jacket"
	item_state = "boxer_jacket"
	siemens_coefficient = 0.7
	style = STYLE_LOW
	body_parts_covered = UPPER_TORSO|ARMS
	armorComps = list(
		/obj/item/armor_component/plate/leather
	)

/obj/item/clothing/suit/storage/puffyblue
	name = "blue puffy coat"
	desc = "A stylish, shiny, very blue Aster\'s Guild branded puffer coat."
	icon_state = "puffycoatblue"
	item_state = "puffycoatblue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/storage/puffypurple
	name = "purple puffy coat"
	desc = "A stylish, shiny, very purple Aster\'s Guild branded puffer coat."
	icon_state = "puffycoatpurple"
	item_state = "puffycoatpurple"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth
	)

/obj/item/clothing/suit/storage/puffyred
	name = "crimson puffy coat"
	desc = "A stylish, shiny, crimson Aster\'s Guild branded puffer coat."
	icon_state = "puffycoatred"
	item_state = "puffycoatred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.7
	armorComps = list(
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth,
		/obj/item/armor_component/plate/cloth
	)
