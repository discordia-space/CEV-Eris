/obj/item/reagent_containers/food/snacks/examine(mob/user)
	if(!..(user, get_dist(user, src)))
		return

	if(cooking_description_modifier)
		to_chat(user, SPAN_NOTICE(cooking_description_modifier))

	#ifdef CWJ_DEBUG
	to_chat(user, SPAN_NOTICE("The food's level of quality is [food_quality]")) //Visual number should only be visible when debugging
	#endif

	var/food_descriptor
	if(food_quality < -9)
		food_tier = CWJ_QUALITY_GARBAGE
		food_descriptor = "It looks gross. Someone cooked this poorly."
	else if (food_quality >= 100)
		food_tier = CWJ_QUALITY_ELDRITCH
		food_descriptor = "What cruel twist of fate it must be, for this unparalleled artistic masterpiece can only be truly appreciated through its destruction. Does this dish's transient form belie the true nature of all things? You see the totality of existence reflected through \the [src]."
	else
		switch(food_quality)
			if(-9 to 0)
				food_tier = CWJ_QUALITY_GROSS
				food_descriptor = "It looks like an unappetizing a meal."
			if(1 to 10)
				food_tier = CWJ_QUALITY_MEH
				food_descriptor = "The food is edible, but frozen dinners have been reheated with more skill."
			if(11 to 20)
				food_tier = CWJ_QUALITY_NORMAL
				food_descriptor = "It looks adequately made."
			if(21 to 30)
				food_tier = CWJ_QUALITY_GOOD
				food_descriptor = "The quality of the food is is pretty good."
			if(31 to 50)
				food_tier = CWJ_QUALITY_VERY_GOOD
				food_descriptor = "This food looks very tasty."
			if(61 to 70)
				food_tier = CWJ_QUALITY_CUISINE
				food_descriptor = "There's a special spark in this cooking, a measure of love and care unseen by the casual chef."
			if(81 to 99)
				food_tier = CWJ_QUALITY_LEGENDARY
				food_descriptor = "The quality of this food is legendary. Words fail to describe it further. It must be eaten"
	to_chat(user, SPAN_NOTICE(food_descriptor))



	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(user, SPAN_NOTICE("\The [src] was bitten by someone!"))
	else if (bitecount<=3)
		to_chat(user, SPAN_NOTICE("\The [src] was bitten [bitecount] time\s!"))
	else
		to_chat(user, SPAN_NOTICE("\The [src] was bitten multiple times!"))
