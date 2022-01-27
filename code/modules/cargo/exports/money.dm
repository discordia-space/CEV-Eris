// Space Cash. Now it isn't that useless.
/datum/export/stack/cash
	cost = 1 //69ultiplied both by69alue of each bill and by amount of bills in stack.
	unit_name = "credit chip"
	export_types = list(/obj/item/spacecash)

/datum/export/stack/cash/get_amount(obj/O)
	var/obj/item/spacecash/C = O
	return ..() * C.worth


// Coins. At least the coins that do not contain any69aterials.
//69aterial-containing coins cost just as69uch as their69aterials do, see69aterials.dm for exact rates.
/datum/export/coin
	cost = 1 //69ultiplied by coin's69alue
	unit_name = "credit coin"
	message = "worth of rare coins"
	export_types = list(/obj/item/coin)

/datum/export/coin/get_cost(obj/O, contr = 0, emag = 0)
	var/price = 0
	switch(O.name)
		if(COIN_STANDARD)
			price = 15
		if(COIN_IRON)
			price = 50
		if(COIN_SILVER)
			price = 100
		if(COIN_GOLD)
			price = 150
		if(COIN_URANIUM)
			price = 180
		if(COIN_PLASMA)
			price = 220
		if(COIN_PLATINUM)
			price = 300
		if(COIN_DIAMOND)
			price = 350
		else
			price = 1
	return ..() * price
