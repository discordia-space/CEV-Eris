/datum/trade_station/nt_uncommon
	name_pool = list(
		"NTV 'Hope'" = "They are sending message, \"Reliable, blessed and sanctified goods for the correct price.\""
	)
	icon_states = "nt_cruiser"
	uid = "nt_uncommon"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS		// dept-specific stuff should be more expensive for guild
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
			/obj/item/seeds/bananaseed,
			/obj/item/seeds/berryseed,
			/obj/item/seeds/carrotseed,
			/obj/item/seeds/chantermycelium,
			/obj/item/seeds/chiliseed,
			/obj/item/seeds/cornseed,
			/obj/item/seeds/eggplantseed,
			/obj/item/seeds/potatoseed,
			/obj/item/seeds/soyaseed,
			/obj/item/seeds/sunflowerseed,
			/obj/item/seeds/tomatoseed,
			/obj/item/seeds/towermycelium,
			/obj/item/seeds/wheatseed,
			/obj/item/seeds/appleseed,
			/obj/item/seeds/poppyseed,
			/obj/item/seeds/sugarcaneseed,
			/obj/item/seeds/ambrosiavulgarisseed,
			/obj/item/seeds/peanutseed,
			/obj/item/seeds/whitebeetseed,
			/obj/item/seeds/watermelonseed,
			/obj/item/seeds/limeseed,
			/obj/item/seeds/lemonseed,
			/obj/item/seeds/orangeseed,
			/obj/item/seeds/grassseed,
			/obj/item/seeds/cocoapodseed,
			/obj/item/seeds/plumpmycelium,
			/obj/item/seeds/cabbageseed,
			/obj/item/seeds/grapeseed,
			/obj/item/seeds/pumpkinseed,
			/obj/item/seeds/cherryseed,
			/obj/item/seeds/plastiseed,
			/obj/item/seeds/riceseed,
			/obj/item/seeds/tobaccoseed
		)
	)
	secret_inventory = list(
		"Seeds II" = list(
			/obj/item/seeds/amanitamycelium,
			/obj/item/seeds/glowshroom,
			/obj/item/seeds/libertymycelium,
			/obj/item/seeds/mtearseed,
			/obj/item/seeds/nettleseed,
			/obj/item/seeds/reishimycelium,
			/obj/item/seeds/shandseed,
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
