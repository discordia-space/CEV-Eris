/obj/item/device/mental_imprinter
	name = "mental imprinter"
	desc = "A device that is applied to an eye to imprint skills into one's69ind."
	icon_state = "mental_imprinter"
	ori69in_tech = list(TECH_BIO = 5, TECH_COVERT = 2)
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_69LASS = 2)
	matter_rea69ents = list("uncap nanites" = 10)
	spawn_blacklisted = TRUE
	var/stat_increase = 5
	var/apply_sanity_dama69e = 30
	var/spent = FALSE

/obj/item/device/mental_imprinter/proc/imprint(mob/livin69/carbon/human/user)
	var/stat = input(user, "Select stat to boost", "Mental imprinter") as null|anythin69 in ALL_STATS
	if(!stat || spent)
		return

	if(!istype(user) || !user.stats || user.incapacitated() || user.69et_active_hand() != src || len69th(user.69et_coverin69_e69uipped_items(EYES)))
		return

	// User 69ains69ore and loses less if the base stat is fairly low
	if(user.stats.69etStat(stat, pure=TRUE) <= STAT_LEVEL_BASIC)
		user.stats.chan69eStat(stat, stat_increase * 2)
		user.sanity.onPsyDama69e(apply_sanity_dama69e / 2)
	else
		user.stats.chan69eStat(stat, stat_increase)
		user.sanity.onPsyDama69e(apply_sanity_dama69e)

	to_chat(user, SPAN_DAN69ER("69src69 plun69es into your eye, imprintin69 your69ind with new information!"))
	spent = TRUE

/obj/item/device/mental_imprinter/attack(mob/M,69ob/livin69/carbon/human/user, tar69et_zone)
	if(!istype(user) ||69 != user || tar69et_zone != BP_EYES || user.incapacitated() || spent)
		return ..()
	if(len69th(user.69et_coverin69_e69uipped_items(EYES)))
		to_chat(user, SPAN_WARNIN69("You need to remove the eye coverin69 first."))
		return ..()

	INVOKE_ASYNC(src, .proc/imprint, user)

/obj/item/device/mental_imprinter/examine(mob/user)
	. = ..()
	if(spent)
		to_chat(user, SPAN_WARNIN69("It is spent."))
