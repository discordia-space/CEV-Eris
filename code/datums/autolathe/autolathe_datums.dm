/var/global/list/autolathe_recipes

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes[recipe.type] = recipe

		if(!recipe.path)
			continue

		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = round(I.matter[material]*1.25) // More expensive to produce than they are to recycle.
		if(!recipe.resources)
			recipe.resources = list()

		if(I.matter_reagents && !recipe.reagents) //This can be overidden in the datums.
			recipe.reagents = list()
			for(var/reagent in I.matter_reagents)
				recipe.reagents[reagent] = round(I.matter_reagents[reagent]*1.125) // More expensive to produce than they are to recycle.

		if(!recipe.reagents)
			recipe.reagents = list()

		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/list/reagents

/datum/autolathe/recipe/corrupted
	name = "ERROR"
