/datum/trade_station/rusty_blade
	name_pool = list("UTV 'Rusty Blade'" = "Unknown Trade Vessel 'Rusty Blade'. They're sending a message. \"Hey, dudes, we sell things for theta-7-oil manipulations fly in and check our wares!\"")
	assortiment = list(
		"Oil Mining" = list(
			/obj/item/organ/internal/heart = custom_good_name("Pump for Red Oil"),
			/obj/item/organ/internal/lungs = custom_good_name("Air Pump"),
			/obj/item/organ/internal/liver = custom_good_name("Oil Filter"),
			/obj/item/organ/internal/kidneys = custom_good_name("Oil Waste Paired Extractors"),
			/obj/item/organ/internal/eyes = custom_good_name("Oil-powered Sensors"),
		),
		"Equipment" = list(
			/obj/item/clothing/under/excelsior = custom_good_name("Random Oil Miner Uniform"),
		)
	)
	spawn_probability = 10
