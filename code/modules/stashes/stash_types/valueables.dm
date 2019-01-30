//Valueables stashes.
//Contain credits and rare materials. Shiny gold and gems
/datum/stash/valueable
	base_type = /datum/stash/valueable
	loot_type = "Valueables"
	contents_list_base = list(/obj/random/credits/c5000 = 1)

	contents_list_random = list(/obj/item/stack/material/diamond/random = 10,
	/obj/item/stack/telecrystal/random = 5,
	/obj/item/stack/material/platinum/random = 10,
	/obj/item/stack/material/gold/random = 15,
	/obj/item/stack/material/silver/random = 25,
	/obj/random/credits/c5000 = 30,
	/obj/random/credits/c1000 = 60,
	/obj/random/credits/c500 = 90)

/datum/stash/valueable/poker

	lore = "Logbook <br>\
	Made out like a bandit in poker last night but the boys think there's something to it. It isn't my\
	 damn fault the kids don't know what a fucking tell is. Two hearts does not make a good bluff, \
	 dumbass. I actually think they might shake me down for it, but they don't know the ship like I do.\
	  Here ya go, idiots. Better than a thousand words.<br> %D"