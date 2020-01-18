/obj/random/structures
	name = "random structure"
	icon_state = "machine-black"

/obj/random/structures/item_to_spawn()
	return pickweight(list(/obj/structure/salvageable/machine = 10,\
				/obj/structure/salvageable/autolathe = 10,\
				/obj/structure/salvageable/implant_container = 3,\
				/obj/structure/salvageable/data = 6,\
				/obj/structure/salvageable/server = 6,\
				/obj/structure/computerframe = 5,\
				/obj/machinery/constructable_frame/machine_frame = 4,\
				/obj/structure/reagent_dispensers/fueltank = 6,\
				/obj/structure/reagent_dispensers/fueltank/huge = 2,\
				/obj/structure/reagent_dispensers/watertank = 6,\
				/obj/structure/largecrate = 2,\
				/obj/structure/ore_box = 2,\
				/obj/structure/reagent_dispensers/bidon = 4 ,\
				/obj/structure/reagent_dispensers/bidon/advanced = 1 ,\
				/obj/structure/dispenser/oxygen = 1))

/obj/random/structures/low_chance
	name = "low chance random structures"
	icon_state = "machine-black-low"
	spawn_nothing_percentage = 60
