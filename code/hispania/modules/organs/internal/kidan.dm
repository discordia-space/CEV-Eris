/obj/item/organ/internal/liver/kidan
	name = "kidan liver"
	icon = 'icons/obj/species/organs/kidan.dmi'
	alcohol_mod_damage = 0.5

/obj/item/organ/internal/eyes/kidan
	name = "kidan eyeballs"
	icon_state = "kidan_eyes"
	icon = 'icons/obj/species/organs/kidan.dmi'

/obj/item/organ/internal/eyes/kidan/get_icon()
	var/icon/eyes_icon = new/icon('icons/mob/human_face.dmi', "kidan_eye_l")
	eyes_icon.Blend(icon('icons/mob/human_face.dmi', "kidan_eye_r"), ICON_OVERLAY)
	eyes_icon.Blend(BP_IS_ROBOTIC(src) ? robo_color : eyes_color, ICON_ADD)
	return eyes_icon

//Subtypes
/obj/item/organ/internal/eyes/kidan/oneeye
	icon_state = "kidan_eye_l"
	cache_key = "left_eye"

/obj/item/organ/internal/eyes/kidan/oneeye/get_icon()
	var/icon/eyes_icon
	eyes_icon = icon('icons/mob/human_face.dmi', "[icon_state]")
	eyes_icon.Blend(BP_IS_ROBOTIC(src) ? robo_color : eyes_color, ICON_ADD)
	return eyes_icon

/obj/item/organ/internal/eyes/kidan/oneeye/right
	icon_state = "kidan_eye_r"
	cache_key = "right_eye"

/obj/item/organ/internal/heart/kidan
	name = "kidan heart"
	icon = 'icons/obj/species/organs/kidan.dmi'

/obj/item/organ/internal/brain/kidan
	icon = 'icons/obj/species/organs/kidan.dmi'
	icon_state = "brain2"

/obj/item/organ/internal/lungs/kidan
	name = "kidan lungs"
	icon = 'icons/obj/species/organs/kidan.dmi'

/obj/item/organ/internal/kidneys/kidan
	name = "kidan kidneys"
	icon = 'icons/obj/species/organs/kidan.dmi'
