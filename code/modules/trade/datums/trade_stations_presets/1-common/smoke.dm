/datum/trade_station/smoke
	name_pool = list(
		"FTB \'Costaguana\'" = "Free Trade Beacon \'Costaguana\': \"Bienvenidos, weary travelers. Collect your mind while you inhale the finest synthetic tobacco in Hanza space.\"",
	)
	uid = "smoke"
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
			/obj/item/storage/fancy/cigarettes,
			/obj/item/storage/fancy/cigcartons,
			/obj/item/storage/fancy/cigarettes/dromedaryco,
			/obj/item/storage/fancy/cigcartons/dromedaryco,
			/obj/item/storage/fancy/cigarettes/killthroat,
			/obj/item/storage/fancy/cigcartons/killthroat,
			/obj/item/storage/fancy/cigarettes/homeless,
			/obj/item/storage/fancy/cigcartons/homeless,
			/obj/item/storage/fancy/cigar,
			/obj/item/clothing/mask/smokable/cigarette/cigar,
			/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,
			/obj/item/clothing/mask/smokable/cigarette/cigar/havana
		),
		"Paraphernalia" = list(
			/obj/item/flame/lighter,
			/obj/item/flame/lighter/zippo,
			/obj/item/storage/box/matches,
			/obj/item/clothing/mask/smokable/pipe,
			/obj/item/clothing/mask/smokable/pipe/cobpipe,
			/obj/item/clothing/mask/vape
		)
	)
	hidden_inventory = list(
		// drugs?
	)
	offer_types = list(
		/obj/item/gun/projectile/revolver/artwork_revolver = offer_data("artistic revolver", 2000, 1),
		/obj/structure/artwork_statue = offer_data("artistic statue", 600, 1)
	)
