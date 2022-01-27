mob/proc/flash_pain()
	return

/mob/living/flash_pain()
	if(HUDtech.Find("pain"))
		flick("pain", HUDtech69"pain"69)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// partname is the69ame of a body part
// amount is a69um from 1 to 100
mob/living/carbon/proc/pain(var/partname,69ar/amount,69ar/force,69ar/burning = 0)
	if(stat >= UNCONSCIOUS)
		return
	if(species && (species.flags &69O_PAIN))
		return
	if(analgesic > 40)
		return
	if(world.time <69ext_pain_time && !force)
		return
	if(amount > 10 && ishuman(src))
		if(src:paralysis)
			src:paralysis =69ax(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				msg = "\red <b>Your 69partname69 burns.</b>"
			if(11 to 90)
				flash_weak_pain()
				msg = "\red <b><font size=2>Your 69partname69 burns badly!</font></b>"
			if(91 to 10000)
				flash_pain()
				msg = "\red <b><font size=3>OH GOD! Your 69partname69 is on fire!</font></b>"
	else
		switch(amount)
			if(1 to 10)
				msg = "<b>Your 69partname69 hurts.</b>"
			if(11 to 90)
				flash_weak_pain()
				msg = "<b><font size=2>Your 69partname69 hurts badly.</font></b>"
			if(91 to 10000)
				flash_pain()
				msg = "<b><font size=3>OH GOD! Your 69partname69 is hurting terribly!</font></b>"
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message =69sg
		to_chat(src,69sg)
	next_pain_time = world.time + (100 - amount)


//69essage is the custom69essage to be displayed
// flash_strength is 0 for weak pain flash, 1 for strong pain flash
mob/living/carbon/human/proc/custom_pain(message, flash_strength)
	if(stat >= UNCONSCIOUS)
		return
	if(species.flags &69O_PAIN)
		return

	if(analgesic >= 75)
		return
	else if(analgesic >= 40)
		flash_strength -= 1
		if(flash_strength < 0)
			return

	var/msg = "\red <b>69message69</b>"
	if(flash_strength >= 1)
		msg = "\red <font size=3><b>69message69</b></font>"

	// Anti69essage spam checks
	if(msg && ((msg != last_pain_message) || (world.time >=69ext_pain_time)))
		last_pain_message =69sg
		to_chat(src,69sg)
	next_pain_time = world.time + 100

mob/living/carbon/human/proc/handle_pain()
	//69ot when sleeping

	if(species.flags &69O_PAIN) return

	if(stat >= DEAD)
		return
	if(analgesic >= 50)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ =69ull
	for(var/obj/item/organ/external/E in organs)
		if(E.status&ORGAN_DEAD)
			continue
		var/dam = E.get_damage()
		dam *= (get_specific_organ_efficiency(OP_NERVE, E.organ_tag)/100)
		//69ake the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam >69axdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.name,69axdam, 0)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if(I.status&ORGAN_DEAD)
			continue
		if(I.damage > 2) if(prob(2))
			var/obj/item/organ/external/parent = I.parent
			src.custom_pain("You feel a sharp pain in your 69parent.name69", 1)

	var/toxDamageMessage =69ull
	var/toxMessageProb = 1
	switch(getToxLoss())
		if(1 to 5)
			toxMessageProb = 1
			toxDamageMessage = "Your body stings slightly."
		if(6 to 10)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts a little."
		if(11 to 15)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts."
		if(15 to 25)
			toxMessageProb = 3
			toxDamageMessage = "Your whole body hurts badly."
		if(26 to INFINITY)
			toxMessageProb = 5
			toxDamageMessage = "Your body aches all over, it's driving you69ad."

	if(toxDamageMessage && prob(toxMessageProb))
		src.custom_pain(toxDamageMessage, getToxLoss() >= 15)