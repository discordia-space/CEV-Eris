/mob/living/simple_animal/borer/proc/release_host()
	set category = "Abilities"
	set69ame = "Release Host"
	set desc = "Slither out of your host."

	if(stat)
		return

	if(!host)
		to_chat(src, "You are69ot inside a host body.")
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(!host || !src) return

	to_chat(src, SPAN_NOTICE("You begin disconnecting from 69host69's synapses and prodding at their internal ear canal."))

	if(!host.stat)
		to_chat(host, SPAN_WARNING("An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."))

	spawn(100)
		if(!host || stat) return

		to_chat(src, SPAN_DANGER("You wiggle out of 69host69's ear and plop to the ground."))
		if(host.mind && !host.stat)
			if(controlling)
				to_chat(host, SPAN_DANGER("As though waking from a dream, you shake off the insidious69ind control of the brain worm. Your thoughts are your own again."))
			to_chat(host, SPAN_DANGER("Something slimy wiggles out of your ear and plops to the ground!"))

		detatch()
		leave_host()

/mob/living/simple_animal/borer/proc/infest()
	set category = "Abilities"
	set69ame = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(stat)
		return

	if(host)
		to_chat(src, SPAN_WARNING("You are already within a host."))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in69iew(1,src))
		if(src.Adjacent(C))
			choices += C

	if(!choices.len)
		to_chat(src, SPAN_WARNING("There are69o69iable hosts69earby."))
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to infest?") in69ull|choices

	if(!M || !Adjacent(M)) return

	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H =69

		var/obj/item/organ/external/E = H.organs_by_name69BP_HEAD69
		if(!E || E.is_stump())
			to_chat(src, SPAN_WARNING("\The 69H69 does69ot have a head!"))

		if(!H.species.has_process69BP_BRAIN69)
			to_chat(src, SPAN_WARNING("\The 69H69 does69ot seem to have an ear canal to breach."))
			return

		if(H.check_head_coverage() && H.head && !(H.head.canremove))
			to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
			return

	to_chat(M, "Something slimy begins probing at the opening of your ear canal...")
	to_chat(src, SPAN_DANGER("You slither up 69M69 and begin probing at their ear canal..."))

	var/infestation_delay = 2.5 SECONDS

	// It's harder for a borer to infest69Ts
	if(is_neotheology_disciple(M))
		to_chat(src, SPAN_DANGER("A69anofiber69esh implant inside 69M69's head tries to cut you off on your way in. You can work around it, but it will take time."))
		infestation_delay *= 3

	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		if(H.check_head_coverage())
			to_chat(src, SPAN_DANGER("That host's wearing protective gear. You can work around it, but it will take time."))
			infestation_delay *= 3

	// Borer gets host abilities before actually getting inside the host
	// Workaround for a BYOND bug: http://www.byond.com/forum/post/1833666 << We fix this in a better way
	if(!do_mob(src,69, infestation_delay))
		to_chat(src, SPAN_DANGER("As 69M6969oves away, you are dislodged and fall to the ground."))
		return

	to_chat(src, SPAN_NOTICE("You wiggle into 69M69's ear."))
	if(!M.stat)
		to_chat(M, SPAN_DANGER("Something disgusting and slimy wiggles into your ear!"))

	if(invisibility)
		src.invisibility = 0
		src.alpha = 255

	if(sight & SEE_MOBS)
		sight &= ~SEE_MOBS
		to_chat(src, SPAN_NOTICE("You cannot see living being through walls for69ow."))
		return

	host =69
	host.status_flags |= PASSEMOTES
	update_abilities()
	spawn(1) /// Wait for abilities to update THEN69ove them in due to the afore-mentioned bug.
		forceMove(host)
	//Update their contractor status.
	/*if(host.mind && src.mind)
		var/list/L = get_player_antags(src.mind, ROLE_BORER)
		var/datum/antagonist/borer/borer
		if(L.len)
			borer = L69169*/

		if(ishuman(M))
			var/mob/living/carbon/human/H =69
			var/obj/item/organ/I = H.random_organ_by_process(BP_BRAIN)
			if(!I) //69o brain organ, so the borer69oves in and replaces it permanently.
				replace_brain()
			else
				// If they're in69ormally, implant removal can get them out.
				var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
				head.implants += src

