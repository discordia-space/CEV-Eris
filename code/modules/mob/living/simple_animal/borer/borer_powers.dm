/mob/living/simple_animal/borer/proc/release_host()
	set category = "Abilities"
	set name = "Release Host"
	set desc = "Slither out of your host."

	if(stat)
		return

	if(!host)
		to_chat(src, "You are not inside a host body.")
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(!host || !src) return

	to_chat(src, SPAN_NOTICE("You begin disconnecting from [host]'s synapses and prodding at their internal ear canal."))

	if(!host.stat)
		to_chat(host, SPAN_WARNING("An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."))

	spawn(100)
		if(!host || stat) return

		to_chat(src, SPAN_DANGER("You wiggle out of [host]'s ear and plop to the ground."))
		if(host.mind && !host.stat)
			if(controlling)
				to_chat(host, SPAN_DANGER("As though waking from a dream, you shake off the insidious mind control of the brain worm. Your thoughts are your own again."))
			to_chat(host, SPAN_DANGER("Something slimy wiggles out of your ear and plops to the ground!"))

		detatch()
		leave_host()

/mob/living/simple_animal/borer/proc/infest()
	set category = "Abilities"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(stat)
		return

	if(host)
		to_chat(src, SPAN_WARNING("You are already within a host."))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))
		if(src.Adjacent(C))
			choices += C

	if(!choices.len)
		to_chat(src, SPAN_WARNING("There are no viable hosts nearby."))
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to infest?") in null|choices

	if(!M || !Adjacent(M)) return

	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/external/E = H.organs_by_name[BP_HEAD]
		if(!E || E.is_stump())
			to_chat(src, SPAN_WARNING("\The [H] does not have a head!"))

		if(!H.species.has_process[BP_BRAIN])
			to_chat(src, SPAN_WARNING("\The [H] does not seem to have an ear canal to breach."))
			return

		if(H.check_head_coverage())
			to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
			return

	to_chat(M, "Something slimy begins probing at the opening of your ear canal...")
	to_chat(src, SPAN_DANGER("You slither up [M] and begin probing at their ear canal..."))

	var/infestation_delay = 2.5 SECONDS

	// It's harder for a borer to infest NTs
	if(is_neotheology_disciple(M))
		to_chat(src, SPAN_DANGER("A nanofiber mesh implant inside [M]'s head tries to cut you off on your way in. You can work around it, but it will take time."))
		infestation_delay *= 3

	// Borer gets host abilities before actually getting inside the host
	// Workaround for a BYOND bug: http://www.byond.com/forum/post/1833666
	update_abilities(force_host=TRUE)

	if(!do_mob(src, M, infestation_delay))
		to_chat(src, SPAN_DANGER("As [M] moves away, you are dislodged and fall to the ground."))
		update_abilities()
		return

	to_chat(src, SPAN_NOTICE("You wiggle into [M]'s ear."))
	if(!M.stat)
		to_chat(M, SPAN_DANGER("Something disgusting and slimy wiggles into your ear!"))

	host = M
	host.status_flags |= PASSEMOTES
	forceMove(host)

	//Update their traitor status.
	/*if(host.mind && src.mind)
		var/list/L = get_player_antags(src.mind, ROLE_BORER)
		var/datum/antagonist/borer/borer
		if(L.len)
			borer = L[1]*/

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/I = H.random_organ_by_process(BP_BRAIN)
		if(!I) // No brain organ, so the borer moves in and replaces it permanently.
			replace_brain()
		else
			// If they're in normally, implant removal can get them out.
			var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
			head.implants += src

/*
/mob/living/simple_animal/borer/verb/devour_brain()
	set category = "Abilities"
	set name = "Devour Brain"
	set desc = "Take permanent control of a dead host."

	if(!host)
		to_chat(src, "You are not inside a host body.")
		return

	if(host.stat != 2)
		to_chat(src, "Your host is still alive.")
		return

	if(stat)
		to_chat(src, "You cannot do that in your current state.")

	if(docile)
		to_chat(src, "\blue You are feeling far too docile to do that.")
		return


	to_chat(src, "<span class = 'danger'>It only takes a few moments to render the dead host brain down into a nutrient-rich slurry...</span>")
	replace_brain()
*/

// BRAIN WORM ZOMBIES AAAAH.
/mob/living/simple_animal/borer/proc/replace_brain()

	var/mob/living/carbon/human/H = host

	if(!istype(host))
		to_chat(src, "This host does not have a suitable brain.")
		return

	to_chat(src, SPAN_DANGER("You settle into the empty brainpan and begin to expand, fusing inextricably with the dead flesh of [H]."))

	H.add_language(LANGUAGE_CORTICAL)

	// Remove the usual "host control" abilities
	H.verbs -= abilities_in_control

	if(host.stat == DEAD)
		H.verbs |= /mob/living/carbon/human/proc/jumpstart

	H.verbs |= /mob/living/carbon/human/proc/psychic_whisper
	H.verbs |= /mob/living/carbon/human/proc/tackle
	H.verbs |= /mob/living/carbon/proc/spawn_larvae

	if(H.client)
		H.daemonize()

	if(src.mind)
		src.mind.transfer_to(host)

	H.ChangeToHusk()

	var/obj/item/organ/internal/borer/B = new(H)
	H.internal_organs_by_efficiency[BP_BRAIN] += B
	H.internal_organs |= B

	var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
	affecting.implants -= src

	var/s2h_id = src.computer_id
	var/s2h_ip= src.lastKnownIP
	src.computer_id = null
	src.lastKnownIP = null

	if(!H.computer_id)
		H.computer_id = s2h_id

	if(!H.lastKnownIP)
		H.lastKnownIP = s2h_ip

