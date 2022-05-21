/* this is a playing card deck based off of the Rider-Waite Tarot Deck.
*/

/obj/item/deck/tarot
	name = "deck of tarot cards"
	desc = "For all your occult needs!"
	icon_state = "deck_tarot"

/obj/item/deck/tarot/New()
	..()

	var/datum/playingcard/P
	for(var/name in list("Fool","Magician","High Priestess","Empress","Emperor","Hierophant","Lovers","Chariot","Strength","Hermit","Wheel of Fortune","Justice","Hanged Man","Death","Temperance","Devil","Tower","Star","Moon","Sun","Judgement","World"))
		P = new()
		P.name = "[name]"
		P.card_icon = "tarot_major"
		P.back_icon = "card_back_tarot"
		P.desc = "Some sort of major tarot card."
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))


		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","page","knight","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "tarot_[suit]"
			P.back_icon = "card_back_tarot"
			P.desc = "A Rider-Waite tarot card."
			cards += P

/obj/item/deck/tarot/attack_self(var/mob/user as mob)
	var/list/newcards = list()
	while(cards.len)
		var/datum/playingcard/P = pick(cards)
		P.name = replacetext(P.name," reversed","")
		if(prob(50))
			P.name += " reversed"
		newcards += P
		cards -= P
	cards = newcards
	user.visible_message("\The [user] shuffles [src].")

/* UNO
*/

/obj/item/storage/card_holder/yho
	name = "box of yho cards"
	desc = "You get one, you get yho!"
	icon_state = "card_holder_yho"
	deck_type = /obj/item/deck/yho

/obj/item/deck/yho
	name = "deck of yho cards"
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
		P.desc = "A wild yho playing card."
		cards += P
	for(var/color in list("red","green","yellow","blue"))


		for(var/number in list("0","1","2","3","4","5","6","7","8","9","1","2","3","4","5","6","7","8","9","+2","+2","reverse","reverse","skip","skip")) //TODO: skip card (no sprite)
			P = new()
			P.name = "[color] [number]"
			P.card_icon = "[color]_[number]"
			P.back_icon = "card_back_yho"
			P.desc = "A [color] yho playing card."
			cards += P