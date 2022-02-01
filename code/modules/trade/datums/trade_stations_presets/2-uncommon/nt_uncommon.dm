/datum/trade_station/nt_uncommon
	name_pool = list(
		"NTV 'Hope'" = "They are sending message, \"Reliable, blessed and sanctified goods for the correct price.\""
	)
	icon_states = "nt_cruiser"
	uid = "nt_uncommon"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = UNCOMMON_GOODS		// Dept-specific stuff should be more expensive for guild
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	recommendations_needed = 1
	assortiment = list(
		"Animals" = list(
			/obj/structure/largecrate/animal/corgi,
			/obj/structure/largecrate/animal/cow,
			/obj/structure/largecrate/animal/goat,
			/obj/structure/largecrate/animal/cat,
			/obj/structure/largecrate/animal/chick,
		),
		"Seeds" = list(
			/obj/item/seeds/bananaseed = custom_good_name("banana seeds"),
			/obj/item/seeds/berryseed = custom_good_name("berry seeds"),
			/obj/item/seeds/carrotseed = custom_good_name("carrot seeds"),
			/obj/item/seeds/chantermycelium  = custom_good_name("chanterelle spores"),
			/obj/item/seeds/chiliseed = custom_good_name("chili seeds"),
			/obj/item/seeds/cornseed  = custom_good_name("corn seeds"),
			/obj/item/seeds/eggplantseed = custom_good_name("eggplant seeds"),
			/obj/item/seeds/potatoseed = custom_good_name("potato seeds"),
			/obj/item/seeds/soyaseed = custom_good_name("soya seeds"),
			/obj/item/seeds/sunflowerseed  = custom_good_name("sunflower seeds"),
			/obj/item/seeds/tomatoseed = custom_good_name("tomato seeds"),
			/obj/item/seeds/towermycelium = custom_good_name("tower cap spores"),
			/obj/item/seeds/wheatseed = custom_good_name("wheat seeds"),
			/obj/item/seeds/appleseed = custom_good_name("apple seeds"),
			/obj/item/seeds/poppyseed = custom_good_name("poppy seeds"),
			/obj/item/seeds/sugarcaneseed = custom_good_name("sugar cane seeds"),
			/obj/item/seeds/ambrosiavulgarisseed = custom_good_name("ambrosia vulgaris seeds"),
			/obj/item/seeds/peanutseed = custom_good_name("peanut seeds"),
			/obj/item/seeds/whitebeetseed = custom_good_name("white beet seeds"),
			/obj/item/seeds/watermelonseed = custom_good_name("watermelon seeds"),
			/obj/item/seeds/limeseed = custom_good_name("lime seeds"),
			/obj/item/seeds/lemonseed = custom_good_name("lemon seeds"),
			/obj/item/seeds/orangeseed = custom_good_name("orange seeds"),
			/obj/item/seeds/grassseed = custom_good_name("grass seeds"),
			/obj/item/seeds/cocoapodseed = custom_good_name("cocoa pod seeds"),
			/obj/item/seeds/plumpmycelium = custom_good_name("plump helmet spores"),
			/obj/item/seeds/cabbageseed = custom_good_name("cabbage seeds"),
			/obj/item/seeds/grapeseed = custom_good_name("grape seeds"),
			/obj/item/seeds/pumpkinseed = custom_good_name("pumpkin seeds"),
			/obj/item/seeds/cherryseed = custom_good_name("cherry seeds"),
			/obj/item/seeds/plastiseed = custom_good_name("plastellium spores"),
			/obj/item/seeds/riceseed = custom_good_name("rice seeds"),
			/obj/item/seeds/tobaccoseed = custom_good_name("tobacco seeds")
		)
	)
	secret_inventory = list(
		"Seeds II" = list(
			/obj/item/seeds/amanitamycelium = custom_good_name("fly amanita spores"),
			/obj/item/seeds/glowshroom = custom_good_name("glowshroom spores"),
			/obj/item/seeds/libertymycelium = custom_good_name("liberty cap spores"),
			/obj/item/seeds/mtearseed = custom_good_name("Messa's tear seeds"),
			/obj/item/seeds/nettleseed = custom_good_name("nettle seeds"),
			/obj/item/seeds/reishimycelium = custom_good_name("reishi spores"),
			/obj/item/seeds/shandseed = custom_good_name("S'randar's hand seeds"),
		),
		"Pouches" = list(
			/obj/item/storage/pouch/small_generic,
			/obj/item/storage/pouch/medium_generic,
			/obj/item/storage/pouch/large_generic
		),
		"Energy Weapons" = list(
			/obj/item/gun/energy/ionrifle = custom_good_amount_range(list(1, 4)),
			/obj/item/gun/energy/plasma = custom_good_amount_range(list(-3, 2)),
		)
	)
	offer_types = list(
		/obj/item/oddity/nt/seal = offer_data("High Inquisitor's Seal", 1600, 2)
	)