/mob/living/simple_animal/borer/proc/secrete_chemicals()
	set category = "Abilities"
	set name = "Secrete Chemicals"
	set desc = "Push some chemicals into your host's bloodstream."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are not inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(chemicals < 50)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))

	var/list/chem_names = list()
	for(var/id in produced_reagents)
		var/datum/reagent/D = GLOB.chemical_reagents_list[id]
		chem_names[D.name] = id

	var/chem_name = input("Select a chemical to secrete.", "Chemicals") as null|anything in chem_names
	var/chem = chem_names[chem_name]

	if(!chem || chemicals < 50 || !host || controlling || !src || stat) //Sanity check.
		return

	host.reagents.add_reagent(chem, 10)
	to_chat(src, SPAN_NOTICE("You secrete some chemicals from your reservoirs. There are [host.reagents.get_reagent_amount(chem)] units of [chem_name] in host's bloodstream now."))
	chemicals -= 50

/mob/living/simple_animal/borer/proc/paralyze_victim()
	set category = "Abilities"
	set name = "Paralyze Victim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(src.stat)
		return

	if(world.time - used_dominate < 150)
		to_chat(src, "You cannot use that ability again so soon.")
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(3, get_turf(src)))
		if(C == host || C.stat == DEAD)
			continue

		choices += C

	if(world.time - used_dominate < 150)
		to_chat(src, "You cannot use that ability again so soon.")
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to dominate?") in null|choices

	if(!M || !(M in view(3, get_turf(src)))) return

	if(M.has_brain_worms())
		to_chat(src, "You cannot infest someone who is already infested!")
		return

	to_chat(src, SPAN_WARNING("You focus your psychic lance on [M] and freeze their limbs with a wave of terrible dread."))
	to_chat(M, SPAN_DANGER("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	M.Weaken(10)

	used_dominate = world.time

/mob/living/simple_animal/borer/proc/assume_control()
	set category = "Abilities"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are not inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	to_chat(src, SPAN_NOTICE("You begin delicately adjusting your connection to the host brain..."))

	spawn(100+(host.brainloss*5))

		if(!host || !src || controlling)
			return
		else

			to_chat(src, SPAN_DANGER("You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system."))
			to_chat(host, SPAN_DANGER("You feel a strange shifting sensation behind your eyes as another consciousness displaces yours."))
			host.add_language(LANGUAGE_CORTICAL)

			// host -> brain
			var/h2b_id = host.computer_id
			var/h2b_ip= host.lastKnownIP
			host.computer_id = null
			host.lastKnownIP = null

			qdel(host_brain)
			host_brain = new(src)

			host_brain.ckey = host.ckey

			host_brain.name = host.name

			if(!host_brain.computer_id)
				host_brain.computer_id = h2b_id

			if(!host_brain.lastKnownIP)
				host_brain.lastKnownIP = h2b_ip

			// self -> host
			var/s2h_id = src.computer_id
			var/s2h_ip= src.lastKnownIP
			src.computer_id = null
			src.lastKnownIP = null

			host.ckey = src.ckey

			if(!host.computer_id)
				host.computer_id = s2h_id

			if(!host.lastKnownIP)
				host.lastKnownIP = s2h_ip

			controlling = TRUE

			update_abilities()

/mob/living/carbon/human/proc/jumpstart()
	set category = "Abilities"
	set name = "Revive Host"
	set desc = "Send a jolt of electricity through your host, reviving them."

	if(stat != DEAD)
		to_chat(usr, "Your host is already alive.")
		verbs -= /mob/living/carbon/human/proc/jumpstart
		return

	verbs -= /mob/living/carbon/human/proc/jumpstart
	visible_message(SPAN_WARNING("With a hideous, rattling moan, [src] shudders back to life!"))

	rejuvenate()
	restore_blood()
	fixblood()
	update_lying_buckled_and_verb_status()


/mob/living/simple_animal/borer/proc/read_mind()
	set category = "Abilities"
	set name = "Read Mind"
	set desc = "Extract information, languages and skills out of host's brain. May cause confusion and brain damage."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are not inside a host body."))
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	var/list/copied_stats = list()
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
		if(length(copied_stats))
			to_chat(src, SPAN_NOTICE("You extracted some knowledge on [english_list(copied_stats)]."))

		if(length(copied_languages))
			to_chat(src, SPAN_NOTICE("You learned [english_list(copied_languages)]."))

		to_chat(host, SPAN_DANGER("Your head spins, your memories thrown in disarray!"))
		host.adjustBrainLoss(copied_amount * 4)
		host?.sanity.onPsyDamage(copied_amount * 4)

		host.make_dizzy(copied_amount * 4)
		host.confused = max(host.confused, copied_amount * 4)


/mob/living/simple_animal/borer/proc/write_mind()
	set category = "Abilities"
	set name = "Write Mind"
	set desc = "Write known skills and languages to host's brain. May cause confusion and brain damage."

	if(stat)
		return

	if(!host)
		to_chat(src, SPAN_WARNING("You are not inside a host body."))
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
			to_chat(src, SPAN_NOTICE("You put some knowledge on [english_list(copied_stats)] into your host's mind."))

		if(length(copied_languages))
			to_chat(src, SPAN_NOTICE("You teach your host [english_list(copied_languages)]."))

		to_chat(host, SPAN_DANGER("Your head spins as new information fills your mind!"))
		host.adjustBrainLoss(copied_amount * 2)
		host?.sanity.onPsyDamage(copied_amount * 2)

		host.make_dizzy(copied_amount * 2)
		host.confused = max(host.confused, copied_amount * 2)