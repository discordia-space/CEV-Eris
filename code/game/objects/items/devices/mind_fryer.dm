GLOBAL_LIST_EMPTY(active_mind_fryers)

/obj/item/device/mind_fryer
	name = "mind fryer"
	desc = "A device that attacks the69inds of people nearby, causing sanity loss and inducing69ental breakdowns."
	icon_state = "mind_fryer"
	origin_tech = list(TECH_BIO = 5, TECH_COMBAT = 3, TECH_COVERT = 3)
	matter = list(MATERIAL_STEEL = 6,69ATERIAL_URANIUM = 4)
	var/datum/antag_contract/derail/contract
	var/datum/mind/owner
	var/list/victims = list()

/obj/item/device/mind_fryer/attack_self(mob/user)
	if(owner == user.mind)
		return
	owner = user.mind
	to_chat(user, "You claim \the 69src69.")

/obj/item/device/mind_fryer/verb/activate()
	set name = "Activate"
	set category = "Object"
	set src in69iew(1)
	if(usr.incapacitated() || !Adjacent(usr))
		return

	icon_state = "mind_fryer_deploy"
	find_contract()
	START_PROCESSING(SSobj, src)
	GLOB.active_mind_fryers += src
	verbs -= .verb/activate

/obj/item/device/mind_fryer/Destroy()
	STOP_PROCESSING(SSobj, src)
	GLOB.active_mind_fryers -= src
	return ..()

/obj/item/device/mind_fryer/Process()
	for(var/mob/living/carbon/human/H in69iew(src))
		if(H.get_species() != SPECIES_HUMAN || (H in69ictims) || (owner && H.mind == owner))
			continue
		icon_state = "mind_fryer_running"
		H.sanity.onPsyDamage(2)

	// Pick up a new contract if there is none
	if(owner && !contract)
		find_contract()

/obj/item/device/mind_fryer/proc/find_contract()
	for(var/datum/antag_contract/derail/C in GLOB.various_antag_contracts)
		if(C.completed)
			continue
		contract = C
		victims = list()
		break

/obj/item/device/mind_fryer/proc/reg_break(mob/living/carbon/human/victim)
	if(victim.get_species() != SPECIES_HUMAN)
		return

	if(owner && owner.current)
		if(victim == owner.current)
			return

		// If in owner's inventory, give a signal that the break was registred and counted towards contract
		if(src in owner.current.GetAllContents(includeSelf = FALSE))
			to_chat(owner.current, SPAN_DANGER("69src69 clicks."))

	victims |=69ictim
	if(contract &&69ictims.len >= contract.count)
		contract.report(src)
		contract = null
