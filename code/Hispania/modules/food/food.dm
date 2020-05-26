// COSTILLAS D-DE DE BRON-// BY Saga.
/obj/item/weapon/reagent_containers/food/snacks/brontosaurus
	name = "brontosaurus ribs"
	desc = "Some Brontosaurus ribs looking pretty strong... and delicious!"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "drake_ribs"
	filling_color = "#EC3924"
	cooked = FALSE
	bitesize = 5
	w_class = ITEM_SIZE_HUGE
	sanity_gain = 0.5

	preloaded_reagents = list("protein" = 6)

/obj/item/weapon/reagent_containers/food/snacks/brontosauruscooked
	name = "cooked brontosaurus ribs"
	desc = "No way... These ribs are looking gorgeous and god that smell!"
	icon = 'icons/hispania/obj/food/food.dmi'
	icon_state = "cookeddrake_ribs"
	filling_color = "#EC3924"
	bitesize = 5
	cooked = TRUE
	w_class = ITEM_SIZE_HUGE
	sanity_gain = 0.5

	preloaded_reagents = list("protein" = 6)
