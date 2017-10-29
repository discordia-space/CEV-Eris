
/*
 * Lunchbox
 */

/obj/item/weapon/storage/lunchbox
	name = "heart lunchbox"
	desc = "With love."
	icon_state = "lunchbox_heart"
	item_state = "lunchbox_heart"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 8
	attack_verb = "lunched"

	can_hold = list(
		/obj/item/weapon/reagent_containers/food
		)

/obj/item/weapon/storage/lunchbox/rainbow
	name = "rainbow lunchbox"
	desc = "Rainbow bow."
	icon_state = "lunchbox_rainbow"
	item_state = "lunchbox_rainbow"

/obj/item/weapon/storage/lunchbox/cat
	name = "cat luncbox"
	desc = "Meowbox."
	icon_state = "lunchbox_cat"
	item_state = "lunchbox_cat"