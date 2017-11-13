var/datum/body_build/default_body_build = new
/datum/body_build
	var/name			= "Default"
	var/gender 			= MALE
	var/identifying_gender = MALE
	var/index			= "" 					// For icon_ovveride body_build supply
	var/uniform_icon	= 'icons/inventory/uniform/mob.dmi'
	var/suit_icon		= 'icons/inventory/suit/mob.dmi'
	var/gloves_icon		= 'icons/inventory/hands/mob.dmi'
	var/glasses_icon	= 'icons/inventory/eyes/mob.dmi'
	var/ears_icon		= 'icons/inventory/ears/mob.dmi'
	var/mask_icon		= 'icons/inventory/face/mob.dmi'
	var/hat_icon		= 'icons/inventory/head/mob.dmi'
	var/shoes_icon		= 'icons/inventory/feet/mob.dmi'
	var/misk_icon		= 'icons/mob/mob.dmi'
	var/belt_icon		= 'icons/inventory/belt/mob.dmi'
	var/s_store_icon	= 'icons/inventory/on_suit/mob.dmi'
	var/backpack_icon	= 'icons/inventory/back/mob.dmi'
	var/underwear_icon	= 'icons/inventory/underwear/mob.dmi'

/datum/body_build/proc/get_mob_icon(var/slot, var/icon_state)
	var/icon/I
	for(var/build in list(src, default_body_build))
		var/datum/body_build/BB = build
		switch(slot)
			if("misk")    I = BB.misk_icon
			if("uniform") I = BB.uniform_icon
			if("suit")    I = BB.suit_icon
			if("gloves")  I = BB.gloves_icon
			if("glasses") I = BB.glasses_icon
			if("ears")    I = BB.ears_icon
			if("mask")    I = BB.mask_icon
			if("head")    I = BB.hat_icon
			if("shoes")   I = BB.shoes_icon
			if("belt")    I = BB.belt_icon
			if("s_store") I = BB.s_store_icon
			if("back")    I = BB.backpack_icon
			/*if("tie")     I = BB.ties_icon
			if("hidden")  I = BB.hidden_icon
			if("rig")     I = BB.rig_back*/
			else
				world.log << "##ERROR. Wrong sprite group for mob icon \"[slot]\""
		if(icon_state in icon_states(I))
			break

	return I

/datum/body_build/female
	gender 			= FEMALE
	uniform_icon	= 'icons/inventory/uniform/mob_fem.dmi'
	suit_icon		= 'icons/inventory/suit/mob_fem.dmi'

/datum/body_build/slim
	name			= "Slim"
	index			= "_slim"
	uniform_icon	= 'icons/inventory/uniform/mob_slim.dmi'
	suit_icon		= 'icons/inventory/suit/mob_slim.dmi'
	gloves_icon		= 'icons/inventory/hands/mob_slim.dmi'
	glasses_icon	= 'icons/inventory/eyes/mob_slim.dmi'
	ears_icon		= 'icons/inventory/ears/mob_slim.dmi'
	mask_icon		= 'icons/inventory/face/mob_slim.dmi'
	hat_icon		= 'icons/inventory/head/mob_slim.dmi'
	shoes_icon		= 'icons/inventory/feet/mob_slim.dmi'
//	misk_icon		= 'icons/inventory/mob/mob_slim.dmi'
	belt_icon		= 'icons/inventory/belt/mob_slim.dmi'
	s_store_icon	= 'icons/inventory/on_suit/mob_slim.dmi'
	backpack_icon	= 'icons/inventory/back/mob_slim.dmi'
	underwear_icon	= 'icons/inventory/underwear/mob_slim.dmi'

/datum/body_build/slim/female
	gender 			= FEMALE
	uniform_icon	= 'icons/inventory/uniform/mob_slim_fem.dmi'
	suit_icon		= 'icons/inventory/suit/mob_slim_fem.dmi'

/datum/body_build/fat
	name			= "Fat"
	index			= "_fat"
	uniform_icon	= 'icons/inventory/uniform/mob_fat.dmi'
	suit_icon		= 'icons/inventory/suit/mob_fat.dmi'
	gloves_icon		= 'icons/inventory/hands/mob_fat.dmi'
	glasses_icon	= 'icons/inventory/eyes/mob_fat.dmi'
	ears_icon		= 'icons/inventory/ears/mob_fat.dmi'
	mask_icon		= 'icons/inventory/face/mob_fat.dmi'
	hat_icon		= 'icons/inventory/head/mob_fat.dmi'
	shoes_icon		= 'icons/inventory/feet/mob_fat.dmi'
//	misk_icon		= 'icons/inventory/mob/mob_fat.dmi'
	belt_icon		= 'icons/inventory/belt/mob_fat.dmi'
	s_store_icon	= 'icons/inventory/on_suit/mob_fat.dmi'
	backpack_icon	= 'icons/inventory/back/mob_fat.dmi'
	underwear_icon	= 'icons/inventory/underwear/mob_fat.dmi'

/datum/body_build/fat/female
	gender 			= FEMALE
