var/list/inquisitor_rituals = typesof(/datum/ritual/inquisitor)+typesof(/datum/ritual/targeted/inquisitor)

/obj/item/weapon/implant/external/core_implant/cruciform/inquisitor
	power = 100
	max_power = 100
	success_modifier = 5

/obj/item/weapon/implant/external/core_implant/cruciform/inquisitor/New()
	rituals = cruciform_base_rituals + cruciform_priest_rituals + inquisitor_rituals

/datum/ritual/inquisitor
	name = "inquisitor"
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform
	success_message = "On the verge of audibility you hear pleasant music, your mind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "Cruciform on your chest is getting cold and pricks your skin."


/datum/ritual/targeted/inquisitor
	name = "inquisitor targeted"
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform
	success_message = "On the verge of audibility you hear pleasant music, your mind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "Cruciform on your chest is getting cold and pricks your skin."


/datum/ritual/targeted/inquisitor/whip
	name = "whip"
	phrase = "Kok i kek bratya na vek \[Target human]"

/datum/ritual/targeted/inquisitor/whip/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	if(!targets.len)
		fail("Target not found.",user,C,targets)
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/CI = targets[1]

	if(!CI.active || !CI.wearer)
		fail("Cruciform not found.", user, C)
		return FALSE

	var/mob/living/M = CI.wearer

	M << "<span class='danger'>You feel wave of shocking pain coming from your cruciform.</span>"

	if(CI.active)
		fail("This cruciform already activated.", user, C)
		return FALSE

	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(1, 1, M)
	s.start()

	M.apply_effect(50, AGONY, 0)

	return TRUE

/datum/ritual/targeted/inquisitor/whip/process_target(var/index, var/obj/item/weapon/implant/external/core_implant/target, var/text)
	target.update_address()
	if(index == 1 && target.address == text)
		if(target.wearer && !istype(target,/obj/item/weapon/implant/external/core_implant/cruciform/inquisitor) && \
		 (target.loc && target.locs[1] in view()))
			return target


/datum/ritual/targeted/inquisitor/obey
	name = "obey"
	phrase = "Lol kek cheburek \[Target human]"

/datum/ritual/targeted/inquisitor/obey/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)


/datum/ritual/targeted/inquisitor/obey/process_target(var/index, var/obj/item/weapon/implant/external/core_implant/target, var/text)


/datum/ritual/targeted/inquisitor/release
	name = "release"
	phrase = "cheburek kek Lol \[Target human]"

/datum/ritual/targeted/inquisitor/release/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)


/datum/ritual/targeted/inquisitor/release/process_target(var/index, var/obj/item/weapon/implant/external/core_implant/target, var/text)


/datum/ritual/inquisitor/crusader_litany
	name = "crusader's litany"
	phrase = "Kek lol arbidol"

/datum/ritual/inquisitor/crusader_litany/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C,list/targets)
	H << "<span class='info'>You feel relieved. The pain goes away, the wounds heal.</span>"
	H.add_chemical_effect(CE_PAINKILLER, 20)
	H.adjustBruteLoss(-20)
	H.adjustFireLoss(-20)
	H.adjustOxyLoss(-40)
	H.updatehealth()
	return TRUE

/datum/ritual/inquisitor/healing_palm
	name = "healing palm"
	phrase = "Kek lol arbidol this asshole"

/datum/ritual/inquisitor/healing_palm/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI || !CI.active || !CI.wearer)
		fail("Cruciform not found.", user, C)
		return FALSE

	var/mob/living/carbon/human/H = CI.wearer

	if(!istype(H))
		fail("Target not found.",user,C,targets)
		return FALSE

	H << "<span class='info'>You feel relieved. The pain goes away, the wounds heal.</span>"
	H.add_chemical_effect(CE_PAINKILLER, 20)
	H.adjustBruteLoss(-20)
	H.adjustFireLoss(-20)
	H.adjustOxyLoss(-40)
	H.updatehealth()

	return TRUE

/datum/ritual/targeted/inquisitor/god_eye
	name = "god eye"
	phrase = "I see you the \[Target human]"

/datum/ritual/targeted/inquisitor/god_eye/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	if(!targets.len)
		fail("Target not found.",user,C,targets)
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/CI = targets[1]

	if(!CI.active || !CI.wearer)
		fail("Cruciform not found.", user, C)
		return FALSE

	var/mob/living/M = CI.wearer

	if(!user.client)
		return FALSE

	if(user == M)
		fail("You feel stupid.",user,C,targets)
		return FALSE

	var/mob/observer/eye/god/eye = new/mob/observer/eye/god(M)
	eye.target = M
	eye.owner_mob = user
	eye.owner_loc = user.loc
	eye.owner = eye
	user.reset_view(eye)

	return TRUE


/datum/ritual/targeted/inquisitor/god_eye/process_target(var/index, var/obj/item/weapon/implant/external/core_implant/target, var/text)
	if(index == 1 && target.address == text && target.active)
		if(target.wearer && target.wearer.stat != DEAD)
			return target

/datum/ritual/targeted/inquisitor/message
	name = "message"
	phrase = "PM to \[Target human] text: \[Target words]"

/datum/ritual/targeted/inquisitor/message/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	if(targets.len < 2)
		fail("Target not found.",user,C,targets)
		return FALSE

	var/obj/item/weapon/implant/external/core_implant/CI = targets[1]

	if(!CI.active || !CI.wearer)
		fail("Cruciform not found.", user, C)
		return FALSE

	var/mob/living/carbon/human/H = CI.wearer

	if(user == H)
		fail("You feel stupid.",user,C,targets)
		return FALSE

	var/text = targets[2]

	H << "<span class='notice'>You hear a strange voice in your head. It says: \"[text]\"</span>"

/datum/ritual/targeted/inquisitor/message/process_target(var/index, var/obj/item/weapon/implant/external/core_implant/target, var/text)
	switch(index)
		if(1)
			if(target.address == text && target.wearer)
				return target
		if(2)
			if(text && text != "")
				return text

/datum/ritual/inquisitor/initiation
	name = "initiation"
	phrase = "You, asshole, become a priest"

/datum/ritual/inquisitor/initiation/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)

