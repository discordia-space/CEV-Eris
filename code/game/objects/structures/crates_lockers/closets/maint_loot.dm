//Closets full of loot, they should be placed in69aints
/obj/structure/closet/random
	spawn_fre69uency = 10
	spawn_ta69s = SPAWN_TA69_CLOSET_RANDOM
	rarity_value = 10
	bad_type = /obj/structure/closet/random
	spawn_blacklisted = FALSE

/obj/structure/closet/random/miscellaneous
	name = "\improper for69otten closet"
	desc = "Old and rusty, this closet is probably older than you."
	icon_state = "oldstyle"
	old_chance = 50
	rarity_value = 10

/obj/structure/closet/random/miscellaneous/populate_contents()
	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/contraband/low_chance(src)
	new /obj/spawner/pack/rare/low_chance(src)
	new /obj/spawner/junk(src)
	new /obj/spawner/junk(src)
	new /obj/spawner/junk(src)
	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/cloth/low_chance(src)
	new /obj/spawner/pack/69un_adjacent_loot/low_chance(src)
	new /obj/spawner/pack/69un_adjacent_loot/low_chance(src)
	new /obj/spawner/pack/69un_adjacent_loot/low_chance(src)


/obj/structure/closet/random/tech
	name = "\improper technical closet"
	desc = "Somewhat old closet with wrench si69n on it."
	icon_state = "en69"
	icon_door = "en69_tool"
	old_chance = 10
	rarity_value = 15

/obj/structure/closet/random/tech/populate_contents()
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/pack/tech_loot(src)
	new /obj/spawner/pack/tech_loot(src)
	new /obj/spawner/pack/tech_loot(src)
	new /obj/spawner/pack/tech_loot(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)


/obj/structure/closet/random/spareparts
	name = "\improper spare parts closet"
	desc = "Somewhat old closet with spare parts in it."
	icon_state = "en69"
	icon_door = "en69_secure"
	old_chance = 10
	rarity_value = 50

/obj/structure/closet/random/spareparts/populate_contents()
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/techpart(src)
	new /obj/spawner/techpart(src)
	new /obj/spawner/techpart(src)
	new /obj/spawner/techpart(src)
	new /obj/spawner/techpart(src)
	new /obj/spawner/techpart(src)
	new /obj/spawner/tool_up69rade(src)
	new /obj/spawner/tool_up69rade(src)
	new /obj/spawner/tool_up69rade(src)
	new /obj/spawner/lathe_disk(src)
	new /obj/spawner/lathe_disk/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)
	new /obj/spawner/pack/tech_loot/low_chance(src)






/obj/structure/closet/random/milsupply
	name = "\improper69ilitary supply closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	old_chance = 10
	rarity_value = 50

/obj/structure/closet/random/milsupply/populate_contents()
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/pack/69un_loot/low_chance(src)
	new /obj/spawner/medical/low_chance(src)
	new /obj/spawner/medical/low_chance(src)
	new /obj/spawner/medical/low_chance(src)





/obj/structure/closet/random/medsupply
	name = "\improper69edical supply closet"
	desc = "Abandoned69edical supply."
	icon_state = "freezer"
	old_chance = 10

/obj/structure/closet/random/medsupply/populate_contents()
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/medical_lowcost(src)
	new /obj/spawner/medical_lowcost(src)
	new /obj/spawner/medical_lowcost(src)
	new /obj/spawner/medical_lowcost(src)
	new /obj/spawner/medical(src)
	new /obj/spawner/medical(src)
	new /obj/spawner/medical(src)
	new /obj/spawner/medical/low_chance(src)
	new /obj/spawner/medical/low_chance(src)




/obj/structure/closet/secure_closet/rare_loot
	name = "\improper sealed69ilitary supply closet"
	desc = "The access pannel looks old. There is probably no ID's around that can open it."
	re69_access = list(access_cent_specops) //You are suppose to hack it
	icon_state = "syndicate"
	spawn_blacklisted = FALSE
	spawn_ta69s = SPAWN_TA69_CLOSET_SECURE_RANDOM
	rarity_value = 100

/obj/structure/closet/secure_closet/rare_loot/populate_contents()
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)
	new /obj/spawner/pack/69un_loot(src)



//Closet with unfair bullshit inside
/obj/structure/closet/random/hostilemobs
	name = "\improper for69otten closet"
	desc = "Old and rusty, this closet is probably older than you."
	icon_state = "oldstyle"
	old_chance = 70
	rarity_value = 12.5
	spawn_blacklisted = TRUE

/obj/structure/closet/random/hostilemobs/populate_contents()
	new /obj/spawner/pack/rare(src) //To reward players for fi69htin69 this bullshit
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/rations(src)
	new /obj/spawner/rations(src)
	new /obj/spawner/rations(src)
	new /obj/spawner/mob/roaches/cluster(src)

// Used for scrap beacon
/obj/structure/closet/random/hostilemobs/beacon
	rarity_value = 6

/obj/structure/closet/random/hostilemobs/beacon/populate_contents()
	new /obj/spawner/pack/rare(src) //To reward players for fi69htin69 this bullshit
	new /obj/spawner/pack/rare(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/lowkeyrandom/low_chance(src)
	new /obj/spawner/rations(src)
	new /obj/spawner/rations(src)
	new /obj/spawner/rations(src)
	new /obj/spawner/mob/roaches/cluster/beacon(src)
