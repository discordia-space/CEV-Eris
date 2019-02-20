/obj/random/closet
	name = "random closet"
	icon_state = "closet-grey"
	alpha = 128
	has_postspawn = TRUE

//Closets in maint may be old
/obj/random/closet/post_spawn(var/list/things)
	for (var/atom/thing in things)
		if (thing.in_maintenance() && prob(40))
			thing.make_old()

/obj/random/closet/item_to_spawn()
	return pickweight(list(/obj/structure/closet = 4,
				/obj/structure/closet/firecloset = 8,
				/obj/structure/closet/emcloset = 6,
				/obj/structure/closet/wardrobe/black = 1,
				/obj/structure/closet/wardrobe/green = 1,
				/obj/structure/closet/wardrobe/orange = 1,
				/obj/structure/closet/wardrobe/yellow = 1,
				/obj/structure/closet/wardrobe/white = 1,
				/obj/structure/closet/wardrobe/mixed = 1,
				/obj/structure/closet/lasertag/red = 1,
				/obj/structure/closet/lasertag/blue = 1,
				/obj/structure/closet/toolcloset = 8,
				/obj/structure/closet/gimmick/russian = 0.5,
				/obj/structure/closet/gimmick/tacticool = 0.1,
				/obj/structure/closet/thunderdome/tdred = 0.4,
				/obj/structure/closet/thunderdome/tdgreen = 0.4,
				/obj/structure/closet/jcloset = 1,
				/obj/structure/closet/malf/suits =  0.5,
				/obj/structure/closet/syndicate/personal = 0.1,
				/obj/structure/closet/bombcloset = 0.5,
				/obj/structure/closet/bombclosetsecurity = 0.4))

//Fancy closets containing interesting or gimmicky things
/obj/random/closet/rare/item_to_spawn()
	return pickweight(list(/obj/structure/closet/toolcloset = 1,
				/obj/structure/closet/gimmick/russian = 0.5,
				/obj/structure/closet/gimmick/tacticool = 0.1,
				/obj/structure/closet/thunderdome/tdred = 0.4,
				/obj/structure/closet/thunderdome/tdgreen = 0.4,
				/obj/structure/closet/jcloset = 1,
				/obj/structure/closet/malf/suits =  0.5,
				/obj/structure/closet/syndicate/personal = 0.1,
				/obj/structure/closet/bombcloset = 0.5,
				/obj/structure/closet/bombclosetsecurity = 0.4))

/obj/random/closet/low_chance
	name = "low chance random closet"
	icon_state = "closet-grey-low"
	spawn_nothing_percentage = 60

/obj/random/closet_tech
	name = "random technical closet"
	icon_state = "closet-orange"
	has_postspawn = TRUE

//Closets in maint may be old
/obj/random/closet_tech/post_spawn(var/list/things)
	for (var/atom/thing in things)
		if (thing.in_maintenance() && prob(40))
			thing.make_old()

/obj/random/closet_tech/item_to_spawn()
	return pickweight(list(/obj/structure/closet/firecloset = 4,
				/obj/structure/closet/emcloset = 2,
				/obj/structure/closet/toolcloset = 4))

/obj/random/closet_tech/low_chance
	name = "low chance random technical closet"
	icon_state = "closet-orange-low"
	spawn_nothing_percentage = 60

/obj/random/closet_wardrobe
	name = "random wardrobe closet"
	icon_state = "closet-blue"
	has_postspawn = TRUE

//Closets in maint may be old
/obj/random/closet_wardrobe/post_spawn(var/list/things)
	for (var/atom/thing in things)
		if (thing.in_maintenance() && prob(40))
			thing.make_old()

/obj/random/closet_wardrobe/item_to_spawn()
	return pick(/obj/structure/closet/wardrobe/black,
				/obj/structure/closet/wardrobe/green,
				/obj/structure/closet/wardrobe/orange,
				/obj/structure/closet/wardrobe/yellow,
				/obj/structure/closet/wardrobe/white,
				/obj/structure/closet/wardrobe/mixed)

/obj/random/closet_wardrobe/low_chance
	name = "low chance random wardrobe closet"
	icon_state = "closet-blue-low"
	spawn_nothing_percentage = 60
