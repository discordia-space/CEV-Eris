/obj/spawner/rations
	name = "random preserved rations"
	icon_state = "food-green"
	tags_to_spawn = list(SPAWN_RATIONS)

/obj/spawner/rations/low_chance
	name = "low chance preserved rations"
	icon_state = "food-green-low"
	spawn_nothing_percentage = 60


/obj/spawner/junkfood
	name = "random junkfood"
	icon_state = "food-red"
	has_postspawn = FALSE
	tags_to_spawn = list(SPAWN_JUNKFOOD)

/obj/spawner/junkfood/low_chance
	name = "low chance junkfood"
	icon_state = "food-red-low"
	spawn_nothing_percentage = 60

/obj/spawner/junkfood/rotten
	name = "random spoiled food"
	icon_state = "food-red"
	has_postspawn = TRUE

/obj/spawner/junkfood/rotten/low_chance
	name = "low chance spoiled food"
	icon_state = "food-red-low"
	spawn_nothing_percentage = 60

/obj/spawner/junkfood/rotten/post_spawn(list/spawns)
	for(var/obj/item/weapon/reagent_containers/food in spawns)
		if(!food.reagents)
			return
		if(prob(80))
			food.reagents.add_reagent("toxin", 25)
		if(prob(30)) // So sometimes the rot is visible.
			food.make_old()
	return spawns

/obj/spawner/pizza
	name = "random pizza"
	icon_state = "food-red"
	tags_to_spawn = list(SPAWN_PIZZA)

/obj/spawner/pizza/low_chance
	name = "low chance pizza"
	icon_state = "food-red-low"
	spawn_nothing_percentage = 60

/obj/spawner/soda
	name = "random soda"
	icon_state = "food-red"
	tags_to_spawn = list(SPAWN_DRINK_SODA)

/obj/spawner/soda/low_chance
	name = "low chance soda"
	icon_state = "food-red-low"
	spawn_nothing_percentage = 60
