/datum/trade_station/lancer
	name_pool = list("IRS 'Lancer'" = "IRS Trash Railgun 'Lancer'. They're sending a message. \"Hoho, you want some Trash?\"")
	spawn_probability = 90
	assortiment = list(
		"Trash" = list(/obj/spawner/scrap/dense = custom_good_amount_range(list(6, 80)))
	)

/obj/spawner/scrap
	price_tag = 50

