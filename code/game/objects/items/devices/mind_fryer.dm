/obj/item/device/mind_fryer
	name = "mind fryer"
	icon_state = "mind_fryer"
	var/datum/antag_contract/derail/contract
	var/datum/mind/owner
	var/list/mob/living/carbon/human/victims

/obj/item/device/mind_fryer/attack_self(mob/user)
	if(owner == user.mind)
		return
	owner = user.mind
	to_chat(user, "You claim \the [src].")

/obj/item/device/mind_fryer/verb/activate()
	set name = "Activate"
	set category = "Object"
	set src in view(1)
	if(usr.incapacitated() || !Adjacent(usr))
		return
	icon_state = "mind_fryer_deploy"
	for(var/datum/antag_contract/derail/C in GLOB.all_antag_contracts)
		if(C.completed)
			continue
		contract = C
		break
	victims = list(owner.current)
	START_PROCESSING(SSobj, src)
	verbs -= .verb/activate

/obj/item/device/mind_fryer/Process()
	for(var/mob/living/carbon/human/H in view(src))
		if(H.get_species() != "Human" || (H in victims))
			continue
		icon_state = "mind_fryer_running"
		H.sanity.onPsyDamage(2)

/obj/item/device/mind_fryer/proc/reg_break(mob/living/carbon/human/victim)
	victims += victim
	if(victims.len > contract?.count)
		contract.report(src)
		contract = null
