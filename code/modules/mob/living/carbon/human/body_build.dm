/datum/body_build
	var/name			= "Default"
	var/gender 			= MALE
	var/identifying_gender = MALE
	var/index			= "" 					// For icon_ovveride body_build supply
	var/uniform_icon	= 'icons/mob/uniform.dmi'
	var/suit_icon		= 'icons/mob/suit.dmi'
	var/gloves_icon		= 'icons/mob/hands.dmi'
	var/glasses_icon	= 'icons/mob/eyes.dmi'
	var/ears_icon		= 'icons/mob/ears.dmi'
	var/mask_icon		= 'icons/mob/mask.dmi'
	var/hat_icon		= 'icons/mob/head.dmi'
	var/shoes_icon		= 'icons/mob/feet.dmi'
	var/misk_icon		= 'icons/mob/mob.dmi'
	var/belt_icon		= 'icons/mob/belt.dmi'
	var/s_store_icon	= 'icons/mob/belt_mirror.dmi'
	var/backpack_icon	= 'icons/mob/back.dmi'
	var/underwear_icon	= 'icons/mob/underwear.dmi'

/datum/body_build/female
	gender 			= FEMALE
	uniform_icon	= 'icons/mob/uniform_f.dmi'
	suit_icon		= 'icons/mob/suit_f.dmi'

/datum/body_build/slim
	name			= "Slim"
	index			= "_slim"
	uniform_icon	= 'icons/mob/uniform_slim.dmi'
	suit_icon		= 'icons/mob/suit_slim.dmi'
	gloves_icon		= 'icons/mob/hands_slim.dmi'
	glasses_icon	= 'icons/mob/eyes_slim.dmi'
	ears_icon		= 'icons/mob/ears_slim.dmi'
	mask_icon		= 'icons/mob/mask_slim.dmi'
	hat_icon		= 'icons/mob/head_slim.dmi'
	shoes_icon		= 'icons/mob/feet_slim.dmi'
//	misk_icon		= 'icons/mob/mob_slim.dmi'
	belt_icon		= 'icons/mob/belt_slim.dmi'
	s_store_icon	= 'icons/mob/belt_mirror_slim.dmi'
	backpack_icon	= 'icons/mob/back_slim.dmi'
	underwear_icon	= 'icons/mob/underwear_slim.dmi'

/datum/body_build/slim/female
	gender 			= FEMALE
	uniform_icon	= 'icons/mob/uniform_slim_f.dmi'
	suit_icon		= 'icons/mob/suit_slim_f.dmi'

/datum/body_build/fat
	name			= "Fat"
	index			= "_fat"
	uniform_icon	= 'icons/mob/uniform_fat.dmi'
	suit_icon		= 'icons/mob/suit_fat.dmi'
	gloves_icon		= 'icons/mob/hands_fat.dmi'
	glasses_icon	= 'icons/mob/eyes_fat.dmi'
	ears_icon		= 'icons/mob/ears_fat.dmi'
	mask_icon		= 'icons/mob/mask_fat.dmi'
	hat_icon		= 'icons/mob/head_fat.dmi'
	shoes_icon		= 'icons/mob/feet_fat.dmi'
//	misk_icon		= 'icons/mob/mob_fat.dmi'
	belt_icon		= 'icons/mob/belt_fat.dmi'
	s_store_icon	= 'icons/mob/belt_mirror_fat.dmi'
	backpack_icon	= 'icons/mob/back_fat.dmi'
	underwear_icon	= 'icons/mob/underwear_fat.dmi'

/datum/body_build/fat/female
	gender 			= FEMALE
