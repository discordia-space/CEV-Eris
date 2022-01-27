/obj/machinery/seed_extractor
	name = "seed extractor"
	desc = "Extracts and ba69s seeds from produce."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "sextractor"
	density = TRUE
	anchored = TRUE

obj/machinery/seed_extractor/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)

	// Fruits and69e69etables.
	if(istype(O, /obj/item/rea69ent_containers/food/snacks/69rown) || istype(O, /obj/item/69rown))

		user.remove_from_mob(O)

		var/datum/seed/new_seed_type
		if(istype(O, /obj/item/69rown))
			var/obj/item/69rown/F = O
			new_seed_type = plant_controller.seeds69F.plantname69
		else
			var/obj/item/rea69ent_containers/food/snacks/69rown/F = O
			new_seed_type = plant_controller.seeds69F.plantname69

		if(new_seed_type)
			to_chat(user, SPAN_NOTICE("You extract some seeds from 69O69."))
			var/produce = rand(1,4)
			for(var/i = 0;i<=produce;i++)
				var/obj/item/seeds/seeds = new(69et_turf(src))
				seeds.seed_type = new_seed_type.name
				seeds.update_seed()
		else
			to_chat(user, "69O69 doesn't seem to have any usable seeds inside it.")

		69del(O)

	//69rass.
	else if(istype(O, /obj/item/stack/tile/69rass))
		var/obj/item/stack/tile/69rass/S = O
		if (S.use(1))
			to_chat(user, SPAN_NOTICE("You extract some seeds from the 69rass tile."))
			new /obj/item/seeds/69rassseed(loc)

	return