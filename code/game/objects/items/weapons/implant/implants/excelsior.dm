/obj/item/weapon/implant/excelsior
	name = "excelsior implant"
	implant_color = "r"
	allowed_organs = list(BP_HEAD)
	origin_tech = list(TECH_COVERT = 2)
	var/antag_id = ROLE_EXCELSIOR_REV
	var/faction_id = FACTION_EXCELSIOR
	var/global/possible_disguises = list(
		/obj/item/weapon/implant/chem,
		/obj/item/weapon/implant/death_alarm
	)
	var/disguise

/obj/item/weapon/implant/excelsior/Initialize()
	. = ..()
	if(length(possible_disguises))
		var/obj/item/weapon/implant/I = pick(possible_disguises)
		disguise = initial(I.name)

/obj/item/weapon/implant/excelsior/get_scanner_name()
	return disguise

/obj/item/weapon/implantcase/excelsior
	name = "glass case - 'complant'"
	desc = "A case containing an excelsior complant."
	implant = /obj/item/weapon/implant/excelsior

/obj/item/weapon/implanter/excelsior
	name = "implanter-complant"
	implant = /obj/item/weapon/implant/excelsior

/obj/item/weapon/implant/excelsior/broken
	name = "broken excelsior implant"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/weapon/implantcase/excelsior/broken
	name = "glass case - 'broken complant'"
	desc = "A case containing an broken excelsior complant."
	implant = /obj/item/weapon/implant/excelsior/broken

/obj/item/weapon/implanter/excelsior/broken
	name = "broken implanter-complant"
	implant = /obj/item/weapon/implant/excelsior/broken

//The excelsior implant converts humans into antags, but it also protects mobs from excelsior turrets and shields
/obj/item/weapon/implant/excelsior/can_install(var/mob/living/carbon/human/target, var/obj/item/organ/external/E)
	//First of all, handling of human players
	if(istype(target))
		//Human players have minds. If it doesnt have a mind, its probably a monkey
		if (target.mind)
			//We'll check if the target is already excelsior, return false if so, waste of an implant
			for(var/datum/antagonist/A in target.mind.antagonist)
				if(A.id == antag_id)
					return FALSE

	//Secondly, cruciforms.
	//This is handled seperately to account for the future possibility of non-humans having cruciforms. Like holy dogs!
	if (is_neotheology_disciple(target))
		//Cruciform blocks other implants
		return FALSE


	//Thirdly an organic check. No implanting robots
	//Any other organic creature is fine. This allows you to implant your pets so the turrets dont shoot them
	var/types = target.get_classification()
	if (!(types & CLASSIFICATION_ORGANIC))
		return FALSE

	//Lastly the implant was ejected by cruciform, if yes the implant is broken.
	if(malfunction)
		return FALSE

	//All good, return true
	return TRUE



/obj/item/weapon/implant/excelsior/on_install(var/mob/living/target)
	var/datum/faction/F = get_faction_by_id(faction_id)

	if(!wearer || !wearer.mind)
		return

	if(!F)
		to_chat(target, SPAN_WARNING("You feel nothing."))

	for(var/datum/antagonist/A in target.mind.antagonist)
		if(A.id == antag_id && A.faction && A.faction.id == faction_id)
			return

	make_antagonist_faction(wearer.mind, antag_id, F, check = FALSE)


/obj/item/weapon/implant/excelsior/on_uninstall()
	if(!istype(wearer) || !wearer.mind)
		return

	for(var/datum/antagonist/A in wearer.mind.antagonist)
		if(A.id == antag_id)
			A.remove_antagonist()

	if(prob(66))
		wearer.adjustBrainLoss(200)
		part.droplimb(FALSE, DROPLIMB_BLUNT)

//The leader version of the implant is the one given to antags spawned by the storyteller.
//It has no special gameplay properties and is not attainable in normal gameplay, it just exists to
//prevent buggy behaviour.
/obj/item/weapon/implant/excelsior/leader

//Caninstall returns true, so it wont fail when inserted into someone who was already made an antag
/obj/item/weapon/implant/excelsior/leader/can_install()
	return TRUE

//On install is short circuited, so that it doesnt spam them with double greeting
/obj/item/weapon/implant/excelsior/leader/on_install()
	return TRUE