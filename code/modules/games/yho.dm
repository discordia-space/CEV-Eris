/* YHO
*/

/obj/item/storage/card_holder/yho
	name = "box of YHO cards"
	desc = "You get one, you get yho!"
	icon_state = "card_holder_yho"
	deck_type = /obj/item/deck/yho

/obj/item/deck/yho
	name = "deck of YHO cards"
	desc = "You get one, you get yho!"
	icon_state = "deck_yho"

/obj/item/deck/yho/New()
	..()

	var/datum/playingcard/P
	for(var/number in list("colorswap","colorswap","colorswap","colorswap","+4","+4","+4","+4"))
		P = new()
		P.name = "[number]"
		P.card_icon = "yho_[number]"
		P.back_icon = "card_back_yho"
		P.desc = "A wild YHO playing card."
		cards += P
	for(var/color in list("red","green","yellow","blue"))


		for(var/number in list("0","1","2","3","4","5","6","7","8","9","1","2","3","4","5","6","7","8","9","+2","+2","reverse","reverse","skip","skip")) //TODO: skip card (no sprite)
			P = new()
			P.name = "[color] [number]"
			P.card_icon = "[color]_[number]"
			P.back_icon = "card_back_yho"
			P.desc = "A [color] YHO playing card."
			cards += P
			
