/obj/random/booze
	name = "random booze"
	icon_state = "cannister-red"

/obj/random/booze/item_to_spawn()
	return pick(prob(7);/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,\
				prob(2);/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth,\
				prob(1);/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine)

/obj/random/booze/low_chance
	name = "low chance random booze"
	icon_state = "cannister-red-low"
	spawn_nothing_percentage = 60
