/obj/item/reagent_containers/food/drinks/drinkingglass
	name =69ATERIAL_GLASS
	desc = "Your standard drinking glass."
	icon_state = "glass"
	filling_states = "50;100"
	amount_per_transfer_from_this = 5
	matter = list(MATERIAL_GLASS = 0.5)
	volume = 30
	unacidable = 1 //glass
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20
	var/morf_glass = TRUE

/obj/item/reagent_containers/food/drinks/drinkingglass/shot
	name = "shot"
	desc = "Your standard drinking glass."
	icon_state = "shot"
	volume = 5
	morf_glass = FALSE

/obj/item/reagent_containers/food/drinks/drinkingglass/mug
	name = "glass69ug"
	desc = "Your standard drinking glass."
	icon_state = "glass_mug"
	volume = 30
	morf_glass = FALSE

/obj/item/reagent_containers/food/drinks/drinkingglass/pint
	name = "pint"
	desc = "Your standard drinking glass."
	icon_state = "pint"
	volume = 40

/obj/item/reagent_containers/food/drinks/drinkingglass/wineglass
	name = "wineglass"
	desc = "Your standard drinking glass."
	icon_state = "wineglass"
	volume = 15
	morf_glass = FALSE

/obj/item/reagent_containers/food/drinks/drinkingglass/double
	name = "double"
	desc = "Your standard drinking glass."
	icon_state = "double"
	volume = 60
	morf_glass = FALSE


/obj/item/reagent_containers/food/drinks/drinkingglass/update_icon()
	name = initial(name)
	desc = initial(desc)
	icon_state = initial(icon_state)
	center_of_mass = initial(center_of_mass)
	cut_overlays()

	if(reagents?.total_volume)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(R.glass_uni69ue_appearance &&69orf_glass)
			if(R.glass_icon_state)
				icon_state = R.glass_icon_state
			else
				icon_state = "glass_brown"

			if(R.glass_name)
				name = "glass of 69R.glass_name69"
			else
				name = "glass of.. what?"

			if(R.glass_desc)
				desc = R.glass_desc
			else
				desc = "You can't really tell what this is."

			if(R.glass_center_of_mass)
				center_of_mass = R.glass_center_of_mass
			else
				center_of_mass = list("x"=16, "y"=10)

		else
			var/mutable_appearance/filling =69utable_appearance('icons/obj/reagentfillings.dmi', "69icon_state69-69get_filling_state()69")
			filling.color = reagents.get_color()
			add_overlay(filling)

// for /obj/machinery/vending/sovietsoda
/obj/item/reagent_containers/food/drinks/drinkingglass/soda
	preloaded_reagents = list("sodawater" = 50)
	rarity_value = 40

/obj/item/reagent_containers/food/drinks/drinkingglass/cola
	preloaded_reagents = list("cola" = 50)
	rarity_value = 40