/*
/mob/living/simple_animal/borer/verb/devour_brain()
	set category = "Abilities"
	set69ame = "Devour Brain"
	set desc = "Take permanent control of a dead host."

	if(!host)
		to_chat(src, "You are69ot inside a host body.")
		return

	if(host.stat != 2)
		to_chat(src, "Your host is still alive.")
		return

	if(stat)
		to_chat(src, "You cannot do that in your current state.")

	if(docile)
		to_chat(src, "\blue You are feeling far too docile to do that.")
		return


	to_chat(src, "<span class = 'danger'>It only takes a few69oments to render the dead host brain down into a69utrient-rich slurry...</span>")
	replace_brain()
*/

// BRAIN WORM ZOMBIES AAAAH.
/mob/living/simple_animal/borer/proc/replace_brain()

	var/mob/living/carbon/human/H = host

	if(!istype(host))
		to_chat(src, "This host does69ot have a suitable brain.")
		return

	to_chat(src, SPAN_DANGER("You settle into the empty brainpan and begin to expand, fusing inextricably with the dead flesh of 69H69."))

	H.add_language(LANGUAGE_CORTICAL)

	// Remove the usual "host control" abilities
	H.verbs -= abilities_in_control

	H.verbs |= /mob/living/carbon/human/proc/commune
	H.verbs |= /mob/living/carbon/human/proc/psychic_whisper
	H.verbs |= /mob/living/carbon/proc/spawn_larvae
	H.verbs |= /mob/living/carbon/proc/talk_host

	if(H.client)
		H.daemonize()

	if(src.mind)
		src.mind.transfer_to(host)

	H.ChangeToHusk()

	var/obj/item/organ/internal/borer/B =69ew(H)
	H.internal_organs_by_efficiency69BP_BRAIN69 += B
	H.internal_organs |= B

	var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
	affecting.implants -= src

	var/s2h_id = src.computer_id
	var/s2h_ip= src.lastKnownIP
	src.computer_id =69ull
	src.lastKnownIP =69ull

	if(!H.computer_id)
		H.computer_id = s2h_id

	if(!H.lastKnownIP)
		H.lastKnownIP = s2h_ip

	if(H.stat) // > Take over a body that is always dead , die , !?!??!
		var/all_damage = H.getBruteLoss() + H.getFireLoss() + H.getCloneLoss() + H.getOxyLoss() + H.getToxLoss()
		while(all_damage > 90)
			H.adjustBruteLoss(-10)
			H.adjustFireLoss(-10)
			H.adjustCloneLoss(-10)
			H.adjustOxyLoss(-10)
			H.adjustToxLoss(-10)
			all_damage = H.getBruteLoss() + H.getFireLoss() + H.getCloneLoss() + H.getOxyLoss() + H.getToxLoss()
		H.stat = UNCONSCIOUS
		H.updatehealth()

/mob/living/simple_animal/borer/proc/secrete_chemicals()
	set category = "Abilities"
	set69ame = "Secrete Chemicals"
	set desc = "Push some chemicals into your host's bloodstream."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are69ot inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(chemicals < 50)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/list/chem_names = list()
	for(var/id in produced_reagents)
		var/datum/reagent/D = GLOB.chemical_reagents_list69id69
		chem_names69D.name69 = id

	var/chem_name = input("Select a chemical to secrete.", "Chemicals") as69ull|anything in chem_names
	var/chem = chem_names69chem_name69

	if(!chem || chemicals < 50 || !host || controlling || !src || stat) //Sanity check.
		return

	host.reagents.add_reagent(chem, 10)
	to_chat(src, SPAN_NOTICE("You secrete some chemicals from your reservoirs. There are 69host.reagents.get_reagent_amount(chem)69 units of 69chem_name69 in host's bloodstream69ow."))
	chemicals -= 50

