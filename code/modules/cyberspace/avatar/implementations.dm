#define CYBERAVATAR_INITIALIZATION(typeOfAtom, DefaultColor) ##typeOfAtom/CyberAvatar = DefaultColor
	#define CYBERAVATAR_CUSTOM_TYPE(typeOfAtom, avatarType) ##typeOfAtom/CyberAvatar_inittype = ##avatarType

//CYBERAVATAR_INITIALIZATION(/obj/item, CYBERSPACE_SHADOW_COLOR)
CYBERAVATAR_INITIALIZATION(/obj/machinery, CYBERSPACE_MAIN_COLOR)
/*	*/CYBERAVATAR_CUSTOM_TYPE(/obj/machinery, /datum/CyberSpaceAvatar/interactable)
/*	*/CYBERAVATAR_INITIALIZATION(/obj/machinery/power/apc, CYBERSPACE_SECURITY)
/*		*///CYBERAVATAR_CUSTOM_TYPE(/obj/machinery/power/apc, /datum/CyberSpaceAvatar/ice/AreaFirewall)
/*	*/CYBERAVATAR_INITIALIZATION(/obj/machinery/atmospherics, null)
CYBERAVATAR_INITIALIZATION(/obj/item/modular_computer, CYBERSPACE_MAIN_COLOR)
CYBERAVATAR_INITIALIZATION(/mob/living/carbon/superior_animal/roach/bluespace, CYBERSPACE_BLUESPACE)
CYBERAVATAR_INITIALIZATION(/mob/living/carbon/superior_animal/roach/nanite, CYBERSPACE_MAIN_COLOR)
CYBERAVATAR_INITIALIZATION(/obj/structure/cyberplant, CYBERSPACE_MAIN_COLOR)
