/*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/items.dmi'
	name = COIN_STANDARD
	icon_state = "coin"
	flags = CONDUCT
	force = 0
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2

/obj/item/coin/Initialize(mapload)
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/coin/gold
	name = COIN_GOLD
	icon_state = "coin_gold"
	matter = list(MATERIAL_GOLD = 0.2)
	price_tag = 10

/obj/item/coin/silver
	name = COIN_SILVER
	icon_state = "coin_silver"
	matter = list(MATERIAL_SILVER = 0.2)
	price_tag = 8

/obj/item/coin/diamond
	name = COIN_DIAMOND
	icon_state = "coin_diamond"
	matter = list(MATERIAL_DIAMOND = 0.2)
	price_tag = 20

/obj/item/coin/plasteel
	name = COIN_PLASTEEL
	icon_state = "coin_iron"
	matter = list(MATERIAL_PLASTEEL = 0.2)
	price_tag = 6

/obj/item/coin/plasma
	name = COIN_PLASMA
	icon_state = "coin_plasma"
	matter = list(MATERIAL_PLASMA = 0.2)
	price_tag = 6

/obj/item/coin/uranium
	name = COIN_URANIUM
	icon_state = "coin_uranium"
	matter = list(MATERIAL_URANIUM = 0.2)
	price_tag = 10

/obj/item/coin/platinum
	name = COIN_PLATINUM
	icon_state = "coin_adamantine"
	matter = list(MATERIAL_PLATINUM = 0.2)
	price_tag = 16

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, span_notice("There already is a string attached to this coin."))
			return
		if (CC.use(1))
			overlays += image('icons/obj/items.dmi',"coin_string_overlay")
			string_attached = 1
			to_chat(user, span_notice("You attach a string to the coin."))
		else
			to_chat(user, span_notice("This cable coil appears to be empty."))
		return
	else if(istype(W,/obj/item/tool/wirecutters))
		if(!string_attached)
			..()
			return

		new /obj/item/stack/cable_coil(user.loc, 1)
		overlays = list()
		string_attached = null
		to_chat(user, span_blue("You detach the string from the coin."))
	else ..()

/obj/item/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message(span_notice("[user] has thrown \the [src]. It lands on [comment]! "), \
						 span_notice("You throw \the [src]. It lands on [comment]! "))
