/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = FALSE //This is a pain, it doesnt need to block walking
	w_class = ITEM_SIZE_NORMAL
	reagent_flags = OPENCONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite


/obj/structure/mopbucket/New()
	create_reagents(460)
	..()

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	return

/obj/structure/mopbucket/on_reagent_change()
	overlays.Cut()
	if(reagents.total_volume >= 1)
		overlays |= "water_mopbucket"
