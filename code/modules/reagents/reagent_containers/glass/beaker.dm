

//// Subtypes ////

/obj/item/weapon/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	matter = list(MATERIAL_GLASS = 2)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	matter = list(MATERIAL_GLASS = 1, MATERIAL_STEEL = 2)
	volume = 60
	amount_per_transfer_from_this = 10
	reagent_flags = OPENCONTAINER | NO_REACT

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASMA = 1)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)

/obj/item/weapon/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	matter = list(MATERIAL_GLASS = 1)
	volume = 30
	w_class = ITEM_SIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)

/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	preloaded = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric
	preloaded = list("sacid" = 60)


/obj/item/weapon/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter = list(MATERIAL_PLASTIC = 2)
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	unacidable = 0

/obj/item/weapon/reagent_containers/glass/bucket/attackby(var/obj/D, mob/user as mob)

	if(is_proximity_sensor(D))
		user << "You add [D] to [src]."
		qdel(D)
		user.put_in_hands(new /obj/item/weapon/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/weapon/mop))
		return
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/bucket/update_icon()
	overlays.Cut()
	if(reagents.total_volume >= 1)
		overlays += "water_bucket"
	if(has_lid())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

