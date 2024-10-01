/obj/item/reagent_containers/food/snacks/examine(mob/user, extra_description = "")
	#ifdef CWJ_DEBUG
	extra_description += SPAN_NOTICE("\nThe food's level of quality is [food_quality]") //Visual number should only be visible when debugging
	#endif
	if(cooking_description_modifier)
		extra_description += cooking_description_modifier
	extra_description += food_descriptor

	if (bitecount==0)
		extra_description += SPAN_NOTICE("\nThe [src] is unbitten.")
	else if (bitecount==1)
		extra_description += SPAN_NOTICE("\nThe [src] was bitten by someone!")
	else if (bitecount<=3)
		extra_description += SPAN_NOTICE("\nThe [src] was bitten [bitecount] time\s!")
	else
		extra_description += SPAN_NOTICE("\nThe [src] was bitten multiple times!")
	..(user, extra_description)
