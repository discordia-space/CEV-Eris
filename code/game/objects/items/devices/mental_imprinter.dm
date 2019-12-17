/obj/item/device/mental_imprinter
	name = "mental imprinter"
	desc = "A device that is applied to an eye to imprint skills into one's mind."
	icon_state = "mental_imprinter"
	origin_tech = list(TECH_BIO = 5, TECH_ILLEGAL = 2)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASMA = 4, MATERIAL_BIOMASS = 6)
	var/spent = FALSE

/obj/item/device/mental_imprinter/proc/imprint(mob/living/carbon/human/user)
	var/stat = input(user, "Select stat to boost", "Mental imprinter") as null|anything in ALL_STATS
	if(!stat || user.incapacitated() || spent || user.get_active_hand() != src || user.get_covering_equipped_items(EYES).len)
		return

	user.sanity.onPsyDamage(30)
	user.stats.changeStat(stat, 5)

	to_chat(user, SPAN_DANGER("[src] plunges into your eye, imprinting your mind with new information!"))
	spent = TRUE

/obj/item/device/mental_imprinter/attack(mob/M, mob/living/carbon/human/user, target_zone)
	if(!istype(user) || M != user || target_zone != BP_EYES || user.incapacitated() || spent)
		return ..()
	if(user.get_covering_equipped_items(EYES).len)
		to_chat(user, SPAN_WARNING("You need to remove the eye covering first."))
		return ..()

	INVOKE_ASYNC(src, .proc/imprint, user)

/obj/item/device/mental_imprinter/examine(mob/user)
	. = ..()
	if(spent)
		to_chat(user, SPAN_WARNING("It is spent."))
