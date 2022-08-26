// roach toxin bottles defined in module/reagents/reagent_containters/glass/bottle.dm
/datum/trade_station/trapper
	name_pool = list(
		"EXTV \'Armitage\'" = "Exterminator Vessel \'Armitage\': \"Greetings, CEV Eris. We\'re in a bit of a rough spot at the moment. Got any traps to spare?\"",
	)
	icon_states = list("htu_destroyer", "ship")
	uid = "trapper"
	tree_x = 0.46
	tree_y = 0.8
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 5
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	recommendations_needed = 2
	inventory = list(
		"Roach Cubes and Eggs" = list(
			/obj/item/storage/deferred/roacheggs = custom_good_price(250),	// make icon egg box
			/obj/item/reagent_containers/food/snacks/roachcube/roachling = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/kampfer = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/jager = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/seuche = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/panzer = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/gestrahlte = custom_good_amount_range(list(1, 5))
		),
		"Roach Toxins" = list(
			/obj/item/reagent_containers/glass/bottle/trade/blattedin = good_data("blattedin bottle", list(-1, 2), null),
			/obj/item/reagent_containers/glass/bottle/trade/diplopterum = good_data("diplopterum bottle", list(-1, 2), null),
			/obj/item/reagent_containers/glass/bottle/trade/seligitillin = good_data("seligitillin bottle", list(-1, 2), null),
			/obj/item/reagent_containers/glass/bottle/trade/starkellin = good_data("starkellin bottle", list(-1, 2), null),
			/obj/item/reagent_containers/glass/bottle/trade/gewaltine = good_data("gewaltine bottle", list(-1, 2), null)
		),
		"Spider Toxins" = list(
			/obj/item/reagent_containers/glass/bottle/trade/pararein = good_data("pararein bottle", list(-1, 2), null),
			/obj/item/reagent_containers/glass/bottle/trade/aranecolmin = good_data("aranacolmin bottle", list(-1, 2), null)
		),
		"Carp Toxins" = list(
			/obj/item/reagent_containers/glass/bottle/trade/carpotoxin = good_data("carpotoxin bottle", list(-1, 2), null)
		)
	)
	hidden_inventory = list(
		"High-End Roach Products" = list(
			/obj/item/reagent_containers/food/snacks/roachcube/kraftwerk = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/fuhrer = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/fuhrerole = good_data("fuhrerole bottle", list(1, 1), null)
		),
		"Spiders" = list(
			/obj/structure/largecrate/animal/giant_spider = custom_good_amount_range(list(5, 5)),
			/obj/structure/largecrate/animal/nurse_spider = custom_good_amount_range(list(5, 5)),
			/obj/structure/largecrate/animal/hunter_spider = custom_good_amount_range(list(5, 5))
		),
		"Bluespace Roach" = list(
			/obj/structure/largecrate/animal/bluespace_roach = custom_good_amount_range(list(5, 10))
		)
	)
	offer_types = list(
		/obj/item/mine/old = offer_data("old landmine", 1200, 0),
		/obj/item/beartrap/makeshift = offer_data("makeshift mechanical trap", 600, 0),
		/obj/item/device/assembly/mousetrap = offer_data("mousetrap", 200, 10)
	)
