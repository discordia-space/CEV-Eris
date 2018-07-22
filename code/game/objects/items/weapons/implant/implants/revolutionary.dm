/obj/item/weapon/implant/revolution
	name = "communication implant"
	implant_color = "r"
	allowed_organs = list(BP_HEAD)

	var/antag_id = null
	var/faction_id = null

/obj/item/weapon/implant/revolution/can_install(var/mob/living/carbon/human/target, var/obj/item/organ/external/E)
	if(!istype(target) || !target.mind)
		return FALSE

	return antag_id && faction_id


/obj/item/weapon/implant/revolution/on_install(var/mob/living/target)
	var/datum/faction/F = get_faction_by_id(faction_id)

	if(!wearer || !wearer.mind)
		return

	if(!F)
		target << SPAN_WARNING("You feel nothing.")

	for(var/datum/antagonist/A in target.mind.antagonist)
		if(A.id == antag_id && A.faction && A.faction.id == faction_id)
			return

	make_antagonist_faction(wearer.mind, antag_id, F)


/obj/item/weapon/implant/revolution/on_uninstall()
	if(!istype(wearer) || !wearer.mind)
		return

	for(var/datum/antagonist/A in wearer.mind.antagonist)
		if(A.id == antag_id)
			A.remove_antagonist()

	if(prob(66))
		wearer.adjustBrainLoss(200)
		part.droplimb(FALSE, DROPLIMB_BLUNT)
