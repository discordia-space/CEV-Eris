//Stash items are typically spawned in a container which is bulky to deal with
/obj/item/weapon/storage/deferred/stash
	w_class = ITEM_SIZE_HUGE

/obj/item/weapon/storage/deferred/stash/sack
	name = "hidden stash"
	desc = "A suspiciously lumpy sack full of mystery."
	icon_state = "sack"
	item_state = "sack"
	max_w_class = ITEM_SIZE_HUGE

/obj/item/weapon/storage/deferred/stash/sack/hidden
	desc = "Now includes special aluminium hidding tech to hide from t-ray scanners"
	//only value that matters, if true will hide from t-ray scanners
	is_tray_hidden = TRUE
