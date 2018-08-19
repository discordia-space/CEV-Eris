/obj/item/weapon/reagent_containers/food/snacks/roachmeat
	name = "roach meat"
	desc = "Gross piece of roach meat."
	icon_state = "xenomeat"
	filling_color = "#E2FFDE"
	center_of_mass = list("x"=17, "y"=13)

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("blattedin", 10)
		src.bitesize = 6