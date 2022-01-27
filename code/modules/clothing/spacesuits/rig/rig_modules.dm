/obj/item/rig/proc/can_install(var/obj/item/rig_module/mod,69ar/mob/user,69ar/feedback = FALSE)
	if(is_worn())
		if (user && feedback)
			to_chat(user, SPAN_DANGER("You can't install a hardsuit69odule while the suit is being worn."))
		return FALSE

	if(installed_modules.len)
		for(var/obj/item/rig_module/installed_mod in installed_modules)
			if(!installed_mod.redundant && istype(installed_mod,mod.type))
				if (user && feedback)
					to_chat(user, "The hardsuit already has a69odule of that class installed.")
				return FALSE

	if (!mod.can_install(src, user, feedback))
		return FALSE

	return TRUE

/obj/item/rig/proc/can_uninstall(var/obj/item/rig_module/mod,69ar/mob/user,69ar/feedback = FALSE)
	if (!mod.can_uninstall(src, user, feedback))
		return FALSE

	return TRUE

/obj/item/rig/proc/install(var/obj/item/rig_module/mod,69ar/mob/user)

	if (user)
		to_chat(user, "You begin installing \the 69mod69 into \the 69src69.")
		if(!do_after(user,40,src))
			return FALSE
		if(!user || !mod)
			return FALSE
		if(mod.loc == user && !user.unEquip(mod))
			return FALSE
		to_chat(user, "You install \the 69mod69 into \the 69src69.")
	installed_modules |=69od
	mod.holder = src
	mod.forceMove(src)
	mod.installed(user)
	update_icon()
	return TRUE


//Cleanly uninstalls the rig69odule to prevent runtime/GC errors
/obj/item/rig/proc/uninstall(var/obj/item/rig_module/mod,69ar/mob/living/user,69ar/delete = FALSE)
	mod.deactivate()

	//Remove ourselves from the host's installed69odules
	installed_modules -=69od
	if (selected_module ==69od)
		selected_module = null

	if (visor ==69od)
		visor = null

	if (speech ==69od)
		speech = null

	mod.holder = null

	if (user)
		to_chat(user, "You detatch \the 69mod69 from \the 69src69.")

	mod.uninstalled(src, user)
	if (delete)
		//The69odule is about to be deleted
		//We're running uninstall to69ake sure it cleans up after it
		//That is done now, so we return
		return TRUE

	//If we get here, the69odule is going to be ejected and continue existing outside of this suit

	//If a69ob is doing this, we'll try to put it in their hands
	if (user)
		user.put_in_hands(mod)
		return

	else
		mod.forceMove(loc)
		return