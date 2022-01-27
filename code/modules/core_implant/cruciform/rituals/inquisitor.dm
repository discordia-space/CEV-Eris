/*
	Powers contained here:
	Penance: Deals large amounts of harmless pain to a target disciple
	//Obey: Second step of a two-part process to enslave a disciple with an Obey69odule
	Convalescence:69oderately powerful selfheal
	Succour: Heals a target disciple within arms reach
	Scrying: Look through the eyes of a target disciple.  Global range, expensive and limited duration
	Sending: Send a telepathic69essage to a specific disciple. Global range
	Initiation: Promotes a disciple to a preacher
	Knowledge: Checks remaining telecrystals (Inquisitor also has a contractor uplink)
	Bounty: Calls up the uplink to order supplies
*/
/datum/ritual/cruciform/inquisitor
	name = "inquisitor"
	implant_type = /obj/item/implant/core_implant/cruciform
	category = "Inquisitor"
	power = 30

/datum/ritual/targeted/cruciform/inquisitor
	name = "inquisitor targeted"
	implant_type = /obj/item/implant/core_implant/cruciform
	category = "Inquisitor"
	power = 30




/*
	Penance
	Deals pain damage to a targeted disciple
*/
/datum/ritual/targeted/cruciform/inquisitor/penance
	name = "Penance"
	phrase = "Mihi69indicta \69Target human69"
	desc = "Imparts extreme pain on the target disciple. Does no actual harm."
	power = 35

/datum/ritual/targeted/cruciform/inquisitor/penance/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	if(!targets.len)
		fail("Target not found.",user,C,targets)
		return FALSE

	var/obj/item/implant/core_implant/CI = targets69169

	if(!CI.active || !CI.wearer)

		fail("Cruciform not found.", user, C)
		return FALSE

	var/mob/living/M = CI.wearer

	log_and_message_admins(" inflicted pain on 69CI.wearer69 with penance litany")
	to_chat(M, SPAN_DANGER("A wave of agony washes over you, the cruciform in your chest searing like a star for a few69oments of eternity."))


	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(1, 1,69.loc)
	s.start()

	M.adjustHalLoss(50)

	return TRUE

/datum/ritual/targeted/cruciform/inquisitor/penance/process_target(var/index,69ar/obj/item/implant/core_implant/target,69ar/text)
	target.update_address()
	if(index == 1 && target.address == text)
		if(target.wearer && (target.loc && (target.locs69169 in69iew())))
			return target



/*
	Obey
	Goes with obey69odule, disabled for now
*/
/*
/datum/ritual/cruciform/inquisitor/obey
	name = "Obey"
	phrase = "Sicut dilexit69e Pater et ego dilexi,69os69anete in dilectione69ea"
	desc = "Bound believer to your will."

/datum/ritual/cruciform/inquisitor/obey/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	var/obj/item/implant/core_implant/CI = get_implant_from_victim(user, /obj/item/implant/core_implant/cruciform)

	if(!CI || !CI.wearer || !ishuman(CI.wearer) || !CI.active)

		fail("Cruciform not found", user, C)
		return FALSE

	if(CI.get_module(CRUCIFORM_OBEY))
		fail("The target is already obeying.",user,C)
		return FALSE

	var/datum/core_module/activatable/cruciform/obey_activator/OA = CI.get_module(CRUCIFORM_OBEY_ACTIVATOR)

	if(!OA)
		fail("Target69ust have obey upgrade inside his cruciform.",user,C)
		return FALSE

	OA.activate()

	return TRUE
*/




/*
	Convalescence
	Heals yourself a fair amount
*/
/datum/ritual/cruciform/inquisitor/selfheal
	name = "Convalescence"
	phrase = "Dominus autem dirigat corda69estra in caritate Dei et patientia Christi"
	desc = "Recover from the ravages of wounds and pain."
	cooldown = TRUE
	cooldown_time = 100
	power = 25 //Healing yourself is slightly easier than healing someone else

