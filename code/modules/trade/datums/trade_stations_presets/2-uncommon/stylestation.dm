/datum/trade_station/style
	name_pool = list(
		"FTB \'White Rabbit\'" = "Free Trade Beacon \'White Rabbit\': \"Go down in style!\""
	)
	icon_states = list("htu_station", "station")
	uid = "style"
	tree_x = 0.7
	tree_y = 0.8
	start_discovered = FALSE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 10
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("illegal2")
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
			/obj/item/clothing/under/onestar,
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
		///obj/item/clothing/head/onestar = offer_data("One Star officer cap", 2000, 1),
		///obj/item/clothing/suit/storage/greatcoat/onestar = offer_data("One Star officer coat", 4000, 1),
		/datum/reagent/alcohol/neurotoxin = offer_data("Neurotoxin bottle (60u)", 2500, 1),
		/datum/reagent/alcohol/hippies_delight = offer_data("Hippie\'s Delight bottle (60u)", 2500, 1),
		/datum/reagent/alcohol/silencer = offer_data("Silencer bottle (60u)", 2500, 1),
		/obj/item/reagent_containers/food/snacks/kaiserburger = offer_data("kaiser burger", 25000, 2)
	)
