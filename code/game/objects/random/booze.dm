/obj/random/booze
	name = "random booze"
	icon_state = "cannister-red"

/obj/random/booze/item_to_spawn()
	return pickweight(list(/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 7,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 2,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/patron = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 1,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine = 1))

/obj/random/booze/low_chance
	name = "low chance random booze"
	icon_state = "cannister-red-low"
	spawn_nothing_percentage = 60
