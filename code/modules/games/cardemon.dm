/obj/item/pack/cardemon
	name = "\improper Cardemon booster pack"
	desc = "Finally! A children's card game in space!"
	icon_state = "card_pack_cardemon"

/obj/item/pack/cardemon/Initialize(mapload, ...)
	. = ..()
	var/datum/playingcard/P
	var/i
	for(i=0; i<5; i++)
		var/rarity
		if(prob(10))
			if(prob(5))
				if(prob(5))
					rarity = "Plasteel"
				else
					rarity = "Platinum"
			else
				rarity = "Silver"

		var/nam = pick("Death","Life","Plant","Leaf","Air","Earth","Fire","Water","Killer","Holy", "God", "Ordinary","Demon","Angel", "Plasma", "Mad", "Insane", "Metal", "Steel", "Secret")
		var/nam2 = pick("Carp", "Corgi", "Cat", "Mouse", "Octopus", "Lizard", "Monkey", "Plant", "Duck", "Demon", "Spider", "Bird", "Shark", "Rock")

		P = new()
		P.name = "69nam69 69nam269"
		P.card_icon = "card_cardemon"
		if(rarity)
			P.name = "69rarity69 69P.name69"
			P.card_icon += "_69rarity69"
		P.back_icon = "card_back_cardemon"
		P.desc = "Wow! A Cardemon card. Its stats are: 69rand(1,15)69 69pick("vim","vigor","muscle","ire")69, 69rand(1,15)69 69pick("mind", "brain", "meat", "metal", "money")69, 69rand(1,15)69 69pick("life", "death", "speed", "agility", "spaghetti")69"
		cards += P