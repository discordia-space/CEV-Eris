/obj/item/device/language_imprinter
	name = "language imprinter"
	desc = "A device that is applied to an eye to imprint the English Common language to one's mind."
	icon_state = "mental_imprinter"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_GLASS = 2)
	spawn_blacklisted = TRUE
	var/language = LANGUAGE_COMMON
	var/spent = FALSE

/obj/item/device/language_imprinter/attack(mob/M, mob/living/carbon/human/user, target_zone)
	if(!istype(user) || user.incapacitated() || spent)
		return ..()
	if(length(M.get_covering_equipped_items(EYES)))
		to_chat(user, SPAN_WARNING("You need to remove the eye covering first."))
		return ..()
	M.add_language(language)

	to_chat(user, SPAN_DANGER("[src] plunges into [M]'s eye!"))
	spent = TRUE

/obj/item/device/language_imprinter/roach
	name = "language imprinter"
	desc = "A device that is applied to an eye to imprint the roach language to one's mind through analyzing a piece of fuhrer meat "
	language = LANGUAGE_ROACH
