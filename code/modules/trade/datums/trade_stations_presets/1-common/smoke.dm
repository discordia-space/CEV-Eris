/datum/trade_station/smoke
	name_pool = list(
		"FTB \'Costaguana\'" = "Free Trade Beacon \'Costaguana\': \"Bienvenidos, weary travelers. Collect your mind while you inhale the finest synthetic tobacco in Hanza space.\"",
	)
	icon_states = list("htu_station", "station")
	uid = "smoke"
	tree_x = 0.54
	tree_y = 0.8
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("casino")
	inventory = list(
		"Tobacco" = list(
			/obj/item/storage/fancy/cigarettes = custom_good_price(50),
			/obj/item/storage/fancy/cigcartons = custom_good_price(400),
			/obj/item/storage/fancy/cigarettes/dromedaryco = custom_good_price(50),
			/obj/item/storage/fancy/cigcartons/dromedaryco = custom_good_price(400),
			/obj/item/storage/fancy/cigarettes/killthroat = custom_good_price(50),
			/obj/item/storage/fancy/cigcartons/killthroat = custom_good_price(400),
			/obj/item/storage/fancy/cigarettes/homeless = custom_good_price(50),
			/obj/item/storage/fancy/cigcartons/homeless = custom_good_price(400),
			/obj/item/storage/fancy/cigar = custom_good_price(200),
			/obj/item/clothing/mask/smokable/cigarette/cigar = custom_good_price(40),
			/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = custom_good_price(100),
			/obj/item/clothing/mask/smokable/cigarette/cigar/havana = custom_good_price(100)
		),
		"Paraphernalia" = list(
			/obj/item/flame/lighter,
			/obj/item/flame/lighter/zippo,
			/obj/item/storage/box/matches,
			/obj/item/clothing/mask/smokable/pipe,
			/obj/item/clothing/mask/smokable/pipe/cobpipe,
			/obj/item/clothing/mask/vape = custom_good_price(100)
		)
	)
	hidden_inventory = list(
		"Drugs" = list(
			/obj/item/reagent_containers/glass/bottle/trade/psilocybin = good_data("psilocybin bottle", list(1, 3), 100),
			/obj/item/reagent_containers/glass/bottle/trade/impedrezene = good_data("impedrezene bottle", list(1, 3), 100),
			/obj/item/reagent_containers/glass/bottle/trade/cryptobiolin = good_data("cryptobiolin bottle", list(1, 3), 100)
		)
	)
	offer_types = list(
		/obj/item/seeds/tobaccoseed = offer_data("tobacco cultivars", 250, 4),
		/obj/item/oddity/common/lighter = offer_data("rusted lighter", 500, 1),
		/obj/item/oddity/common/mirror = offer_data("cracked mirror", 500, 1),
		/obj/item/oddity/common/old_newspaper = offer_data("old newspaper", 500, 1),
		/obj/item/oddity/common/photo_landscape = offer_data("alien landscape photo", 500, 1),
		/obj/item/oddity/common/book_bible = offer_data("old bible", 500, 1),
		/obj/item/oddity/common/book_unholy = offer_data("unholy book", 500, 1),
		/obj/item/oddity/common/book_omega = offer_data("occult book", 500, 1),
		/obj/item/oddity/artwork = offer_data("artistic oddity", 1600, 1),
		/obj/structure/artwork_statue = offer_data("artistic statue", 3200, 1),
		/obj/item/gun/projectile/revolver/artwork_revolver = offer_data("artistic revolver", 4000, 1)
	)
