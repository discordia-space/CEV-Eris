/mob/living/carbon/human/examine(mob/user, extra_description = "")
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE

	var/msg = "This is "

	var/datum/gender/T = gender_datums[gender]
	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		T = gender_datums[PLURAL]
	else
		if(icon)
			msg += "[icon2html(icon, user)] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!T)
		// Just in case someone VVs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Gender datum was null; key was '[(skipjumpsuit && skipface) ? PLURAL : gender]'")

	msg += "<EM>[src.name]</EM>"
	msg += "!\n"




	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.accessories.len)
				tie_msg += ". Attached to it is:"
				for (var/obj/item/clothing/accessory in U.accessories)
					tie_msg += "\n - [icon2html(accessory, user)] \A [accessory]"

		if(w_uniform.blood_DNA)
			msg += "[span_warning("[T.He] [T.is] wearing [icon2html(w_uniform, user)] [w_uniform.gender==PLURAL?"some":"a"] [(w_uniform.blood_color != "#030303") ? "blood" : "oil"]-stained [w_uniform.name][tie_msg]!")]\n"
		else
			msg += "[T.He] [T.is] wearing [icon2html(w_uniform, user)] \a [w_uniform][tie_msg].\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "[span_warning("[T.He] [T.is] wearing [icon2html(head, user)] [head.gender==PLURAL?"some":"a"] [(head.blood_color != "#030303") ? "blood" : "oil"]-stained [head.name] on [T.his] head!")]\n"
		else
			msg += "[T.He] [T.is] wearing [icon2html(head, user)] \a [head] on [T.his] head.\n"

	//suit/armour
	if(wear_suit)
		var/tie_msg
		if(istype(wear_suit, /obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(U.accessories.len)
				tie_msg += ". Attached to it is:"
				for (var/obj/item/clothing/accessory in U.accessories)
					tie_msg += "\n - [icon2html(accessory, user)] \A [accessory]"

		if(wear_suit.blood_DNA)
			msg += "[span_warning("[T.He] [T.is] wearing [icon2html(wear_suit, user)] [wear_suit.gender==PLURAL?"some":"a"] [(wear_suit.blood_color != "#030303") ? "blood" : "oil"]-stained [wear_suit.name]!")]\n"
		else
			msg += "[T.He] [T.is] wearing [icon2html(wear_suit, user)] \a [wear_suit][tie_msg].\n"


		//suit/armour storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_DNA)
				msg += "[span_warning("[T.He] [T.is] carrying [icon2html(s_store, user)] [s_store.gender==PLURAL?"some":"a"] [(s_store.blood_color != "#030303") ? "blood" : "oil"]-stained [s_store.name] on [T.his] [wear_suit.name]!")]\n"
			else
				msg += "[T.He] [T.is] carrying [icon2html(s_store, user)] \a [s_store] on [T.his] [wear_suit.name].\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "[span_warning("[T.He] [T.has] [icon2html(back, user)] [back.gender==PLURAL?"some":"a"] [(back.blood_color != "#030303") ? "blood" : "oil"]-stained [back] on [T.his] back.")]\n"
		else
			msg += "[T.He] [T.has] [icon2html(back, user)] \a [back] on [T.his] back.\n"

	//left hand
	if(l_hand&& !(l_hand.item_flags & ABSTRACT))//Abstract items don't show up when examined.
		if(l_hand.blood_DNA)
			msg += "[span_warning("[T.He] [T.is] holding [icon2html(l_hand, user)] [l_hand.gender==PLURAL?"some":"a"] [(l_hand.blood_color != "#030303") ? "blood" : "oil"]-stained [l_hand.name] in [T.his] [l_hand.wielded ? "hands" : "left hand"]!")]\n"
		else
			msg += "[T.He] [T.is] holding [icon2html(l_hand, user)] \a [l_hand] in [T.his] [l_hand.wielded ? "hands" : "left hand"].\n"

	//right hand
	if(r_hand && !(r_hand.item_flags & ABSTRACT))
		if(r_hand.blood_DNA)
			msg += "[span_warning("[T.He] [T.is] holding [icon2html(r_hand, user)] [r_hand.gender==PLURAL?"some":"a"] [(r_hand.blood_color != "#030303") ? "blood" : "oil"]-stained [r_hand.name] in [T.his] [r_hand.wielded ? "hands" : "right hand"]!")]\n"
		else
			msg += "[T.He] [T.is] holding [icon2html(r_hand, user)] \a [r_hand] in [T.his] [r_hand.wielded ? "hands" : "right hand"].\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_DNA)
			msg += "[span_warning("[T.He] [T.has] [icon2html(gloves, user)] [gloves.gender==PLURAL?"some":"a"] [(gloves.blood_color != "#030303") ? "blood" : "oil"]-stained [gloves.name] on [T.his] hands!")]\n"
		else
			msg += "[T.He] [T.has] [icon2html(gloves, user)] \a [gloves] on [T.his] hands.\n"
	else if(blood_DNA)
		msg += "[span_warning("[T.He] [T.has] [(hand_blood_color != "#030303") ? "blood" : "oil"]-stained hands!")]\n"

	//handcuffed?

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "[span_warning("[T.He] [T.is] [icon2html(handcuffed, user)] restrained with cable!")]\n"
		else
			msg += "[span_warning("[T.He] [T.is] [icon2html(handcuffed, user)] handcuffed!")]\n"

	//buckled
	if(buckled)
		msg += "[span_warning("[T.He] [T.is] [icon2html(buckled, user)] buckled to [buckled]!")]\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "[span_warning("[T.He] [T.has] [icon2html(belt, user)] [belt.gender==PLURAL?"some":"a"] [(belt.blood_color != "#030303") ? "blood" : "oil"]-stained [belt.name] about [T.his] waist!")]\n"
		else
			msg += "[T.He] [T.has] [icon2html(belt, user)] \a [belt] about [T.his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_DNA)
			msg += "[span_warning("[T.He] [T.is] wearing [icon2html(shoes, user)] [shoes.gender==PLURAL?"some":"a"] [(shoes.blood_color != "#030303") ? "blood" : "oil"]-stained [shoes.name] on [T.his] feet!")]\n"
		else
			msg += "[T.He] [T.is] wearing [icon2html(shoes, user)] \a [shoes] on [T.his] feet.\n"
	else if(feet_blood_DNA)
		msg += "[span_warning("[T.He] [T.has] [(feet_blood_color != "#030303") ? "blood" : "oil"]-stained feet!")]\n"

	//mask
	if(wear_mask && !skipmask)
		var/descriptor = "on [T.his] face"
		if(istype(wear_mask, /obj/item/grenade))
			descriptor = "in [T.his] mouth"
		if(wear_mask.blood_DNA)
			msg += "[span_warning("[T.He] [T.has] [icon2html(wear_mask, user)] [wear_mask.gender==PLURAL?"some":"a"] [(wear_mask.blood_color != "#030303") ? "blood" : "oil"]-stained [wear_mask.name] [descriptor]!")]\n"
		else
			msg += "[T.He] [T.has] [icon2html(wear_mask, user)] \a [wear_mask] [descriptor].\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_DNA)
			msg += "[span_warning("[T.He] [T.has] [icon2html(glasses, user)] [glasses.gender==PLURAL?"some":"a"] [(glasses.blood_color != "#030303") ? "blood" : "oil"]-stained [glasses] covering [T.his] eyes!")]\n"
		else
			msg += "[T.He] [T.has] [icon2html(glasses, user)] \a [glasses] covering [T.his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[T.He] [T.has] [icon2html(l_ear, user)] \a [l_ear] on [T.his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[T.He] [T.has] [icon2html(r_ear, user)] \a [r_ear] on [T.his] right ear.\n"

	//ID
	if(wear_id)
		msg += "[T.He] [T.is] wearing [icon2html(wear_id, user)] \a [wear_id].\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "[span_warning("<B>[T.He] [T.is] convulsing violently!</B>")]\n"
		else if(jitteriness >= 200)
			msg += "[span_warning("[T.He] [T.is] extremely jittery.")]\n"
		else if(jitteriness >= 100)
			msg += "[span_warning("[T.He] [T.is] twitching ever so slightly.")]\n"

	//Noble or lowborn
	if(ishuman(user) && !wear_mask)
		var/mob/living/carbon/human/H = user
		if(H.stats.getPerk(PERK_NOBLE))
			msg += "[T.He] [T.has] a noble demeanour.\n"
		if(H.stats.getPerk(PERK_LOWBORN))
			msg += "[T.He] [T.has] a lowborn demeanour.\n"

	//crazy
	if(ishuman(user) && !wear_mask)
		var/mob/living/carbon/human/H = user
		if(H.sanity.level <=33 && H.sanity.level > 5)
			msg += "[span_warning("<B>[T.He] [T.has] a weird look on [T.his] face.</B>")]\n"
		else if(H.sanity.level <= 5)
			msg += "[span_warning("<B>[T.He] [T.has] a crazed look on [T.his] face.</B>")]\n"

	//splints
	for(var/organ in list(BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG, BP_GROIN, BP_HEAD, BP_CHEST))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.status & ORGAN_SPLINTED)
			msg += "[span_warning("[T.He] [T.has] a splint on [T.his] [o.name]!")]\n"

	if(!wear_suit && !w_uniform && !(T == src))
		if(locate(/obj/item/implant/carrion_spider) in src)
			msg += span_danger("[T.He] [T.has] a strange growth on [T.his] chest!") + "\n"

//	if(mSmallsize in mutations)
//		msg += "[T.He] [T.is] small halfling!\n"

	var/distance = get_dist(user, src)
	if(isghost(user) || user.stat == DEAD) // ghosts can see anything
		distance = 1
	if(stat || (status_flags & FAKEDEATH))
		msg += "[span_warning("[T.He] [T.is]n't responding to anything around [T.him] and seems to be asleep.")]\n"
		if((stat == DEAD || losebreath || (status_flags & FAKEDEATH)) && distance <= 3)
			msg += "[span_warning("[T.He] [T.does] not appear to be breathing.")]\n"
		if(ishuman(user) && !user?.stat && Adjacent(user))
			user?.visible_message("<b>[user]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
		if(distance <= 1 && do_mob(user, src, 15, progress = 0))
			if(status_flags & FAKEDEATH)
				extra_description += "\n[span_deadsay("[T.He] [T.has] no pulse and [T.his] soul has departed...")]"
			else if(pulse() == PULSE_NONE)
				extra_description += "\n[span_deadsay("[T.He] [T.has] no pulse[src.client ? "" : " and [T.his] soul has departed"]...")]"
			else
				extra_description += "\n[span_deadsay("[T.He] [T.has] a pulse!")]"

	if(fire_stacks)
		msg += "[T.He] [T.is] covered in some liquid.\n"
	if(on_fire)
		msg += "[span_warning("[T.He] [T.is] on fire!.")]\n"

	if(species.show_ssd && (!species.has_process[BP_BRAIN] || has_brain()) && stat != DEAD)
		if(!key)
			msg += "[span_deadsay("[T.He] [T.is] [species.show_ssd]. It doesn't look like [T.he] [T.is] waking up anytime soon.")]\n"
		else if(!client)
			msg += "[span_deadsay("[T.He] [T.is] [species.show_ssd].")]\n"

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()

	for(var/organ_tag in species.has_limbs)

		var/datum/organ_description/OD = species.has_limbs[organ_tag]
		var/organ_descriptor = OD.name

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = "[span_warning("<b>[T.He] [T.is] missing [T.his] [organ_descriptor].</b>")]\n"
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = "[span_warning("<b>[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.</b>")]\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(BP_IS_SILICON(temp))
			var/part_display_name
			if(copytext(temp.name, 1, 6) == "robot")
				part_display_name = "\a [temp]"
			else
				part_display_name = "a robot [temp.name]"

			if(!(temp.brute_dam + temp.burn_dam))
				wound_flavor_text["[temp.name]"] = "[span_warning("[T.He] [T.has] [part_display_name]!")]\n"
			else
				wound_flavor_text["[temp.name]"] = "[span_warning("[T.He] [T.has] [part_display_name]. It has [temp.get_wounds_desc()]!")]\n"
			continue
		else if(temp.wounds.len > 0 || temp.open)
			if(temp.is_stump() && temp.parent)
				wound_flavor_text["[temp.name]"] = "[span_warning("[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [temp.parent.name].")]<br>"
			else
				wound_flavor_text["[temp.name]"] = "[span_warning("[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [temp.name].")]<br>"
			if(temp.status & ORGAN_BLEEDING)
				is_bleeding["[temp.name]"] = "[span_danger("[T.His] [temp.name] is bleeding!")]<br>"
		else
			wound_flavor_text["[temp.name]"] = ""
		if(temp.nerve_struck == 2)
			wound_flavor_text["[temp.name]"] += "[span_warning("[T.His] [temp.joint] is dangling uselessly!")]<br>"
		if(((temp.status & ORGAN_BROKEN) && temp.brute_dam > temp.min_broken_damage) || (temp.status & ORGAN_MUTATED))
			wound_flavor_text["[temp.name]"] += "[span_warning("[T.His] [temp.name] is dented and swollen!")]<br>"

	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
		is_bleeding[limb] = null
	for(var/limb in is_bleeding)
		msg += is_bleeding[limb]
	for(var/implant in get_visible_implants())
		msg += "[span_danger("[src] [T.has] \a [implant] sticking out of [T.his] flesh!")]\n"
	if(digitalcamo)
		msg += "[T.He] [T.is] repulsively uncanny!\n"

	if(hasHUD(user, "security"))
		var/perpname = get_id_name(name)
		var/criminal = "None"

		if(perpname)
			var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
			criminal = R ? R.get_criminalStatus() : "None"
			msg += "\n"
			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='byond://?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='byond://?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='byond://?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"

	if(hasHUD(user, "medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(wear_id)
			var/obj/item/card/id/id_card = wear_id.GetIdCard()
			if(id_card)
				perpname = id_card.registered_name
		else
			perpname = src.name

		for (var/datum/data/record/E in data_core.general)
			if (E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.general)
					if (R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]

		msg += "\n"
		msg += "<span class = 'deptradio'>Physical status:</span> <a href='byond://?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='byond://?src=\ref[src];medrecord=`'>\[View\]</a> <a href='byond://?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"

		var/obj/item/clothing/under/U = w_uniform
		if(U && istype(U) && U.sensor_mode >= 2)
			msg += "[span_deptradio("<b>Damage Specifics:")] <span style=\"color:blue\">[round(src.getOxyLoss(), 1)]</span>-<span style=\"color:green\">[round(src.getToxLoss(), 1)]</span>-<span style=\"color:#FFA500\">[round(src.getFireLoss(), 1)]</span>-<span style=\"color:red\">[round(src.getBruteLoss(), 1)]</span></b>\n"
	var/flavor_text = get_flavor_text()
	if(flavor_text) msg += "[flavor_text]"

	if (pose)
		msg += "\n"
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[T.He] [T.is] [pose]"

	if(isobserver(user))
		to_chat(user, boxed_message("[span_infoplain(msg)]"))
	else
		user.visible_message("<font size=1>[user.name] looks at [src].</font>", boxed_message("[span_infoplain(msg)]"))

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else
		return 0
