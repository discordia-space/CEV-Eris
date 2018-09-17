/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	w_class = ITEM_SIZE_NORMAL
	flags = OPENCONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite


/obj/structure/mopbucket/New()
	create_reagents(480)
	..()

/obj/structure/mopbucket/examine(mob/user)
	if(..(user, 1))
		user << "[src] \icon[src] contains [reagents.total_volume] unit\s of water!"

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	return

/obj/structure/mopbucket/on_reagent_change()
	overlays.Cut()
	if(reagents.total_volume >= 1)
		overlays |= "water_mopbucket"
