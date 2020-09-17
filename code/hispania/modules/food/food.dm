// COSTILLAS D-DE DE BRON-// BY Saga.
/obj/item/weapon/reagent_containers/food/snacks/brontosaurus
	name = "brontosaurus ribs"
	desc = "Some Brontosaurus ribs looking pretty strong... and delicious!"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "drake_ribs"
	filling_color = "#EC3924"
	w_class = ITEM_SIZE_HUGE

	preloaded_reagents = list("protein" = 6)

/obj/item/weapon/reagent_containers/food/snacks/brontosauruscooked
	name = "cooked brontosaurus ribs"
	desc = "No way... These ribs are looking gorgeous and god that smell!"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "cookeddrake_ribs"
	filling_color = "#EC3924"
	cooked = TRUE
	w_class = ITEM_SIZE_HUGE

	preloaded_reagents = list("protein" = 6)

//Milanesas// Por totomc
/obj/item/weapon/reagent_containers/food/snacks/raw_milanesa
	name = "Raw milanesa"
	desc = "Looks delicious, but i wouldnt recommend eating it...yet"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "raw_milanesa"
	filling_color = "#D3B266"
	cooked = FALSE
	taste_tag = list(MEAT_FOOD)

	preloaded_reagents = list("protein" = 4, "bread" = 2)

/obj/item/weapon/reagent_containers/food/snacks/milanesa
	name = "Milanesa"
	desc = "Looks delicious, eat it!"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "milanesa"
	filling_color = "#A87D1D"
	cooked = TRUE
	taste_tag = list(MEAT_FOOD)

	preloaded_reagents = list("protein" = 4, "sodiumchloride" = 1, "bread" = 2)

/obj/item/weapon/reagent_containers/food/snacks/bread_crumbs
	name = "Bread crumbs"
	desc = "Bread, but in small pieces"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "bread_crumbs"
	filling_color = "#BA953F"
	cooked = TRUE

	preloaded_reagents = list ("bread" = 2)
