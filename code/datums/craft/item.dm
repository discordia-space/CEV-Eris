/obj/item/craft
	icon = 'icons/obj/crafts.dmi'
	icon_state = "device"
	var/datum/craft_recipe/recipe
	var/step = 1


/obj/item/craft/New(loc, new_recipe)
	..(loc)
	recipe = new_recipe
	src.name = "Crafting [recipe.name]"
	src.icon_state = recipe.icon_state
	update()


/obj/item/craft/proc/update()
	desc = recipe.get_description(step)


/obj/item/craft/attackby(obj/item/I, mob/living/user)
	if(recipe.try_step(step+1, I, user, src)) //First step is
		++step
		if(recipe.is_compelete(step+1))
			recipe.spawn_result(src, user)
		else
			update()

