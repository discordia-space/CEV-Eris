/datum/trade_station/industrial_chem
	name_pool = list(
		"AGTB 'Arctor'" = "Aster's Guild Trade Beacon 'Arctor':\nConnection with the Aster's Guild industrial surplus network established."
	)
	icon_states = list("htu_station", "station")
	uid = "industrial"
	tree_x = 0.26
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 3200
	hidden_inv_threshold = 0
	recommendation_threshold = 0
	stations_recommended = list()
	recommendations_needed = 1
	inventory = list(
		"Industrial Chemical Supply" = list(
			/obj/structure/reagent_dispensers/watertank,
			/obj/structure/reagent_dispensers/fueltank,
			/obj/structure/reagent_dispensers/coolanttank,
			/obj/structure/reagent_dispensers/coolanttank/refrigerant,
			/obj/structure/reagent_dispensers/bidon/cleaner = custom_good_name("B.I.D.O.N. canister (space cleaner)"),
			/obj/structure/reagent_dispensers/bidon/aranecolmic_acid_hydrazide = good_data("B.I.D.O.N. canister (aranecolmic acid hydrazide)", list(2, 3), null),
			/obj/structure/reagent_dispensers/bidon/diploptillin = good_data("B.I.D.O.N. canister (diploptillin)", list(2, 3), null),
			/obj/structure/reagent_dispensers/bidon/gewalkellin = good_data("B.I.D.O.N. canister (gewalkellin)", list(2, 3), null)
		),
		"Containers" = list(
			/obj/item/reagent_containers/spray,
			/obj/item/reagent_containers/glass/bucket,
			/obj/structure/reagent_dispensers/bidon
		)
	)
	offer_types = list(
		/datum/reagent/drug/paroin = offer_data("paroin (60u)", 2500, 4),
		/datum/reagent/drug/crystal_dream = offer_data("crystal dream (60u)", 7500, 4),
		/datum/reagent/alcohol/roachbeer = offer_data("Kakerlakenbier (60u)", 2500, 2),
		/datum/reagent/alcohol/kaiserbeer = offer_data("Monarchenblut (60u)", 50000, 1)
	)
