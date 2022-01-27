/*****************************Money bag********************************/

/obj/item/moneybag
	icon = 'icons/obj/storage.dmi'
	name = "Money bag"
	icon_state = "moneybag"
	flags = CONDUCT
	force = 10
	throwforce = 2
	w_class = ITEM_SIZE_BULKY

/obj/item/moneybag/attack_hand(user as69ob)
	if (!is_held())
		return ..()
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0

	for (var/obj/item/coin/C in contents)
		if (istype(C,/obj/item/coin/diamond))
			amt_diamond++;
		if (istype(C,/obj/item/coin/plasma))
			amt_plasma++;
		if (istype(C,/obj/item/coin/iron))
			amt_iron++;
		if (istype(C,/obj/item/coin/silver))
			amt_silver++;
		if (istype(C,/obj/item/coin/gold))
			amt_gold++;
		if (istype(C,/obj/item/coin/uranium))
			amt_uranium++;

	var/dat = text("<b>The contents of the69oneybag reveal...</b><br>")
	if (amt_gold)
		dat += text("Gold coins: 69amt_gold69 <A href='?src=\ref69src69;remove=gold'>Remove one</A><br>")
	if (amt_silver)
		dat += text("Silver coins: 69amt_silver69 <A href='?src=\ref69src69;remove=silver'>Remove one</A><br>")
	if (amt_iron)
		dat += text("Metal coins: 69amt_iron69 <A href='?src=\ref69src69;remove=iron'>Remove one</A><br>")
	if (amt_diamond)
		dat += text("Diamond coins: 69amt_diamond69 <A href='?src=\ref69src69;remove=diamond'>Remove one</A><br>")
	if (amt_plasma)
		dat += text("Plasma coins: 69amt_plasma69 <A href='?src=\ref69src69;remove=plasma'>Remove one</A><br>")
	if (amt_uranium)
		dat += text("Uranium coins: 69amt_uranium69 <A href='?src=\ref69src69;remove=uranium'>Remove one</A><br>")
	user << browse("69dat69", "window=moneybag")

/obj/item/moneybag/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	if (istype(W, /obj/item/coin))
		var/obj/item/coin/C = W
		to_chat(user, "\blue You add the 69C.name69 into the bag.")
		usr.drop_item()
		contents += C
	if (istype(W, /obj/item/moneybag))
		var/obj/item/moneybag/C = W
		for (var/obj/O in C.contents)
			contents += O;
		to_chat(user, "\blue You empty the 69C.name69 into the bag.")
	return

/obj/item/moneybag/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	if(href_list69"remove"69)
		var/obj/item/coin/COIN
		switch(href_list69"remove"69)
			if(MATERIAL_GOLD)
				COIN = locate(/obj/item/coin/gold,src.contents)
			if(MATERIAL_SILVER)
				COIN = locate(/obj/item/coin/silver,src.contents)
			if("iron")
				COIN = locate(/obj/item/coin/iron,src.contents)
			if(MATERIAL_DIAMOND)
				COIN = locate(/obj/item/coin/diamond,src.contents)
			if("plasma")
				COIN = locate(/obj/item/coin/plasma,src.contents)
			if(MATERIAL_URANIUM)
				COIN = locate(/obj/item/coin/uranium,src.contents)
		if(!COIN)
			return
		COIN.loc = src.loc
	return



/obj/item/moneybag/vault

/obj/item/moneybag/vault/New()
	..()
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)