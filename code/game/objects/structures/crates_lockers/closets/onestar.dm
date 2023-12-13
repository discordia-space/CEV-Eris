//Closets full of loot, they should be placed in derelicts

//// Loot table on all tiers
/obj/structure/closet/onestar
	spawn_blacklisted = TRUE
	bad_type = /obj/structure/closet/onestar
	spawn_tags = SPAWN_TAG_CLOSET_OS

// Tier 1
/obj/structure/closet/onestar/tier1
	name = "\improper OneStar forgotten closet"
	desc = "An old OneStar closet. Doesn't seem like it contains anything worthwhile. Probably."
	icon_state = "lootcloset"

/obj/structure/closet/onestar/tier1/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/junk(src)
	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/gun_loot/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

// Tier 2
/obj/structure/closet/onestar/tier2
	name = "\improper OneStar forgotten closet"
	desc = "An old OneStar closet. Looks like there might be some decent stuff inside."
	icon_state = "lootcloset1"

/obj/structure/closet/onestar/tier2/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/tool/advanced/onestar/low_chance(src)
	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/gun_loot/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)

// Tier 3
/obj/structure/closet/onestar/tier3
	name = "\improper OneStar forgotten closet"
	desc = "An old OneStar closet. Might contain something very valuable, or so you hope."
	icon_state = "lootcloset2"

/obj/structure/closet/onestar/tier3/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/junk(src)
	new /obj/spawner/pack/tech_loot/onestar(src)
	new /obj/spawner/tool/advanced/onestar(src)
	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/gun_loot/low_chance(src)
	new /obj/spawner/tool/advanced/onestar/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)


////// Closets

////Normal
//Tier 1
/obj/structure/closet/onestar/tier1/normal
	name = "\improper OneStar forgotten closet"
	icon_state = "lootcloset"
	old_chance = 70

// Empty
/obj/structure/closet/onestar/tier1/normal/empty
/obj/structure/closet/onestar/tier1/normal/empty/populate_contents()

//Tier 2
/obj/structure/closet/onestar/tier2/normal
	name = "\improper OneStar forgotten closet"
	icon_state = "lootcloset1"
	old_chance = 30

// Empty
/obj/structure/closet/onestar/tier2/normal/empty
/obj/structure/closet/onestar/tier2/normal/empty/populate_contents()

//Tier 3
/obj/structure/closet/onestar/tier3/normal
	name = "\improper OneStar forgotten closet"
	icon_state = "lootcloset2"
	old_chance = 10

// Empty
/obj/structure/closet/onestar/tier3/normal/empty
/obj/structure/closet/onestar/tier3/normal/empty/populate_contents()


////Special
//Tier 1
/obj/structure/closet/onestar/tier1/special
	name = "\improper OneStar forgotten closet"
	icon_state = "special_lootcloset"
	old_chance = 70

/obj/structure/closet/onestar/tier1/special/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier1/special/empty
/obj/structure/closet/onestar/tier1/special/empty/populate_contents()

//Tier 2
/obj/structure/closet/onestar/tier2/special
	name = "\improper OneStar forgotten closet"
	icon_state = "special_lootcloset1"
	old_chance = 30

/obj/structure/closet/onestar/tier2/special/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier2/special/empty
/obj/structure/closet/onestar/tier2/special/empty/populate_contents()

//Tier 3
/obj/structure/closet/onestar/tier3/special
	name = "\improper OneStar forgotten closet"
	icon_state = "special_lootcloset2"
	old_chance = 10

/obj/structure/closet/onestar/tier3/special/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier3/special/empty
/obj/structure/closet/onestar/tier3/special/empty/populate_contents()

////Mineral
//Tier 1
/obj/structure/closet/onestar/tier1/mineral
	name = "\improper OneStar forgotten closet"
	icon_state = "mineral_lootcloset"
	old_chance = 70

/obj/structure/closet/onestar/tier1/mineral/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier1/mineral/empty
/obj/structure/closet/onestar/tier1/mineral/empty/populate_contents()

//Tier 2
/obj/structure/closet/onestar/tier2/mineral
	name = "\improper OneStar forgotten closet"
	icon_state = "mineral_lootcloset1"
	old_chance = 30

/obj/structure/closet/onestar/tier2/mineral/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier2/mineral/empty
/obj/structure/closet/onestar/tier2/mineral/empty/populate_contents()

//Tier 3
/obj/structure/closet/onestar/tier3/mineral
	name = "\improper OneStar forgotten closet"
	icon_state = "mineral_lootcloset2"
	old_chance = 10

/obj/structure/closet/onestar/tier3/mineral/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier3/mineral/empty
/obj/structure/closet/onestar/tier3/mineral/empty/populate_contents()

////Medical
//Tier 1
/obj/structure/closet/onestar/tier1/medical
	name = "\improper OneStar forgotten closet"
	icon_state = "medical_lootcloset"
	old_chance = 70

/obj/structure/closet/onestar/tier1/medical/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier1/medical/empty
/obj/structure/closet/onestar/tier1/medical/empty/populate_contents()

//Tier 2
/obj/structure/closet/onestar/tier2/medical
	name = "\improper OneStar forgotten closet"
	icon_state = "medical_lootcloset1"
	old_chance = 30

/obj/structure/closet/onestar/tier2/medical/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier2/medical/empty
/obj/structure/closet/onestar/tier2/medical/empty/populate_contents()

//Tier 3
/obj/structure/closet/onestar/tier3/medical
	name = "\improper OneStar forgotten closet"
	icon_state = "medical_lootcloset2"
	old_chance = 10

/obj/structure/closet/onestar/tier3/medical/populate_contents()
	var/list/spawnedAtoms = list()

	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom(src)
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
	..()

// Empty
/obj/structure/closet/onestar/tier3/medical/empty
/obj/structure/closet/onestar/tier3/medical/empty/populate_contents()