/datum/ritual/cruciform/inquisitor/selfheal/perform(mob/living/carbon/human/H, obj/item/implant/core_implant/C,list/targets)
	to_chat(H, "<span class='info'>A sensation of relief bathes you, washing away your pain</span>")
	log_and_message_admins("healed himself with convalescence litany")
	H.add_chemical_effect(CE_PAINKILLER, 20)
	H.adjustBruteLoss(-20)
	H.adjustFireLoss(-20)
	H.adjustOxyLoss(-40)
	H.updatehealth()
	set_personal_cooldown(H)
	return TRUE




/*
	Succour
	Heals another person, quite powerfully. Only works on NT disciples
*/
/datum/ritual/cruciform/inquisitor/heal_other
	name = "Succour"
	phrase = "Venite ad69e, omnes qui laboratis, et onerati estis et ego reficiam69os"
	desc = "Heal a nearby disciple"
	cooldown = TRUE
	cooldown_time = 100
	power = 35

/datum/ritual/cruciform/inquisitor/heal_other/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	var/obj/item/implant/core_implant/cruciform/CI = get_implant_from_victim(user, /obj/item/implant/core_implant/cruciform)

	if(!CI || !CI.active || !CI.wearer)
		fail("Cruciform not found.", user, C)
		return FALSE



	var/mob/living/carbon/human/H = CI.wearer

	if(!istype(H))
		fail("Target not found.",user,C,targets)
		return FALSE

	//Checking turfs allows this to be done in unusual circumstances
	var/turf/T = get_turf(user)
	if (!(T.Adjacent(get_turf(H))))
		to_chat(user, SPAN_DANGER("69H69 is beyond your reach.."))
		return


	user.visible_message("69user69 places their hands upon 69H69 and utters a prayer", "You lay your hands upon 69H69 and begin speaking the words of convalescence")
	if (do_after(user, 40, H, TRUE))
		T = get_turf(user)
		if (!(T.Adjacent(get_turf(H))))
			to_chat(user, SPAN_DANGER("69H69 is beyond your reach.."))
			return
		log_and_message_admins(" healed 69CI.wearer69 with Succour litany")
		to_chat(H, "<span class='info'>A sensation of relief bathes you, washing away your pain</span>")
		H.add_chemical_effect(CE_PAINKILLER, 20)
		H.adjustBruteLoss(-20)
		H.adjustFireLoss(-20)
		H.adjustOxyLoss(-40)
		H.updatehealth()
		set_personal_cooldown(user)
		return TRUE


/*
	Scrying: Remotely look through someone's eyes. Global range, useful to find fugitives or corpses
	Uses all of your power and has a limited duration
*/
/datum/ritual/cruciform/inquisitor/scrying
	name = "Scrying"
	phrase = "Ecce ego ad te et ad caelum. Scio omnes absconditis tuis.69os can abscondere, tu es coram69e: nudus."
	desc = "Look on the world from the eyes of another believer. Strenuous and can only be69aintained for half a69inute. The target will sense they are being watched, but not by whom."
	power = 100

/datum/ritual/cruciform/inquisitor/scrying/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)

	if(!user.client)
		return FALSE

	var/mob/living/M = pick_disciple_global(user, TRUE)
	if (!M)
		return

	if(user ==69)
		fail("You feel stupid.",user,C,targets)
		return FALSE
	log_and_message_admins("looks through the eyes of 69C69 with scrying litany")
	to_chat(M, SPAN_NOTICE("You feel an odd presence in the back of your69ind. A lingering sense that someone is watching you..."))

	var/mob/observer/eye/god/eye = new/mob/observer/eye/god(M)
	eye.target =69
	eye.owner_mob = user
	eye.owner_loc = user.loc
	eye.owner = eye
	user.reset_view(eye)

	//After 30 seconds, your69iew is forced back to yourself
	addtimer(CALLBACK(user, .mob/proc/reset_view, user), 300)

	return TRUE


