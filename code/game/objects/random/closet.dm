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
	has_postspawn = TRUE
	tags_to_spawn = list(SPAWN_WARDROBE)

/obj/spawner/closet_wardrobe/low_chance
	name = "low chance random wardrobe closet"
	icon_state = "closet-blue-low"
	spawn_nothing_percentage = 60




/obj/random/closet_maintloot
	name = "random maint loot closet"
	icon_state = "closet-black"


/obj/random/closet_maintloot/item_to_spawn()
	return pickweight(list(/obj/structure/closet/random_miscellaneous = 10,
				/obj/structure/closet/random_tech = 6,
				/obj/structure/closet/random_milsupply = 2,
				/obj/structure/closet/random_medsupply = 6,
				/obj/structure/closet/random_hostilemobs = 8))

/obj/random/closet_maintloot/low_chance
	name = "low chance random maint loot closet"
	icon_state = "closet-black-low"
	spawn_nothing_percentage = 60

// For Scrap Beacon
/obj/random/closet_maintloot/beacon/item_to_spawn()
	return pickweight(list(
				/obj/structure/closet/random_miscellaneous = 5,
				/obj/structure/closet/random_tech = 3,
				/obj/structure/closet/random_milsupply = 1,
				/obj/structure/closet/random_medsupply = 3,
				/obj/structure/closet/random_hostilemobs/beacon = 8
			))
