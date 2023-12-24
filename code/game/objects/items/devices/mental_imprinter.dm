/obj/item/device/mental_imprinter
	name = "mental imprinter"
	desc = "A device that is applied to an eye to imprint skills into one's mind."
	icon_state = "mental_imprinter"
	origin_tech = list(TECH_BIO = 5, TECH_COVERT = 2)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_GLASS = 2)
	matter_reagents = list("uncap nanites" = 10)
	spawn_blacklisted = TRUE
	var/stat_increase = 5
	var/apply_sanity_damage = 30
	var/spent = FALSE

/obj/item/device/mental_imprinter/proc/imprint(mob/living/carbon/human/user)
	var/stat = input(user, "Select stat to boost", "Mental imprinter") as null|anything in ALL_STATS
	if(!stat || spent)
		return

	if(!istype(user) || !user.stats || user.incapacitated() || user.get_active_hand() != src || length(user.get_covering_equipped_items(EYES)))
		return

	// User gains more and loses less if the base stat is fairly low
	if(user.stats.getStat(stat, pure=TRUE) <= STAT_LEVEL_BASIC)
		user.stats.changeStat(stat, stat_increase * 2)
		user.sanity.onPsyDamage(apply_sanity_damage / 2)
	else
		user.stats.changeStat(stat, stat_increase)
		user.sanity.onPsyDamage(apply_sanity_damage)

	to_chat(user, SPAN_DANGER("[src] plunges into your eye, imprinting your mind with new information!"))
	spent = TRUE

/obj/item/device/mental_imprinter/attack(mob/M, mob/living/carbon/human/user, target_zone)
	if(!istype(user) || M != user || target_zone != BP_EYES || user.incapacitated() || spent)
		return ..()
	if(length(user.get_covering_equipped_items(EYES)))
		to_chat(user, SPAN_WARNING("You need to remove the eye covering first."))
		return ..()

	INVOKE_ASYNC(src, PROC_REF(imprint), user)

/obj/item/device/mental_imprinter/examine(mob/user)
	. = ..(user, afterDesc = spent ? SPAN_WARNING("It is spent") : "")
