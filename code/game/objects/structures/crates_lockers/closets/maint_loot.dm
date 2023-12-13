//Closets full of loot, they should be placed in maints
/obj/structure/closet/random
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_CLOSET_RANDOM
	rarity_value = 10
	bad_type = /obj/structure/closet/random
	spawn_blacklisted = FALSE

/obj/structure/closet/random/miscellaneous
	name = "\improper forgotten closet"
	desc = "Old and rusty, this closet is probably older than you."
	icon_state = "oldstyle"
	old_chance = 50
	rarity_value = 10

/obj/structure/closet/random/miscellaneous/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/contraband/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/contraband/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/rare/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/junk(NULL))
	spawnedAtoms.Add(new /obj/spawner/junk(NULL))
	spawnedAtoms.Add(new /obj/spawner/junk(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/cloth/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/cloth/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_adjacent_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_adjacent_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_adjacent_loot/low_chance(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/random/tech
	name = "\improper technical closet"
	desc = "Somewhat old closet with wrench sign on it."
	icon_state = "eng"
	icon_door = "eng_tool"
	old_chance = 10
	rarity_value = 15

/obj/structure/closet/random/tech/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot/low_chance(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)


/obj/structure/closet/random/spareparts
	name = "\improper spare parts closet"
	desc = "Somewhat old closet with spare parts in it."
	icon_state = "eng"
	icon_door = "eng_secure"
	old_chance = 10
	rarity_value = 50

/obj/structure/closet/random/spareparts/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/techpart(NULL))
	spawnedAtoms.Add(new /obj/spawner/techpart(NULL))
	spawnedAtoms.Add(new /obj/spawner/techpart(NULL))
	spawnedAtoms.Add(new /obj/spawner/techpart(NULL))
	spawnedAtoms.Add(new /obj/spawner/techpart(NULL))
	spawnedAtoms.Add(new /obj/spawner/techpart(NULL))
	spawnedAtoms.Add(new /obj/spawner/tool_upgrade(NULL))
	spawnedAtoms.Add(new /obj/spawner/tool_upgrade(NULL))
	spawnedAtoms.Add(new /obj/spawner/tool_upgrade(NULL))
	spawnedAtoms.Add(new /obj/spawner/lathe_disk(NULL))
	spawnedAtoms.Add(new /obj/spawner/lathe_disk/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/tech_loot/low_chance(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)






/obj/structure/closet/random/milsupply
	name = "\improper military supply closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	old_chance = 10
	rarity_value = 50

/obj/structure/closet/random/milsupply/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical/low_chance(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)





/obj/structure/closet/random/medsupply
	name = "\improper medical supply closet"
	desc = "Abandoned medical supply."
	icon_state = "freezer"
	old_chance = 10

/obj/structure/closet/random/medsupply/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical_lowcost(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical_lowcost(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical_lowcost(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical_lowcost(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/medical/low_chance(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)




/obj/structure/closet/secure_closet/rare_loot
	name = "\improper sealed military supply closet"
	desc = "The access pannel looks old. There is probably no ID's around that can open it."
	req_access = list(access_cent_specops) //You are suppose to hack it
	icon_state = "syndicate"
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_CLOSET_SECURE_RANDOM
	rarity_value = 100

/obj/structure/closet/secure_closet/rare_loot/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	spawnedAtoms.Add(new /obj/spawner/pack/gun_loot(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)



//Closet with unfair bullshit inside
/obj/structure/closet/random/hostilemobs
	name = "\improper forgotten closet"
	desc = "Old and rusty, this closet is probably older than you."
	icon_state = "oldstyle"
	old_chance = 70
	rarity_value = 12.5
	spawn_blacklisted = TRUE

/obj/structure/closet/random/hostilemobs/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL)) //To reward players for fighting this bullshit
	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/rations(NULL))
	spawnedAtoms.Add(new /obj/spawner/rations(NULL))
	spawnedAtoms.Add(new /obj/spawner/rations(NULL))
	spawnedAtoms.Add(new /obj/spawner/mob/roaches/cluster(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)

// Used for scrap beacon
/obj/structure/closet/random/hostilemobs/beacon
	rarity_value = 6

/obj/structure/closet/random/hostilemobs/beacon/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL)) //To reward players for fighting this bullshit
	spawnedAtoms.Add(new /obj/spawner/pack/rare(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/lowkeyrandom/low_chance(NULL))
	spawnedAtoms.Add(new /obj/spawner/rations(NULL))
	spawnedAtoms.Add(new /obj/spawner/rations(NULL))
	spawnedAtoms.Add(new /obj/spawner/rations(NULL))
	spawnedAtoms.Add(new /obj/spawner/mob/roaches/cluster/beacon(NULL))
	for(var/atom/a in spawnedAtoms)
		a.forceMove(src)
