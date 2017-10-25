/obj/random/rotfood
	name = "random spoiled food"
	icon_state = "food-red"

/obj/random/rotfood/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/reagent_containers/food/snacks/chips,\
				prob(3);/obj/item/weapon/reagent_containers/food/snacks/candy,\
				prob(3);/obj/item/weapon/reagent_containers/food/snacks/unajerky,\
				prob(3);/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,\
				prob(3);/obj/item/weapon/reagent_containers/food/snacks/tastybread,\
				prob(3);/obj/item/weapon/reagent_containers/food/snacks/no_raisin,\
				prob(3);/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,\
				prob(2);/obj/item/weapon/reagent_containers/food/drinks/dry_ramen,\
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/hotdog,\
				prob(2);/obj/item/weapon/reagent_containers/food/snacks/liquidfood,\
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/pie,\
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/sandwich)

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
