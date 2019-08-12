//Closets full of loot, they should be placed in derelicts

// Tier 1
/obj/structure/closet/onestar/tier1
	name = "\improper oneStar forgotten closet"
	desc = "Old OneStar closet, it may contain junk loot."
	icon_state = "lootcloset"

/obj/structure/closet/onestar/tier1/populate_contents()
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

// Tier 2
/obj/structure/closet/onestar/tier2
	name = "\improper oneStar forgotten closet"
	desc = "Old OneStar closet, it may contain some good loot."
	icon_state = "lootcloset1"

/obj/structure/closet/onestar/tier2/populate_contents()
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

// Tier 3
/obj/structure/closet/onestar/tier2
	name = "\improper oneStar forgotten closet"
	desc = "Old OneStar closet, it may contain legendary loot."
	icon_state = "lootcloset2"

/obj/structure/closet/onestar/tier3/populate_contents()
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


// Normal closets
//Tier 1
/obj/structure/closet/onestar/tier1/normal
	name = "\improper oneStar forgotten closet"
	icon_state = "lootcloset"
	old_chance = 70
//Tier 2
/obj/structure/closet/onestar/tier2/normal
	name = "\improper oneStar forgotten closet"
	icon_state = "lootcloset1"
	old_chance = 30

//Tier 3
/obj/structure/closet/onestar/tier3/normal
	name = "\improper oneStar forgotten closet"
	icon_state = "lootcloset2"
	old_chance = 10

