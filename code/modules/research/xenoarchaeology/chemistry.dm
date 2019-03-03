
//chemistry stuff here so that it can be easily viewed/modified

/obj/item/weapon/reagent_containers/glass/solution_tray
	name = "solution tray"
	desc = "A small, open-topped glass container for delicate research samples. It sports a re-useable strip for labelling with a pen."
	icon = 'icons/obj/device.dmi'
	icon_state = "solution_tray"
	matter = list(MATERIAL_GLASS = 1)
	w_class = ITEM_SIZE_SMALL
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 2)
	volume = 2
	base_name = "solution tray"

/obj/item/weapon/storage/box/solution_trays
	name = "solution tray box"
	icon_state = "solution_trays"

/obj/item/weapon/storage/box/solution_trays/Initialize()
	. = ..()
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)
	new /obj/item/weapon/reagent_containers/glass/solution_tray(src)

/obj/item/weapon/reagent_containers/glass/beaker/tungsten
	name = "beaker (tungsten)"
	preloaded = list("tungsten" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/oxygen
	name = "beaker (oxygen)"
	preloaded = list("oxygen" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/sodium
	name = "beaker (sodium)"
	preloaded = list("sodium" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/lithium
	name = "beaker (lithium)"
	preloaded = list("lithium" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/water
	name = "beaker (water)"
	preloaded = list("water" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/fuel
	name = "beaker (fuel)"
	preloaded = list("fuel" = 50)
