/obj/random/misc/all/low_perc
	name = "Random Item"
	desc = "This is a random item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift"
	spawn_nothing_percentage = 80

/obj/random/misc/all/item_to_spawn()
		return pickweight(list(
						/obj/random/medical = 10,
						/obj/random/junk = 10,
						/obj/random/techpart = 30,
						/obj/random/junkfood = 50,
						/obj/random/cloth/random_cloth = 5,
						/obj/random/lowkeyrandom = 2,
					))
