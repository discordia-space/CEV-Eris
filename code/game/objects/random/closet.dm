/obj/random/closet
	name = "random closet"
	icon_state = "closet-grey"
	alpha = 128

/obj/random/closet/item_to_spawn()
	return pick(prob(4);/obj/structure/closet,\
				prob(8);/obj/structure/closet/firecloset,\
				prob(5);/obj/structure/closet/firecloset/full,\
				prob(6);/obj/structure/closet/emcloset,\
				prob(1);/obj/structure/closet/wardrobe/black,\
				prob(1);/obj/structure/closet/wardrobe/green,\
				prob(1);/obj/structure/closet/wardrobe/orange,\
				prob(1);/obj/structure/closet/wardrobe/yellow,\
				prob(1);/obj/structure/closet/wardrobe/white,\
				prob(1);/obj/structure/closet/wardrobe/mixed,\
				prob(1);/obj/structure/closet/lasertag/red,\
				prob(1);/obj/structure/closet/lasertag/blue,\
				prob(8);/obj/structure/closet/toolcloset)

/obj/random/closet/low_chance
	name = "low chance random closet"
	icon_state = "closet-grey-low"
	spawn_nothing_percentage = 60

/obj/random/closet_tech
	name = "random technical closet"
	icon_state = "closet-orange"

/obj/random/closet_tech/item_to_spawn()
	return pick(prob(4);/obj/structure/closet/firecloset,\
				prob(3);/obj/structure/closet/firecloset/full,\
				prob(2);/obj/structure/closet/emcloset,\
				prob(4);/obj/structure/closet/toolcloset)

/obj/random/closet_tech/low_chance
	name = "low chance random technical closet"
	icon_state = "closet-orange-low"
	spawn_nothing_percentage = 60

/obj/random/closet_wardrobe
	name = "random wardrobe closet"
	icon_state = "closet-blue"

/obj/random/closet_wardrobe/item_to_spawn()
	return pick(/obj/structure/closet/wardrobe/black,\
				/obj/structure/closet/wardrobe/green,\
				/obj/structure/closet/wardrobe/orange,\
				/obj/structure/closet/wardrobe/yellow,\
				/obj/structure/closet/wardrobe/white,\
				/obj/structure/closet/wardrobe/mixed)

/obj/random/closet_wardrobe/low_chance
	name = "low chance random wardrobe closet"
	icon_state = "closet-blue-low"
	spawn_nothing_percentage = 60
