// roach toxin bottles defined in module/reagents/reagent_containters/glass/bottle.dm
/datum/trade_station/trapper
	name_pool = list(
		"EXT 'Armitage'" = "Exterminator 'Armitage':\n\"Greetings, Eris. We're in a bit of a rough spot at the moment. Got any traps to spare?\".",
	)
	start_discovered = FALSE
	spawn_always = TRUE
	markup = UNIQUE_GOODS
	markdown = 0
	base_income = 3200
	wealth = -48000
	secret_inv_threshold = 32000
	assortiment = list(
		"Roach Cubes and Eggs" = list(
			/obj/item/roach_egg = custom_good_amount_range(list(5, 20)),
			/obj/item/reagent_containers/food/snacks/roachcube/roachling = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/kampfer = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/jager = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/seuche = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/panzer = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/gestrahlte = custom_good_amount_range(list(1, 5)),
		),
		"Roach Toxins" = list(
			/obj/item/reagent_containers/glass/bottle/blattedin = custom_good_amount_range(list(-1, 2)),
			/obj/item/reagent_containers/glass/bottle/diplopterum = custom_good_amount_range(list(-1, 2)),
			/obj/item/reagent_containers/glass/bottle/seligitillin = custom_good_amount_range(list(-1, 2)),
			/obj/item/reagent_containers/glass/bottle/starkellin = custom_good_amount_range(list(-1, 2)),
			/obj/item/reagent_containers/glass/bottle/gewaltine = custom_good_amount_range(list(-1, 2)),
		),
		"Spider Toxins" = list(
			/obj/item/reagent_containers/glass/bottle/pararein = custom_good_amount_range(list(-1, 2)),
			/obj/item/reagent_containers/glass/bottle/aranecolmin = custom_good_amount_range(list(-1, 2))
		),
		"Carp Toxins" = list(
			/obj/item/reagent_containers/glass/bottle/carpotoxin = custom_good_amount_range(list(-1, 2))
		),
	)
	secret_inventory = list(
		"High-End Roach Product" = list(
			/obj/item/reagent_containers/food/snacks/roachcube/kraftwerk = custom_good_amount_range(list(1, 5)),
			/obj/item/reagent_containers/food/snacks/roachcube/fuhrer = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/fuhrerole = custom_good_amount_range(list(2, 2)),
			/obj/item/reagent_containers/glass/bottle/kaiseraurum = custom_good_amount_range(list(1, 1))
		),
		"Just Spiders" = list(
			/mob/living/carbon/superior_animal/giant_spider = custom_good_amount_range(list(5, 5)),
			/mob/living/carbon/superior_animal/giant_spider/nurse = custom_good_amount_range(list(5, 5)),
			/mob/living/carbon/superior_animal/giant_spider/hunter = custom_good_amount_range(list(5, 5))
		),
		"Bluespace Roach" = list(
			/mob/living/carbon/superior_animal/roach/bluespace = custom_good_amount_range(list(5, 10))
		)
	)
	//Types of items bought by the station
	offer_types = list(
		/obj/item/mine/old = offer_data("old landmine", 1200, 0),
		/obj/item/beartrap/makeshift = offer_data("makeshift mechanical trap", 600, 0),
		/obj/item/device/assembly/mousetrap = offer_data("mousetrap", 200, 0)
	)