/datum/ritual/targeted/cruciform/inquisitor/god_eye/process_target(var/index,69ar/obj/item/implant/core_implant/target,69ar/text)
	if(index == 1 && target.address == text && target.active)
		if(target.wearer && target.wearer.stat != DEAD)
			return target



/*
	Sends a telepathic69essage to any disciple
*/
/datum/ritual/cruciform/inquisitor/message
	name = "Sending"
	phrase = "Audit,69e audit69ocationem. Ego nuntius69obis."
	desc = "Send a69essage anonymously through the69oid, straight into the69ind of another disciple"
	power = 30

/datum/ritual/cruciform/inquisitor/message/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	var/mob/living/carbon/human/H = pick_disciple_global(user, TRUE)
	if (!H)
		return

	if(user == H)
		fail("You feel stupid.",user,C,targets)
		return FALSE

	var/text = input(user, "What69essage will you send to the target? The69essage will be recieved telepathically and they will not know who it is from unless you reveal yourself.", "Sending a69essage") as text|null
	if (!text)
		return
	log_and_message_admins("sent a69essage to 69H69 with text \"69text69\"")
	to_chat(H, "<span class='notice'>A69oice speaks in your69ind: \"69text69\"</span>")






/datum/ritual/cruciform/inquisitor/initiation
	name = "Initiation"
	phrase = "Habe fiduciam in Domino ex toto corde tuo et ne innitaris prudentiae tuae, in omnibus69iis tuis cogita illum et ipse diriget gressus tuos"
	desc = "The second stage of granting a field promotion to a disciple, upgrading them to Preacher. The Preacher ascension kit is the first step."
	power = 100

/datum/ritual/cruciform/inquisitor/initiation/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	var/obj/item/implant/core_implant/CI = get_implant_from_victim(user, /obj/item/implant/core_implant/cruciform)

	if(!CI || !CI.wearer || !ishuman(CI.wearer) || !CI.active)
		fail("Cruciform not found", user, C)
		return FALSE


	if(CI.get_module(CRUCIFORM_PRIEST) || CI.get_module(CRUCIFORM_INQUISITOR))
		fail("The target is already a preacher.",user,C)
		return FALSE

	var/datum/core_module/activatable/cruciform/priest_convert/PC = CI.get_module(CRUCIFORM_PRIEST_CONVERT)

	if(!PC)
		fail("Target69ust have preacher upgrade inside his cruciform.",user,C)
		return FALSE

	PC.activate()
	log_and_message_admins("promoted disciple 69C69 to Preacher with initiation litany")

	return TRUE



/datum/ritual/cruciform/inquisitor/check_telecrystals
	name = "Knowledge"
	phrase = "Cor sapientis quaerit doctrinam, et os stultorum pascetur inperitia"
	desc = "Find out the limits of your power, how69any telecrystals you have now."
	power = 5

/datum/ritual/cruciform/inquisitor/check_telecrystals/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	var/datum/core_module/cruciform/uplink/I = C.get_module(CRUCIFORM_UPLINK)

	if(I && I.uplink)
		I.telecrystals = I.uplink.uses
		to_chat(user, "<span class='info'>You have 69I.telecrystals69 telecrystals.</span>")
		return FALSE
	else
		to_chat(user, "<span class='info'>You have no uplink.</span>")
		return FALSE





/*
	Opens the interface for the embedded Uplink, allowing stuff to be purchased
*/
/datum/ritual/targeted/cruciform/inquisitor/spawn_item
	name = "Bounty"
	phrase = "Supra Domini, bona de te peto. Audi69e, et libera69ocationem ad69e69unera tua"
	desc = "Request supplies and items from headquarters. Find a private place to do this. Establishing the connection takes a lot of power."
	power = 20

/datum/ritual/targeted/cruciform/inquisitor/spawn_item/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C,list/targets)
	var/datum/core_module/cruciform/uplink/I = C.get_module(CRUCIFORM_UPLINK)

	if(I && I.uplink)
		I.uplink.trigger(user)

		return TRUE
	return FALSE

