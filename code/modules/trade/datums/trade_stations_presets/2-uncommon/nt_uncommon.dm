/datum/trade_station/nt_cruisers
	name_pool = list(
		"NTV 'Hope'" = "They are sending message, \"Reliable, blessed and sanctified goods for the correct price.\""
	)
	icon_states = "nt_cruiser"
	uid = "nt_uncommon"
	markup = RARE_GOODS		// dept-specific stuff should be more expensive for guild
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
    recommendations_needed = 1
	assortiment = list(
		"Cloth" = list(
			/obj/item/storage/pouch/small_generic,
			/obj/item/storage/pouch/medium_generic,
		),
		"Energy Weapons" = list(
			/obj/item/gun/energy/ionrifle = custom_good_amount_range(list(1, 4)),
			/obj/item/gun/energy/plasma = custom_good_amount_range(list(-3, 2)),
		),
		"Animals" = list(
			
		)
	)
    secret_inventory = list(
        "Cloth II" = list(
            /obj/item/storage/pouch/large_generic,
        )
    )
