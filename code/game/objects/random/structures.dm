/obj/random/structures
	name = "random structure"
	icon_state = "machine-black"

/obj/random/structures/item_to_spawn()
	return pick(prob(10);/obj/structure/salvageable/machine,\
				prob(10);/obj/structure/salvageable/autolathe,\
				prob(1);/obj/structure/salvageable/implant_container,\
				prob(5);/obj/structure/salvageable/data,\
				prob(5);/obj/structure/salvageable/server,\
				prob(5);/obj/structure/computerframe,\
				prob(4);/obj/machinery/constructable_frame/machine_frame,\
				prob(6);/obj/structure/reagent_dispensers/fueltank,\
				prob(2);/obj/structure/reagent_dispensers/fueltank/huge,\
				prob(6);/obj/structure/reagent_dispensers/watertank,\
				prob(2);/obj/structure/largecrate,\
				prob(2);/obj/structure/ore_box,\
				prob(1);/obj/structure/dispenser/oxygen)

/obj/random/structures/low_chance
	name = "low chance random structures"
	icon_state = "machine-black-low"
	spawn_nothing_percentage = 60
