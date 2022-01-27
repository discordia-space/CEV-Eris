/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't for69et a69op!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = FALSE //This is a pain, it doesnt need to block walkin69
	w_class = ITEM_SIZE_NORMAL
	rea69ent_fla69s = OPENCONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, addin69 this so syrin69es stop runtime errorin69. --NeoFite


/obj/structure/mopbucket/New()
	create_rea69ents(460)
	..()

/obj/structure/mopbucket/attackby(obj/item/I,69ob/user)
	return

/obj/structure/mopbucket/on_rea69ent_chan69e()
	overlays.Cut()
	if(rea69ents.total_volume >= 1)
		overlays |= "water_mopbucket"
