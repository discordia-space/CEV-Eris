/var/global/list/autolathe_recipes

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes[recipe.type] = recipe

		if(!recipe.path)
			continue

		recipe.time = 0
		var/obj/item/I = new recipe.path
		if(I.matter && I.matter.len && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()

			for(var/obj/O in I.GetAllContents(includeSelf = TRUE)) // we also count any additional matter that comes with item itself, like battery inside a flashlight
				if(!O.matter || !O.matter.len)
					continue

				var/obj/item/stack/material/stack
				if(istype(O, /obj/item/stack))
					stack = O

				for(var/material in O.matter)
					if(stack) // "if" instead of "?" for readability
						recipe.resources[material] += stack.matter[material] * stack.get_amount()
					else
						recipe.resources[material] += O.matter[material]

					recipe.time += recipe.resources[material]*2

		if(!recipe.resources)
			recipe.resources = list()
		else
			for(var/material in recipe.resources)
				recipe.resources[material] = round(recipe.resources[material] * 1.25, 1) // More expensive to produce than they are to recycle.

		if(I.matter_reagents && !recipe.reagents) //This can be overidden in the datums.
			recipe.reagents = list()
			for(var/reagent in I.matter_reagents)
				recipe.reagents[reagent] = round(I.matter_reagents[reagent]*1.125) // More expensive to produce than they are to recycle.

		if(!recipe.reagents)
			recipe.reagents = list()

		recipe.time = max(recipe.time,15)
		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/list/reagents
	var/time = 100

/datum/autolathe/recipe/corrupted
	name = "ERROR"