/mob/living/simple_animal/borer/proc/paralyze_victim()
	set category = "Abilities"
	set69ame = "Paralyze69ictim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(src.stat)
		return

	if(world.time - used_dominate < 150)
		to_chat(src, SPAN_WARNING("You cannot use that ability again so soon."))
		return

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("You cannot use that ability while in69ent."))
		return

	if(chemicals < 10)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in69iew(1, get_turf(src)))
		if(C == host || C.stat == DEAD)
			continue

		choices += C

	if(!choices)
		to_chat(src, SPAN_WARNING("No available creatures found in your radius."))
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to dominate?") in69ull|choices

	if(world.time - used_dominate < 150)
		to_chat(src, SPAN_WARNING("You cannot use that ability again so soon."))
		return

	if(!M || !(M in69iew(1, get_turf(src)))) return

	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		if(istype(H.wear_suit, /obj/item/clothing/suit/space))
			to_chat(src, SPAN_WARNING("You cannot use that ability on someone, who wear a space suit."))
			return

	if(M.has_brain_worms())
		to_chat(src, "You cannot paralyze someone who is already infested!")
		return

	to_chat(src, SPAN_WARNING("You focus your psychic lance on 69M69 and freeze their limbs with a wave of terrible dread."))
	to_chat(M, SPAN_DANGER("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	var/duration = 10 + (borer_level*2)
	M.Weaken(duration)
	M.SetStunned(duration)
	M.SetParalysis(duration)
	chemicals -= 10
	used_dominate = world.time

/mob/living/simple_animal/borer/proc/assume_control()
	set category = "Abilities"
	set69ame = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are69ot inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	to_chat(src, SPAN_NOTICE("You begin delicately adjusting your connection to the host brain..."))

	spawn(100+(host.brainloss*5))

		if(!host || !src || controlling)
			return
		else

			to_chat(src, SPAN_DANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their69ervous system."))
			to_chat(host, SPAN_DANGER("You feel a strange shifting sensation behind your eyes as another consciousness displaces yours."))
			host.add_language(LANGUAGE_CORTICAL)

			// host -> brain
			var/h2b_id = host.computer_id
			var/h2b_ip= host.lastKnownIP
			host.computer_id =69ull
			host.lastKnownIP =69ull

			qdel(host_brain)
			host_brain =69ew(src)

			host_brain.ckey = host.ckey

			host_brain.name = host.name

			if(!host_brain.computer_id)
				host_brain.computer_id = h2b_id

			if(!host_brain.lastKnownIP)
				host_brain.lastKnownIP = h2b_ip

			// self -> host
			var/s2h_id = src.computer_id
			var/s2h_ip= src.lastKnownIP
			src.computer_id =69ull
			src.lastKnownIP =69ull

			host.ckey = src.ckey

			if(!host.computer_id)
				host.computer_id = s2h_id

			if(!host.lastKnownIP)
				host.lastKnownIP = s2h_ip

			controlling = TRUE

			update_abilities()

/mob/living/simple_animal/borer/proc/jumpstart()
	set category = "Abilities"
	set69ame = "Revive Host"
	set desc = "Send a jolt of electricity through your host, reviving them."

	if(host.stat != DEAD)
		to_chat(usr, "Your host is already alive.")
		return

	if(chemicals < 500)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return

	if(host.getBrainLoss() >= 100)
		to_chat(src, SPAN_WARNING("Host is brain dead!"))
		return

	visible_message(SPAN_WARNING("With a hideous, rattling69oan, 69src69 shudders back to life!"))


	var/all_damage = host.getBruteLoss() + host.getFireLoss() + host.getCloneLoss() + host.getOxyLoss() + host.getToxLoss()
	while(all_damage > 90)
		host.adjustBruteLoss(-10)
		host.adjustFireLoss(-10)
		host.adjustCloneLoss(-10)
		host.adjustOxyLoss(-10)
		host.adjustToxLoss(-10)
		all_damage = host.getBruteLoss() + host.getFireLoss() + host.getCloneLoss() + host.getOxyLoss() + host.getToxLoss()

	host.stat = UNCONSCIOUS
	host.updatehealth()
	host.make_jittery(100)
	host.Stun(10)
	host.Weaken(10)
	host.Paralyse(10)
	host.restore_blood()
	host.fixblood()
	host.update_lying_buckled_and_verb_status()
	chemicals -= 500

/mob/living/simple_animal/borer/proc/read_mind()
	set category = "Abilities"
	set69ame = "Read69ind"
	set desc = "Extract information, languages and skills out of host's brain.69ay cause confusion and brain damage."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are69ot inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	var/list/copied_stats = list()
	if(!host.stats)
		for(var/stat_name in ALL_STATS)
			var/host_stat = host.stats.getStat(stat_name, pure=TRUE)
			var/borer_stat = stats.getStat(stat_name, pure=TRUE)
			if(host_stat > borer_stat)
				stats.setStat(stat_name, host_stat)
				copied_stats += stat_name

	var/list/copied_languages = list()
	for(var/datum/language/L in host.languages)
		if(!(L.flags & HIVEMIND) && !can_speak(L))
			add_language(L.name)
			copied_languages += L.name

	if(host.mind)
		host.mind.show_memory(src)

	var/copied_amount = length(copied_stats) + length(copied_languages)
	if(copied_amount)
		borer_add_exp((copied_amount*5))
		if(length(copied_stats))
			to_chat(src, SPAN_NOTICE("You extracted some knowledge on 69english_list(copied_stats)69."))

		if(length(copied_languages))
			to_chat(src, SPAN_NOTICE("You learned 69english_list(copied_languages)69."))

		to_chat(host, SPAN_DANGER("Your head spins, your69emories thrown in disarray!"))
		host.adjustBrainLoss(copied_amount * 4)
		host?.sanity.onPsyDamage(copied_amount * 4)

		host.make_dizzy(copied_amount * 4)
		host.confused =69ax(host.confused, copied_amount * 4)


/mob/living/simple_animal/borer/proc/write_mind()
	set category = "Abilities"
	set69ame = "Write69ind"
	set desc = "Write known skills and languages to host's brain.69ay cause confusion and brain damage."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are69ot inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	var/list/copied_stats = list()
	for(var/stat_name in ALL_STATS)
		var/host_stat = host.stats.getStat(stat_name, pure=TRUE)
		var/borer_stat = stats.getStat(stat_name, pure=TRUE)
		if(borer_stat > host_stat)
			host.stats.setStat(stat_name, borer_stat)
			copied_stats += stat_name

	var/list/copied_languages = list()
	for(var/datum/language/L in languages)
		if(!(L.flags & HIVEMIND) && !host.can_speak(L))
			host.add_language(L.name)
			copied_languages += L.name


	var/copied_amount = length(copied_stats) + length(copied_languages)
	if(copied_amount)
		if(length(copied_stats))
			to_chat(src, SPAN_NOTICE("You put some knowledge on 69english_list(copied_stats)69 into your host's69ind."))

		if(length(copied_languages))
			to_chat(src, SPAN_NOTICE("You teach your host 69english_list(copied_languages)69."))

		to_chat(host, SPAN_DANGER("Your head spins as69ew information fills your69ind!"))
		host.adjustBrainLoss(copied_amount * 2)
		host?.sanity.onPsyDamage(copied_amount * 2)

		host.make_dizzy(copied_amount * 2)
		host.confused =69ax(host.confused, copied_amount * 2)

/mob/living/simple_animal/borer/proc/say_host()
	set category = "Abilities"
	set69ame = "Say as Host"
	set desc = "Say something as host."

	if(stat)
		return

	if(!host)
		to_chat(src, "\red <B>You cannot do this without a host.</B>")
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(!host || !src) return

	var/message = input("", "say (text)") as text
	host.say(message)

/mob/living/simple_animal/borer/proc/whisper_host()
	set category = "Abilities"
	set69ame = "Whisper as Host"
	set desc = "Whisper something as host."

	if(stat)
		return

	if(!host)
		to_chat(src, "You are69ot inside a host body.")
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(!host || !src) return

	var/message = input("", "whisper (text)") as text
	host.whisper(message)

/mob/living/simple_animal/borer/proc/invisible()
	set category = "Abilities"
	set69ame = "Invisibility"
	set desc = "Become invisible for living being."

	if(src.stat)
		return

	if(world.time - used_dominate < 150)
		to_chat(src, "\red <B>You cannot use that ability again so soon.</B>")
		return

	if(host)
		to_chat(src, "\red <B>You cannot do this inside a host.</B>")
		return

	if(invisibility)
		src.invisibility = 0
		src.alpha = 255
		used_dominate = world.time
		to_chat(src, SPAN_NOTICE("You become69isible again."))
		return
	else
		src.invisibility = 26
		src.alpha = 100
		to_chat(src, SPAN_NOTICE("You become invisible for living being."))
		return

/mob/living/simple_animal/borer/proc/biograde()
	set category = "Abilities"
	set69ame = "Biograde69ision"
	set desc = "Make you see living being throug walls."

	if(src.stat)
		return

	if(host)
		to_chat(src, "\red <B>You cannot do this inside a host.</B>")
		return

	if(sight & SEE_MOBS)
		sight &= ~SEE_MOBS
		to_chat(src, SPAN_NOTICE("You cannot see living being throug walls for69ow."))
		return
	else
		sight |= SEE_MOBS
		to_chat(src, SPAN_NOTICE("You can69ow sen living being throug walls."))
		return

/mob/living/simple_animal/borer/proc/reproduce()
	set category = "Abilities"
	set69ame = "Reproduce"
	set desc = "Spawn several young."

	if(src.stat)
		return

	if(!host)
		to_chat(src, "\red <B>You cannot do this without a host.</B>")
		return

	if(chemicals >= 100)
		to_chat(host, "\red <B>Your host twitches and quivers as you rapidly excrete a larva from your sluglike body.</B>")
		visible_message("\red <B>69host.name69 heaves69iolently, expelling a rush of69omit and a wriggling, sluglike creature!</B>")
		chemicals -= 100
		has_reproduced = 1
		borer_add_exp(10)

		new /obj/effect/decal/cleanable/vomit(get_turf(host))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(host))

	else
		to_chat(src, SPAN_NOTICE("You do69ot have enough chemicals stored to reproduce."))
		return

/mob/living/simple_animal/borer/proc/commune()
	set category = "Abilities"
	set69ame = "Commune with humans"
	set desc = "Send a telepathic69essage to an unlucky recipient."

	var/list/targets = list()
	var/target =69ull
	var/text =69ull

	for(var/mob/living/carbon/H in oview())
		if(H == host || H.stat == DEAD)
			continue

		targets += H //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature",69ull,69ull) as69ull|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to human",69ull,69ull)

	text = capitalize(sanitize(text))

	if(!text) return

	var/mob/M = targets69target69

	if(isghost(M) ||69.stat == DEAD)
		to_chat(src, "Not even you can speak to the dead.")
		return

	log_say("69key_name(src)69 communed to 69key_name(M)69: 69text69")

	to_chat(M, "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your69ind: 69text69")
	if(ishuman(M))
		var/mob/living/carbon/human/H =69

		to_chat(H, SPAN_WARNING("Your69ose begins to bleed..."))
		H.drip_blood(1)
