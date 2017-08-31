var/list/inquisitor_rituals = typesof(/datum/ritual/inquisitor)+typesof(/datum/ritual/targeted/inquisitor)

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

	if(!CI.active || !CI.wearer || CI.get_module(CRUCIFORM_INQUISITOR))

		fail("Cruciform not found.", user, C)
		return FALSE

	var/mob/living/M = CI.wearer

	M << SPAN_DANGER("You feel wave of shocking pain coming from your cruciform.")

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
		if(target.wearer && target.get_module(CRUCIFORM_INQUISITOR) && \
		 (target.loc && target.locs[1] in view()))
			return target


/datum/ritual/inquisitor/obey
	name = "obey"
	phrase = "Lol kek cheburek"

/datum/ritual/inquisitor/obey/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	var/obj/item/weapon/implant/external/core_implant/CI = get_grabbed(user)

	if(!CI || !CI.wearer || !ishuman(CI.wearer) || !CI.active || CI.get_module(CRUCIFORM_INQUISITOR))

		fail("Cruciform not found",user,C)
		return FALSE

	if(CI.get_module(CRUCIFORM_OBEY))
		fail("The target is already obeying.",user,C)
		return FALSE

	var/datum/core_module/activatable/cruciform/obey_activator/OA = CI.get_module(CRUCIFORM_OBEY_ACTIVATOR)

	if(!OA)
		fail("Target must have obey upgrade inside his cruciform.",user,C)
		return FALSE

	OA.activate()

	return TRUE

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

	if(!CI.active || !CI.wearer || CI.get_module(CRUCIFORM_INQUISITOR))
  
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
	var/obj/item/weapon/implant/external/core_implant/CI = get_grabbed(user)

	if(!CI || !CI.wearer || !ishuman(CI.wearer) || !CI.active)
		fail("Cruciform not found",user,C)
		return FALSE


	if(CI.get_module(CRUCIFORM_PRIEST) || CI.get_module(CRUCIFORM_INQUISITOR))
		fail("The target is already a priest.",user,C)
		return FALSE

	var/datum/core_module/activatable/cruciform/priest_convert/PC = CI.get_module(CRUCIFORM_PRIEST_CONVERT)

	if(!PC)
		fail("Target must have priest upgrade inside his cruciform.",user,C)
		return FALSE

	PC.activate()

	return TRUE

/datum/ritual/inquisitor/check_telecrystals
	name = "telecrystals"
	phrase = "Skolko telekristalov u menya"

/datum/ritual/inquisitor/check_telecrystals/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	var/datum/core_module/cruciform/inquisitor/I = C.get_module(CRUCIFORM_INQUISITOR)

	if(I && I.telecrystals)
		user << "<span class='info'>You have [I.telecrystals] telecrystals.</span>"
		return FALSE
	else
		user << "<span class='info'>You have no telecrystals.</span>"
		return FALSE


/datum/ritual/targeted/inquisitor/spawn_item
	name = "spawn item"
	phrase = "Spawni vesch \[Target words]"
	desc = "book obey priest"

/datum/ritual/targeted/inquisitor/spawn_item/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C,list/targets)
	var/datum/core_module/cruciform/inquisitor/I = C.get_module(CRUCIFORM_INQUISITOR)

	if(!targets.len)
		fail("Wrong item name.",user,C,targets)
		return FALSE

	if(!I || I.telecrystals <= 0)
		fail("You have no telecrystals.",user,C)
		return FALSE

	var/item_name = targets[1]
	var/correct = FALSE
	var/turf/T = get_turf(user)

	switch(item_name)
		if("book")
			correct = try_to_spawn(/obj/item/weapon/book/ritual/cruciform/inquisitor,5,I,T)
		if("obey")
			correct = try_to_spawn(/obj/item/weapon/coreimplant_upgrade/cruciform/obey,10,I,T)
		if("priest")
			correct = try_to_spawn(/obj/item/weapon/coreimplant_upgrade/cruciform/priest,10,I,T)

	if(!correct)
		fail("Wrong item name.",user,C,targets)
		return FALSE

	return TRUE

/datum/ritual/targeted/inquisitor/spawn_item/proc/try_to_spawn(var/type, var/price, var/datum/core_module/cruciform/inquisitor/I, var/turf/T)
	if(!I || I.telecrystals < price || !isturf(T) || !ispath(type))
		return FALSE

	new type(T)
	I.telecrystals -= price
	return TRUE

/datum/ritual/targeted/inquisitor/spawn_item/process_target(var/index, var/obj/item/weapon/implant/external/core_implant/target, var/text)
	return text

