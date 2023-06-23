/obj/item/reagent_containers/food/snacks/dollop
	name = "dollop of frosting"
	desc = "A fresh serving of just frosting and nothing but frosting."
	icon = 'icons/obj/cwj_cooking/kitchen.dmi'
	icon_state = "dollop"
	bitesize = 4
	var/reagent_id = "frosting"
	preloaded_reagents = list("frosting" = 30)

/obj/item/reagent_containers/food/snacks/dollop/New(var/loc, var/new_reagent_id = "frosting", var/new_amount = 30)
	. = ..()
	if(new_reagent_id)
		var/reagent_name = get_reagent_name_by_id(reagent_id)
		if(reagent_name)
			name = "dollop of [reagent_name]"
			desc = "A fresh serving of just [reagent_name] and nothing but [reagent_name]."
		preloaded_reagents = list("[new_reagent_id]" = new_amount)

/obj/item/reagent_containers/food/snacks/dollop/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/food/snacks/dollop/update_icon()
	color=reagents.get_color()