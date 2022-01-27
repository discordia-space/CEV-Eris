GLOBAL_LIST_EMPTY(active_mindboil_spiders)

/obj/item/implant/carrion_spider/mindboil
	name = "mindboil spider"
	icon_state = "spiderling_mindboil"
	spider_price = 30
	var/active = FALSE
	var/list/victims = list()
	var/datum/antag_contract/derail/contract
	var/attack_from

/obj/item/implant/carrion_spider/mindboil/activate()
	if(active)
		active = FALSE
		GLOB.active_mindboil_spiders -= src
		to_chat(owner_mob, SPAN_NOTICE("\The 69src69 is deactivated."))

	else
		active = TRUE
		GLOB.active_mindboil_spiders += src
		to_chat(owner_mob, SPAN_NOTICE("\The 69src69 is active."))
	..()


/obj/item/implant/carrion_spider/mindboil/Process()
	..()

	if(active)
		if(wearer)
			attack_from = wearer
		else
			attack_from = src
		for(var/mob/living/carbon/human/H in69iew(5, attack_from))
			if(H.get_species() != SPECIES_HUMAN || (H in69ictims) || (H == owner_mob))
				continue
			H.sanity.onPsyDamage(1) //Half the ammount of69ind fryer, can be69ass produced

		// Pick up a new contract if there is none
		if(owner_mob && !contract)
			find_contract()

/obj/item/implant/carrion_spider/mindboil/Destroy()
	GLOB.active_mindboil_spiders -= src
	. = ..()


/obj/item/implant/carrion_spider/mindboil/proc/find_contract()
	for(var/datum/antag_contract/derail/C in GLOB.various_antag_contracts)
		if(C.completed)
			continue
		contract = C
		victims = list()
		break

/obj/item/implant/carrion_spider/mindboil/proc/reg_break(mob/living/carbon/human/victim)
	if(victim.get_species() != SPECIES_HUMAN)
		return

	if(victim == owner_mob)
		return

	victims |=69ictim
	if(!(src in69iew(5,69ictim))) //Anti-cheese as these things stack,69ay be removed if it doesn't become problematic
		to_chat(victim, SPAN_DANGER("SOMETHING IS WATCHING YOU"))

	if(contract &&69ictims.len >= contract.count)
		if(owner_mob.mind)
			if(contract.completed)
				return
			contract.complete(owner_mob.mind)
			contract = null
