/obj/random/closet
	name = "random closet"
	icon_state = "closet-grey"
	alpha = 128

/obj/random/closet/item_to_spawn()
	return pickweight(list(/obj/structure/closet = 4,
				/obj/spawner/closet_tech = 8,
				/obj/spawner/closet_tech = 6,
				/obj/spawner/closet_wardrobe = 1,
				/obj/spawner/closet_wardrobe = 1,
				/obj/spawner/closet_wardrobe = 1,
				/obj/spawner/closet_wardrobe = 1,
				/obj/spawner/closet_wardrobe = 1,
				/obj/spawner/closet_wardrobe = 1,
				/obj/structure/closet/lasertag/red = 1,
				/obj/structure/closet/lasertag/blue = 1,
				/obj/spawner/closet_tech = 8,
				/obj/structure/closet/gimmick/russian = 0.5,
				/obj/structure/closet/jcloset = 1,
				/obj/structure/closet/malf/suits =  0.5,
				/obj/structure/closet/syndicate/personal = 0.1,
				/obj/structure/closet/bombcloset = 0.5,
				/obj/structure/closet/bombcloset/security = 0.4))

/obj/random/closet/low_chance
	name = "low chance random closet"
	icon_state = "closet-grey-low"
	spawn_nothing_percentage = 60


/obj/spawner/closet_tech
	name = "random technical closet"
	icon_state = "closet-orange"
	tags_to_spawn = list(SPAWN_TECHNICAL_CLOSET)

/obj/spawner/closet_tech/low_chance
	name = "low chance random technical closet"
	icon_state = "closet-orange-low"
	spawn_nothing_percentage = 60


/obj/spawner/closet_wardrobe
	name = "random wardrobe closet"
	icon_state = "closet-blue"
	tags_to_spawn = list(SPAWN_WARDROBE)

/obj/spawner/closet_wardrobe/low_chance
	name = "low chance random wardrobe closet"
	icon_state = "closet-blue-low"
	spawn_nothing_percentage = 60


/obj/spawner/closet_maintloot
	name = "random maint loot closet"
	icon_state = "closet-black"
	tags_to_spawn = list(SPAWN_RANDOM_CLOSET)

/obj/spawner/closet_maintloot/low_chance
	name = "low chance random maint loot closet"
	icon_state = "closet-black-low"
	spawn_nothing_percentage = 60

// For Scrap Beacon
/obj/spawner/closet_maintloot/beacon
	allow_blacklist = TRUE
	exclude_paths = list(/obj/structure/closet/random/hostilemobs)
