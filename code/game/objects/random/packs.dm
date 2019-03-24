/*
This file contains random spawners of random spawners, and this is ONLY subtype that should do that.
DO NOT use random spawners in other random spawners.
DO NOT use random spawners of random spawners in other random spawners. Yes, that was done once.
Packs are meant to be send mainly to junkpiles, but can be placed on map as well.
They generally give more random result and can provide more divercity in spawn.
*/

/obj/random/pack/cloth
	name = "Random cloth supply"
	desc = "This is a random cloth supply."

/obj/random/pack/cloth/item_to_spawn()
	return pickweight(list(


					/obj/random/cloth/glasses = 4,
					/obj/random/cloth/gloves = 12,

				))


/obj/random/pack/structure/item_to_spawn()
	return pickweight(list(


					/obj/random/cloth/glasses = 4,
					/obj/random/cloth/gloves = 12,

				))

