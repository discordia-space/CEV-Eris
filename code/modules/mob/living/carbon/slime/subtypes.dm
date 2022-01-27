/mob/living/carbon/slime/proc/mutation_table(var/colour)
	var/list/slime_mutation69469
	switch(colour)
		//Tier 1
		if("grey")
			slime_mutation69169 = "orange"
			slime_mutation69269 = "metal"
			slime_mutation69369 = "blue"
			slime_mutation69469 = "purple"
		//Tier 2
		if("purple")
			slime_mutation69169 = "dark purple"
			slime_mutation69269 = "dark blue"
			slime_mutation69369 = "green"
			slime_mutation69469 = "green"
		if("metal")
			slime_mutation69169 =69ATERIAL_SILVER
			slime_mutation69269 = "yellow"
			slime_mutation69369 =69ATERIAL_GOLD
			slime_mutation69469 =69ATERIAL_GOLD
		if("orange")
			slime_mutation69169 = "dark purple"
			slime_mutation69269 = "yellow"
			slime_mutation69369 = "red"
			slime_mutation69469 = "red"
		if("blue")
			slime_mutation69169 = "dark blue"
			slime_mutation69269 =69ATERIAL_SILVER
			slime_mutation69369 = "pink"
			slime_mutation69469 = "pink"
		//Tier 3
		if("dark blue")
			slime_mutation69169 = "purple"
			slime_mutation69269 = "purple"
			slime_mutation69369 = "blue"
			slime_mutation69469 = "blue"
		if("dark purple")
			slime_mutation69169 = "purple"
			slime_mutation69269 = "purple"
			slime_mutation69369 = "orange"
			slime_mutation69469 = "orange"
		if("yellow")
			slime_mutation69169 = "metal"
			slime_mutation69269 = "metal"
			slime_mutation69369 = "orange"
			slime_mutation69469 = "orange"
		if(MATERIAL_SILVER)
			slime_mutation69169 = "metal"
			slime_mutation69269 = "metal"
			slime_mutation69369 = "blue"
			slime_mutation69469 = "blue"
		//Tier 4
		if("pink")
			slime_mutation69169 = "pink"
			slime_mutation69269 = "pink"
			slime_mutation69369 = "light pink"
			slime_mutation69469 = "light pink"
		if("red")
			slime_mutation69169 = "red"
			slime_mutation69269 = "red"
			slime_mutation69369 = "oil"
			slime_mutation69469 = "oil"
		if(MATERIAL_GOLD)
			slime_mutation69169 =69ATERIAL_GOLD
			slime_mutation69269 =69ATERIAL_GOLD
			slime_mutation69369 = "adamantine"
			slime_mutation69469 = "adamantine"
		if("green")
			slime_mutation69169 = "green"
			slime_mutation69269 = "green"
			slime_mutation69369 = "black"
			slime_mutation69469 = "black"
		// Tier 5
		else
			slime_mutation69169 = colour
			slime_mutation69269 = colour
			slime_mutation69369 = colour
			slime_mutation69469 = colour
	return(slime_mutation)