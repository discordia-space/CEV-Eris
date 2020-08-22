/obj/random/closet
	name = "random closet"
	icon_state = "closet-grey"
	alpha = 128

/obj/random/closet/item_to_spawn()
	return pickweight(list(/obj/structure/closet = 4,
				/obj/spawner/closet/tech = 22,
				/obj/spawner/closet/wardrobe = 6,
				/obj/spawner/closet/lasertag = 2,
				/obj/structure/closet/gimmick/russian = 0.5,
				/obj/structure/closet/jcloset = 1,
				/obj/structure/closet/malf/suits =  0.5,
				/obj/structure/closet/syndicate/personal = 0.1,
				/obj/spawner/closet/bombcloset = 0.9))

/obj/random/closet/low_chance
	name = "low chance random closet"
	icon_state = "closet-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/closet/lasertag
	tags_to_spawn = list(SPAWN_LASERTAG_CLOSET)

/obj/spawner/closet/bombcloset
	tags_to_spawn = list(SPAWN_BOMB_CLOSET)

/obj/spawner/closet/tech
	name = "random technical closet"
	icon_state = "closet-orange"
	tags_to_spawn = list(SPAWN_TECHNICAL_CLOSET)

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
	tags_to_spawn = list(SPAWN_RANDOM_CLOSET)

/obj/spawner/closet/maintloot/low_chance
	name = "low chance random maint loot closet"
	icon_state = "closet-black-low"
	spawn_nothing_percentage = 60

// For Scrap Beacon
/obj/spawner/closet/maintloot/beacon
	allow_blacklist = TRUE
	exclusion_paths = list(/obj/structure/closet/random/hostilemobs)
