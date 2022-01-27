/mob/living/carbon/human/examine(mob/user)
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our69iew and stuff.
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

	var/msg = "<span class='info'>*---------*\nThis is "

	var/datum/gender/T = gender_datums69gender69
	if(skipjumpsuit && skipface) //big suits/masks/helmets69ake it hard to tell their gender
		T = gender_datums69PLURAL69
	else
		if(icon)
			msg += "\icon69icon69 " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!T)
		// Just in case someone69Vs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH()69ow with a helpful69essage.
		CRASH("Gender datum was69ull; key was '69(skipjumpsuit && skipface) ? PLURAL : gender69'")

	msg += "<EM>69src.name69</EM>"
	msg += "!\n"

	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.accessories.len)
				tie_msg += ". Attached to it is 69lowertext(english_list(U.accessories))69"

		if(w_uniform.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.is69 wearing \icon69w_uniform69 69w_uniform.gender==PLURAL?"some":"a"69 69(w_uniform.blood_color != "#030303") ? "blood" : "oil"69-stained 69w_uniform.name6969tie_msg69!</span>\n"
		else
			msg += "69T.He69 69T.is69 wearing \icon69w_uniform69 \a 69w_uniform6969tie_msg69.\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.is69 wearing \icon69head69 69head.gender==PLURAL?"some":"a"69 69(head.blood_color != "#030303") ? "blood" : "oil"69-stained 69head.name69 on 69T.his69 head!</span>\n"
		else
			msg += "69T.He69 69T.is69 wearing \icon69head69 \a 69head69 on 69T.his69 head.\n"

	//suit/armour
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.is69 wearing \icon69wear_suit69 69wear_suit.gender==PLURAL?"some":"a"69 69(wear_suit.blood_color != "#030303") ? "blood" : "oil"69-stained 69wear_suit.name69!</span>\n"
		else
			msg += "69T.He69 69T.is69 wearing \icon69wear_suit69 \a 69wear_suit69.\n"

		//suit/armour storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_DNA)
				msg += "<span class='warning'>69T.He69 69T.is69 carrying \icon69s_store69 69s_store.gender==PLURAL?"some":"a"69 69(s_store.blood_color != "#030303") ? "blood" : "oil"69-stained 69s_store.name69 on 69T.his69 69wear_suit.name69!</span>\n"
			else
				msg += "69T.He69 69T.is69 carrying \icon69s_store69 \a 69s_store69 on 69T.his69 69wear_suit.name69.\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.has69 \icon69back69 69back.gender==PLURAL?"some":"a"69 69(back.blood_color != "#030303") ? "blood" : "oil"69-stained 69back69 on 69T.his69 back.</span>\n"
		else
			msg += "69T.He69 69T.has69 \icon69back69 \a 69back69 on 69T.his69 back.\n"

	//left hand
	if(l_hand&& !(l_hand.item_flags & ABSTRACT))//Abstract items don't show up when examined.
		if(l_hand.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.is69 holding \icon69l_hand69 69l_hand.gender==PLURAL?"some":"a"69 69(l_hand.blood_color != "#030303") ? "blood" : "oil"69-stained 69l_hand.name69 in 69T.his69 69l_hand.wielded ? "hands" : "left hand"69!</span>\n"
		else
			msg += "69T.He69 69T.is69 holding \icon69l_hand69 \a 69l_hand69 in 69T.his69 69l_hand.wielded ? "hands" : "left hand"69.\n"

	//right hand
	if(r_hand && !(r_hand.item_flags & ABSTRACT))
		if(r_hand.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.is69 holding \icon69r_hand69 69r_hand.gender==PLURAL?"some":"a"69 69(r_hand.blood_color != "#030303") ? "blood" : "oil"69-stained 69r_hand.name69 in 69T.his69 69r_hand.wielded ? "hands" : "right hand"69!</span>\n"
		else
			msg += "69T.He69 69T.is69 holding \icon69r_hand69 \a 69r_hand69 in 69T.his69 69r_hand.wielded ? "hands" : "right hand"69.\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.has69 \icon69gloves69 69gloves.gender==PLURAL?"some":"a"69 69(gloves.blood_color != "#030303") ? "blood" : "oil"69-stained 69gloves.name69 on 69T.his69 hands!</span>\n"
		else
			msg += "69T.He69 69T.has69 \icon69gloves69 \a 69gloves69 on 69T.his69 hands.\n"
	else if(blood_DNA)
		msg += "<span class='warning'>69T.He69 69T.has69 69(hand_blood_color != "#030303") ? "blood" : "oil"69-stained hands!</span>\n"

	//handcuffed?

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "<span class='warning'>69T.He69 69T.is69 \icon69handcuffed69 restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>69T.He69 69T.is69 \icon69handcuffed69 handcuffed!</span>\n"

	//buckled
	if(buckled)
		msg += "<span class='warning'>69T.He69 69T.is69 \icon69buckled69 buckled to 69buckled69!</span>\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.has69 \icon69belt69 69belt.gender==PLURAL?"some":"a"69 69(belt.blood_color != "#030303") ? "blood" : "oil"69-stained 69belt.name69 about 69T.his69 waist!</span>\n"
		else
			msg += "69T.He69 69T.has69 \icon69belt69 \a 69belt69 about 69T.his69 waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.is69 wearing \icon69shoes69 69shoes.gender==PLURAL?"some":"a"69 69(shoes.blood_color != "#030303") ? "blood" : "oil"69-stained 69shoes.name69 on 69T.his69 feet!</span>\n"
		else
			msg += "69T.He69 69T.is69 wearing \icon69shoes69 \a 69shoes69 on 69T.his69 feet.\n"
	else if(feet_blood_DNA)
		msg += "<span class='warning'>69T.He69 69T.has69 69(feet_blood_color != "#030303") ? "blood" : "oil"69-stained feet!</span>\n"

	//mask
	if(wear_mask && !skipmask)
		var/descriptor = "on 69T.his69 face"
		if(istype(wear_mask, /obj/item/grenade))
			descriptor = "in 69T.his6969outh"
		if(wear_mask.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.has69 \icon69wear_mask69 69wear_mask.gender==PLURAL?"some":"a"69 69(wear_mask.blood_color != "#030303") ? "blood" : "oil"69-stained 69wear_mask.name69 69descriptor69!</span>\n"
		else
			msg += "69T.He69 69T.has69 \icon69wear_mask69 \a 69wear_mask69 69descriptor69.\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_DNA)
			msg += "<span class='warning'>69T.He69 69T.has69 \icon69glasses69 69glasses.gender==PLURAL?"some":"a"69 69(glasses.blood_color != "#030303") ? "blood" : "oil"69-stained 69glasses69 covering 69T.his69 eyes!</span>\n"
		else
			msg += "69T.He69 69T.has69 \icon69glasses69 \a 69glasses69 covering 69T.his69 eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "69T.He69 69T.has69 \icon69l_ear69 \a 69l_ear69 on 69T.his69 left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "69T.He69 69T.has69 \icon69r_ear69 \a 69r_ear69 on 69T.his69 right ear.\n"

	//ID
	if(wear_id)
		msg += "69T.He69 69T.is69 wearing \icon69wear_id69 \a 69wear_id69.\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>69T.He69 69T.is69 convulsing69iolently!</B></span>\n"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>69T.He69 69T.is69 extremely jittery.</span>\n"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>69T.He69 69T.is69 twitching ever so slightly.</span>\n"

	//splints
	for(var/organ in list(BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG, BP_GROIN, BP_HEAD, BP_CHEST))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.status & ORGAN_SPLINTED)
			msg += "<span class='warning'>69T.He69 69T.has69 a splint on 69T.his69 69o.name69!</span>\n"

	if(!wear_suit && !w_uniform && !(T == src))
		if(locate(/obj/item/implant/carrion_spider) in src)
			msg += SPAN_DANGER("69T.He69 69T.has69 a strange growth on 69T.his69 chest!") + "\n"

	if(mSmallsize in69utations)
		msg += "69T.He69 69T.is69 small halfling!\n"

	var/distance = get_dist(usr,src)
	if(isghost(usr) || usr?.stat == DEAD) // ghosts can see anything
		distance = 1
	if(src.stat || (status_flags & FAKEDEATH))
		msg += "<span class='warning'>69T.He69 69T.is69n't responding to anything around 69T.him69 and seems to be asleep.</span>\n"
		if((stat == DEAD || src.losebreath || (status_flags & FAKEDEATH)) && distance <= 3)
			msg += "<span class='warning'>69T.He69 69T.does6969ot appear to be breathing.</span>\n"
		if(ishuman(usr) && !usr?.stat && Adjacent(usr))
			usr?.visible_message("<b>69usr69</b> checks 69src69's pulse.", "You check 69src69's pulse.")
		if(distance<=1 && do_mob(usr,src,15,progress=0))
			if(status_flags & FAKEDEATH)
				to_chat(usr, "<span class='deadsay'>69T.He69 69T.has6969o pulse and 69T.his69 soul has departed...</span>")
			else if(pulse() == PULSE_NONE)
				to_chat(usr, "<span class='deadsay'>69T.He69 69T.has6969o pulse69src.client ? "" : " and 69T.his69 soul has departed"69...</span>")
			else
				to_chat(usr, "<span class='deadsay'>69T.He69 69T.has69 a pulse!</span>")

	if(fire_stacks)
		msg += "69T.He69 69T.is69 covered in some liquid.\n"
	if(on_fire)
		msg += "<span class='warning'>69T.He69 69T.is69 on fire!.</span>\n"

	if(species.show_ssd && (!species.has_process69BP_BRAIN69 || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>69T.He69 69T.is69 69species.show_ssd69. It doesn't look like 69T.he69 69T.is69 waking up anytime soon.</span>\n"
		else if(!client)
			msg += "<span class='deadsay'>69T.He69 69T.is69 69species.show_ssd69.</span>\n"

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()

	for(var/organ_tag in species.has_limbs)

		var/datum/organ_description/OD = species.has_limbs69organ_tag69
		var/organ_descriptor = OD.name

		var/obj/item/organ/external/E = organs_by_name69organ_tag69
		if(!E)
			wound_flavor_text69"69organ_descriptor69"69 = "<span class='warning'><b>69T.He69 69T.is6969issing 69T.his69 69organ_descriptor69.</b></span>\n"
		else if(E.is_stump())
			wound_flavor_text69"69organ_descriptor69"69 = "<span class='warning'><b>69T.He69 69T.has69 a stump where 69T.his69 69organ_descriptor69 should be.</b></span>\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(BP_IS_SILICON(temp))
			var/part_display_name
			if(copytext(temp.name, 1, 6) == "robot")
				part_display_name = "\a 69temp69"
			else
				part_display_name = "a robot 69temp.name69"

			if(!(temp.brute_dam + temp.burn_dam))
				wound_flavor_text69"69temp.name69"69 = "<span class='warning'>69T.He69 69T.has69 69part_display_name69!</span>\n"
			else
				wound_flavor_text69"69temp.name69"69 = "<span class='warning'>69T.He69 69T.has69 69part_display_name69. It has 69temp.get_wounds_desc()69!</span>\n"
			continue
		else if(temp.wounds.len > 0 || temp.open)
			if(temp.is_stump() && temp.parent)
				wound_flavor_text69"69temp.name69"69 = "<span class='warning'>69T.He69 69T.has69 69temp.get_wounds_desc()69 on 69T.his69 69temp.parent.name69.</span><br>"
			else
				wound_flavor_text69"69temp.name69"69 = "<span class='warning'>69T.He69 69T.has69 69temp.get_wounds_desc()69 on 69T.his69 69temp.name69.</span><br>"
			if(temp.status & ORGAN_BLEEDING)
				is_bleeding69"69temp.name69"69 = "<span class='danger'>69T.His69 69temp.name69 is bleeding!</span><br>"
		else
			wound_flavor_text69"69temp.name69"69 = ""
		if(temp.dislocated == 2)
			wound_flavor_text69"69temp.name69"69 += "<span class='warning'>69T.His69 69temp.joint69 is dislocated!</span><br>"
		if(((temp.status & ORGAN_BROKEN) && temp.brute_dam > temp.min_broken_damage) || (temp.status & ORGAN_MUTATED))
			wound_flavor_text69"69temp.name69"69 += "<span class='warning'>69T.His69 69temp.name69 is dented and swollen!</span><br>"

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is69ot69issing, put flavortext.  If it is covered but bleeding, add other flavortext.

	// ***********************************************************************************
	// THIS69EEDS TO BE ENTIRELY REWRITTEN. Commenting out for69ow, BADLY69EEDS REWRITING.
	// ***********************************************************************************

	/*
	var/display_chest = 0
	var/display_shoes = 0
	var/display_gloves = 0

	if(wound_flavor_text69"head"69 && (is_destroyed69"head"69 || (!skipmask && !(wear_mask && istype(wear_mask, /obj/item/clothing/mask/gas)))))
		msg += wound_flavor_text69"head"69
	else if(is_bleeding69"head"69)
		msg += "<span class='warning'>69src69 69T.has69 blood running down 69T.his69 face!</span>\n"

	if(wound_flavor_text69"upper body"69 && !w_uniform && !skipjumpsuit) //No69eed.  A69issing chest gibs you.
		msg += wound_flavor_text69"upper body"69
	else if(is_bleeding69"upper body"69)
		display_chest = 1

	if(wound_flavor_text69"left arm"69 && (is_destroyed69"left arm"69 || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text69"left arm"69
	else if(is_bleeding69"left arm"69)
		display_chest = 1

	if(wound_flavor_text69"left hand"69 && (is_destroyed69"left hand"69 || (!gloves && !skipgloves)))
		msg += wound_flavor_text69"left hand"69
	else if(is_bleeding69"left hand"69)
		display_gloves = 1

	if(wound_flavor_text69"right arm"69 && (is_destroyed69"right arm"69 || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text69"right arm"69
	else if(is_bleeding69"right arm"69)
		display_chest = 1

	if(wound_flavor_text69"right hand"69 && (is_destroyed69"right hand"69 || (!gloves && !skipgloves)))
		msg += wound_flavor_text69"right hand"69
	else if(is_bleeding69"right hand"69)
		display_gloves = 1

	if(wound_flavor_text69"lower body"69 && (is_destroyed69"lower body"69 || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text69"lower body"69
	else if(is_bleeding69"lower body"69)
		display_chest = 1

	if(wound_flavor_text69"left leg"69 && (is_destroyed69"left leg"69 || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text69"left leg"69
	else if(is_bleeding69"left leg"69)
		display_chest = 1

	if(wound_flavor_text69"right leg"69 && (is_destroyed69"right leg"69 || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text69"right leg"69
	else if(is_bleeding69"right leg"69)
		display_chest = 1

	if(display_chest)
		msg += "<span class='danger'>69src69 69T.has69 blood soaking through from under 69T.his69 clothing!</span>\n"
	if(display_shoes)
		msg += "<span class='danger'>69src69 69T.has69 blood running from 69T.his69 shoes!</span>\n"
	if(display_gloves)
		msg += "<span class='danger'>69src69 69T.has69 blood running from under 69T.his69 gloves!</span>\n"
	*/

	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text69limb69
		is_bleeding69limb69 =69ull
	for(var/limb in is_bleeding)
		msg += is_bleeding69limb69
	for(var/implant in get_visible_implants())
		msg += "<span class='danger'>69src69 69T.has69 \a 69implant69 sticking out of 69T.his69 flesh!</span>\n"
	if(digitalcamo)
		msg += "69T.He69 69T.is69 repulsively uncanny!\n"

	if(hasHUD(usr,"security"))
		var/perpname = get_id_name(name)
		var/criminal = "None"

		if(perpname)
			var/datum/computer_file/report/crew_record/R = get_crewmember_record(perpname)
			criminal = R ? R.get_criminalStatus() : "None"

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref69src69;criminal=1'>\6969criminal69\69</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref69src69;secrecord=`'>\69View\69</a>  <a href='?src=\ref69src69;secrecordadd=`'>\69Add comment\69</a>\n"

	if(hasHUD(usr,"medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(wear_id)
			var/obj/item/card/id/id_card = wear_id.GetIdCard()
			if(id_card)
				perpname = id_card.registered_name
		else
			perpname = src.name

		for (var/datum/data/record/E in data_core.general)
			if (E.fields69"name"69 == perpname)
				for (var/datum/data/record/R in data_core.general)
					if (R.fields69"id"69 == E.fields69"id"69)
						medical = R.fields69"p_stat"69

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref69src69;medical=1'>\6969medical69\69</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref69src69;medrecord=`'>\69View\69</a> <a href='?src=\ref69src69;medrecordadd=`'>\69Add comment\69</a>\n"

		var/obj/item/clothing/under/U = w_uniform
		if(U && istype(U) && U.sensor_mode >= 2)
			msg += "<span class='deptradio'><b>Damage Specifics:</span> <span style=\"color:blue\">69round(src.getOxyLoss(), 1)69</span>-<span style=\"color:green\">69round(src.getToxLoss(), 1)69</span>-<span style=\"color:#FFA500\">69round(src.getFireLoss(), 1)69</span>-<span style=\"color:red\">69round(src.getBruteLoss(), 1)69</span></b>\n"
	if(print_flavor_text())69sg += "69print_flavor_text()69\n"

	msg += "*---------*</span>"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n69T.He69 69T.is69 69pose69"

	to_chat(user,69sg)
	. =69sg

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and69edical records.
/proc/hasHUD(mob/M as69ob, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(isrobot(M))
		var/mob/living/silicon/robot/R =69
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else
		return 0
