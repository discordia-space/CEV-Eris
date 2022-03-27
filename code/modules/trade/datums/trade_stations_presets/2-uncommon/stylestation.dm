/datum/trade_station/style
	name_pool = list(
		"FTB 'TBD'" = "Free Trade Beacon 'TBD': TBD"
	)
	uid = "style"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 10
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 0
	recommendation_threshold = 0
	recommendations_needed = 2
	inventory = list(
		"Stylish Attire" = list(
			/obj/item/clothing/mask/scarf/style,
			/obj/item/clothing/mask/scarf/style/bluestyle,
			/obj/item/clothing/mask/scarf/style/yellowstyle,
			/obj/item/clothing/mask/scarf/style/redstyle,
			/obj/item/clothing/gloves/knuckles,
			/obj/item/clothing/head/ranger,
			/obj/item/clothing/head/inhaler,
			/obj/item/clothing/head/skull,
			/obj/item/clothing/head/skull/black,
			/obj/item/clothing/shoes/redboot,
			/obj/item/clothing/shoes/jackboots/longboot,
			/obj/item/clothing/under/white,
			/obj/item/clothing/under/red,
			/obj/item/clothing/under/green,
			/obj/item/clothing/under/grey,
			/obj/item/clothing/under/black,
			/obj/item/clothing/under/dress/purple,
			/obj/item/clothing/under/dress/white,
			/obj/item/clothing/under/helltaker,
			/obj/item/clothing/under/storage/tracksuit
		)
	)
	hidden_inventory = list(
		"Extra Stylish Attire" = list(
			/obj/item/clothing/under/johnny,
			/obj/item/clothing/under/raider,
			/obj/item/clothing/suit/storage/detective,
			/obj/item/clothing/suit/storage/triad,
			/obj/item/clothing/suit/storage/akira,
			/obj/item/clothing/head/feathertrilby,
			/obj/item/clothing/head/fedora,
			/obj/item/clothing/head/skull/drip
		),
		"Premium Collectable Hats" = list(
			/obj/item/clothing/head/collectable/chef,
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/tophat,
			/obj/item/clothing/head/collectable/captain,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/kitty,
			/obj/item/clothing/head/collectable/rabbitears,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat,
			/obj/item/clothing/head/collectable/festive
		)
	)
	offer_types = list(
		/datum/reagent/alcohol/changelingsting = offer_data("Changeling Sting bottle (60u)", 1500, 1),
		/datum/reagent/alcohol/longislandicedtea = offer_data("Long Island Iced Tea bottle (60u)", 1500, 1),
		/datum/reagent/alcohol/neurotoxin = offer_data("Neurotoxin bottle (60u)", 2500, 1),
		/datum/reagent/alcohol/hippies_delight = offer_data("Hippie's Delight bottle (60u)", 2500, 1),
		/datum/reagent/alcohol/silencer = offer_data("Silencer bottle (60u)", 2500, 1)
	)