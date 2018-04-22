/obj/random/structures
	name = "random structure"
	icon_state = "machine-black"

/obj/random/structures/item_to_spawn()
	return pick(prob(9);/obj/structure/salvageable/machine,\
				prob(9);/obj/structure/salvageable/autolathe,\
				prob(4);/obj/structure/computerframe,\
				prob(3);/obj/machinery/constructable_frame/machine_frame,\
				prob(5);/obj/structure/reagent_dispensers/fueltank,\
				prob(1);/obj/structure/reagent_dispensers/fueltank/huge,\
				prob(5);/obj/structure/reagent_dispensers/watertank,\
				prob(2);/obj/structure/largecrate,\
				prob(2);/obj/structure/ore_box,\
				prob(1);/obj/structure/dispenser/oxygen)

/obj/random/structures/low_chance
	name = "low chance random structures"
	icon_state = "machine-black-low"
	spawn_nothing_percentage = 60