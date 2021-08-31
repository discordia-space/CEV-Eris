/obj/spawner/closet
	name = "random closet"
	icon_state = "closet-grey"
	alpha = 128
	tags_to_spawn = list(SPAWN_CLOSET)

/obj/spawner/closet/low_chance
	name = "low chance random closet"
	icon_state = "closet-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/closet/tech
	name = "random technical closet"
	icon_state = "closet-orange"
	tags_to_spawn = list(SPAWN_CLOSET_TECHNICAL)

/obj/spawner/closet/tech/low_chance
	name = "low chance random technical closet"
	icon_state = "closet-orange-low"
	spawn_nothing_percentage = 60

/obj/spawner/closet/wardrobe
	name = "random wardrobe closet"
	icon_state = "closet-blue"
	tags_to_spawn = list(SPAWN_WARDROBE)

/obj/spawner/closet/wardrobe/low_chance
	name = "low chance random wardrobe closet"
	icon_state = "closet-blue-low"
	spawn_nothing_percentage = 60

/obj/spawner/closet/maintloot
	name = "random maint loot closet"
	icon_state = "closet-black"
	tags_to_spawn = list(SPAWN_CLOSET_RANDOM)
	exclusion_paths = list(/obj/structure/closet/random/hostilemobs/beacon)
	allow_blacklist = TRUE

/obj/spawner/closet/maintloot/low_chance
	name = "low chance random maint loot closet"
	icon_state = "closet-black-low"
	spawn_nothing_percentage = 60

// For Scrap Beacon
/obj/spawner/closet/maintloot/beacon
	exclusion_paths = list(/obj/structure/closet/random/hostilemobs)
