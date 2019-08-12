//Closets full of loot, they should be placed in derelicts

/obj/structure/closet/random_onestar_tier1
	name = "\improper forgotten closet"
	desc = "Old and clean closet, probably older than you."
	icon_state = "lootcloset"
	old_chance = 50

/obj/structure/closet/random_miscellaneous/populate_contents()
	new /obj/random/contraband/low_chance(src)
	new /obj/random/contraband/low_chance(src)
	new /obj/random/pack/rare/low_chance(src)
	new /obj/random/junk(src)
	new /obj/random/junk(src)
	new /obj/random/junk(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/lowkeyrandom/low_chance(src)
	new /obj/random/pack/tech_loot/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/cloth/low_chance(src)
	new /obj/random/pack/gun_loot/low_chance(src)