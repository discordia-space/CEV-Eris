/obj/random/rotfood
	name = "random spoiled food"
	icon_state = "food-red"

/obj/random/rotfood/item_to_spawn()
	return pickweight(list(/obj/item/weapon/reagent_containers/food/snacks/chips = 3,\
				/obj/item/weapon/reagent_containers/food/snacks/candy = 3,\
				/obj/item/weapon/reagent_containers/food/snacks/unajerky = 3,\
				/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 3,\
				/obj/item/weapon/reagent_containers/food/snacks/tastybread = 3,\
				/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 3,\
				/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 3,\
				/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 2,\
				/obj/item/weapon/reagent_containers/food/snacks/hotdog = 1,\
				/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 2,\
				/obj/item/weapon/reagent_containers/food/snacks/pie = 1,\
				/obj/item/weapon/reagent_containers/food/snacks/sandwich = 1))

/obj/random/rotfood/low_chance
	name = "low chance spoiled food"
	icon_state = "food-red-low"
	spawn_nothing_percentage = 60

/obj/random/rotfood/spawn_item()
	var/obj/item/weapon/reagent_containers/food = ..()
	if(!food || !food.reagents)
		return
	if(prob(80))
		food.reagents.add_reagent("toxin", 25)
	return food
