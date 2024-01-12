#define DEFAULT_INFESTATION_DELAY 2.5 SECONDS

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

		detach()
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

	 //non-humanoids disabled due to not working.
	if(!M || !Adjacent(M) || !iscarbon(M))
		return

	if(ishuman(M) && (!M.mind || !M.client))
		to_chat(src, SPAN_WARNING("Host's body is in a state of hibernation, you are afraid to be crushed when they roll over in their sleep!"))
		return
	if(M.has_brain_worms())
		to_chat(src, SPAN_WARNING("You cannot infest someone who is already infested!"))
		return

	if(get_active_mutation(M, MUTATION_REJECT))
		to_chat(src, SPAN_WARNING("Host's body actively rejects you."))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/external/E = H.organs_by_name[BP_HEAD]
		if(!E || E.is_stump())
			to_chat(src, SPAN_WARNING("\The [H] does not have a head!"))
			return // Causes wonky behavior, although it does work in some cases.

		if(!H.species.has_process[BP_BRAIN])
			to_chat(src, SPAN_WARNING("\The [H] does not seem to have an ear canal to breach."))
			return

		if(H.check_head_coverage() && H.head && !(H.head.canremove))
			to_chat(src, SPAN_WARNING("You cannot get through that host's protective gear."))
			return

	to_chat(M, "Something slimy begins probing at the opening of your ear canal...")
	to_chat(src, SPAN_DANGER("You slither up [M] and begin probing at their ear canal..."))

	var/infestation_delay = DEFAULT_INFESTATION_DELAY

	// It's harder for a borer to infest NTs
	if(is_neotheology_disciple(M))
		to_chat(src, SPAN_DANGER("A nanofiber mesh implant inside [M]'s head tries to cut you off on your way in. You can work around it, but it will take time."))
		infestation_delay *= 3

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.check_head_coverage())
			to_chat(src, SPAN_DANGER("That host's wearing protective gear. You can work around it, but it will take time."))
			infestation_delay *= 3

	// Borer gets host abilities before actually getting inside the host
	// Workaround for a BYOND bug: http://www.byond.com/forum/post/1833666 << We fix this in a better way
	if(!do_mob(src, M, infestation_delay))
		to_chat(src, SPAN_DANGER("As [M] moves away, you are dislodged and fall to the ground."))
		return

	to_chat(src, SPAN_NOTICE("You wiggle into [M]'s ear."))
	if(!M.stat)
		to_chat(M, SPAN_DANGER("Something disgusting and slimy wiggles into your ear!"))

	if(invisibility)
		src.invisibility = 0
		src.alpha = 255

	if(sight & SEE_MOBS)
		sight &= ~SEE_MOBS
		to_chat(src, SPAN_NOTICE("You cannot see living being through walls for now."))

	host = M
	host.status_flags |= PASSEMOTES
	update_abilities()
	spawn(1) /// Wait for abilities to update THEN move them in due to the afore-mentioned bug.
		forceMove(host)

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/I = H.random_organ_by_process(BP_BRAIN)
			if(!I) // No brain organ, so the borer moves in and replaces it permanently.
				replace_brain()
			else
				// If they're in normally, implant removal can get them out.
				var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
				head.implants += src

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

	H.verbs |= /mob/living/carbon/human/proc/commune
	H.verbs |= /mob/living/carbon/human/proc/psychic_whisper
	H.verbs |= /mob/living/carbon/proc/spawn_larvae
	H.verbs |= /mob/living/carbon/proc/talk_host

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

	if(H.stat) // > Take over a body that is always dead , die , !?!??!
		var/all_damage = H.getBruteLoss() + H.getFireLoss() + H.getOxyLoss()
		while(all_damage > 90)
			H.adjustBruteLoss(-10)
			H.adjustFireLoss(-10)
			H.adjustOxyLoss(-10)
			all_damage = H.getBruteLoss() + H.getFireLoss() + H.getOxyLoss()
		H.stat = UNCONSCIOUS
		H.updatehealth()

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
		return

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

	if(stat)
		return

	if(world.time - used_dominate < 1 MINUTE) // a one minutes cooldown.
		to_chat(src, "\red <B>You cannot use that ability again so soon. It will be ready in [(1 MINUTE - (world.time - used_dominate))/ (1 SECOND)] seconds.")
		return

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("You cannot use that ability while in vent."))
		return

	if(chemicals < 10)
		to_chat(src, SPAN_WARNING("You don't have enough chemicals!"))
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1, get_turf(src)))
		if(C == host || C.stat == DEAD)
			continue

		choices += C

	if(!choices)
		to_chat(src, SPAN_WARNING("No available creatures found in your radius."))
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to dominate?") in null|choices

	if(world.time - used_dominate < 1 MINUTE)
		to_chat(src, "\red <B>You cannot use that ability again so soon. It will be ready in [(1 MINUTE - (world.time - used_dominate))/ (1 SECOND)] seconds.")
		return

	if(!M || !Adjacent(M)) return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.wear_suit, /obj/item/clothing/suit/space))
			to_chat(src, SPAN_WARNING("You cannot use that ability on someone, who wear a space suit."))
			return

	if(M.has_brain_worms())
		to_chat(src, "You cannot paralyze someone who is already infested!")
		return

	if(invisibility)
		invisible() //removes invisibility on using paralyze
		to_chat(src, SPAN_NOTICE("You become visible again."))
	to_chat(src, SPAN_WARNING("You focus your psychic lance on [M] and freeze their limbs with a wave of terrible dread."))
	to_chat(M, SPAN_DANGER("You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing."))
	var/duration = 10 + (borer_level*2)
	M.Weaken(duration)
	M.SetStunned(duration)
	M.SetParalysis(duration)
	chemicals -= 10
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

	if(host.stat == DEAD)
		to_chat(src, SPAN_WARNING("You can't control a dead host."))
		return

	to_chat(src, SPAN_NOTICE("You begin delicately adjusting your connection to the host brain. This will take some time..."))

	spawn(30 SECONDS + (host.brainloss * 5))

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

/mob/living/simple_animal/borer/proc/jumpstart()
	set category = "Abilities"
	set name = "Revive Host"
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

	visible_message(SPAN_WARNING("With a hideous, rattling moan, [src] shudders back to life!"))


	var/all_damage = host.getBruteLoss() + host.getFireLoss() + host.getOxyLoss()
	while(all_damage > 90)
		host.adjustBruteLoss(-10)
		host.adjustFireLoss(-10)
		host.adjustOxyLoss(-10)
		all_damage = host.getBruteLoss() + host.getFireLoss() + host.getOxyLoss()

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
	if(host.stats)
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

/mob/living/simple_animal/borer/proc/say_host()
	set category = "Abilities"
	set name = "Say as Host"
	set desc = "Say something as host."

	if(stat)
		return

	if(!host)
		to_chat(src, "\red <B>You cannot do this without a host.</B>")
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	var/message = input("", "say (text)") as text
	host.say(message)

/mob/living/simple_animal/borer/proc/whisper_host()
	set category = "Abilities"
	set name = "Whisper as Host"
	set desc = "Whisper something as host."

	if(stat)
		return

	if(!host)
		to_chat(src, "You are not inside a host body.")
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	var/message = input("", "whisper (text)") as text
	host.whisper(message)

/mob/living/simple_animal/borer/proc/invisible()
	set category = "Abilities"
	set name = "Invisibility"
	set desc = "Become invisible for living being."

	if(stat)
		return

	if(world.time - used_dominate < 1 MINUTE)
		to_chat(src, "\red <B>You cannot use that ability again so soon. It will be ready in [(1 MINUTE - (world.time - used_dominate))/ (1 SECOND)] seconds.</B>")
		return

	if(host)
		to_chat(src, "\red <B>You cannot do this inside a host.</B>")
		return

	if(invisibility)
		src.invisibility = 0
		src.alpha = 255
		used_dominate = world.time
		to_chat(src, SPAN_NOTICE("You become visible again."))
		return
	else
		src.invisibility = 26
		src.alpha = 100
		to_chat(src, SPAN_NOTICE("You become invisible for living being."))
		return

/mob/living/simple_animal/borer/proc/biograde()
	set category = "Abilities"
	set name = "Biograde Vision"
	set desc = "Lets you see living beings through walls."

	if(stat)
		return

	if(host)
		to_chat(src, SPAN_WARNING("You cannot do this inside a host."))
		return

	if(sight & SEE_MOBS)
		sight &= ~SEE_MOBS
		return
	else
		sight |= SEE_MOBS
		return

/mob/living/simple_animal/borer/proc/reproduce()
	set category = "Abilities"
	set name = "Reproduce"
	set desc = "Spawn several young."

	if(stat)
		return

	if(docile)
		to_chat(src, SPAN_DANGER("You are feeling far too docile to do that."))
		return

	if(!host)
		to_chat(src, "\red <B>You cannot do this without a host.</B>")
		return
	var/reproduce_cost = (round(max_chemicals_inhost * 0.75)) // literally max chems but 75% of it
	if(chemicals >= reproduce_cost)
		to_chat(host, "\red <B>Your host twitches and quivers as you rapidly excrete a larva from your sluglike body.</B>")
		visible_message("\red <B>[host.name] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!</B>")
		has_reproduced = TRUE
		chemicals -= reproduce_cost
		if(istype(host, /mob/living/carbon/human/) && !host.isMonkey())
			borer_add_exp(25)
		else
			to_chat(src, SPAN_WARNING("You do not have anything to learn from this host. Find a human!"))

		new /obj/effect/decal/cleanable/vomit(get_turf(host))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(host))

	else
		to_chat(src, SPAN_NOTICE("You do not have enough chemicals stored to reproduce. (You need [reproduce_cost])."))
		return

/mob/living/simple_animal/borer/proc/commune()
	set category = "Abilities"
	set name = "Commune with humans"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	for(var/mob/living/carbon/H in oview())
		if(H == host || H.stat == DEAD)
			continue

		targets += H //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to human", null, null)

	text = capitalize(sanitize(text))

	if(!text) return

	var/mob/M = targets[target]

	if(M.stat == DEAD)
		to_chat(src, "Not even you can speak to the dead.")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	to_chat(M, "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		to_chat(H, SPAN_WARNING("Your nose begins to bleed..."))
		H.drip_blood(1)

#undef DEFAULT_INFESTATION_DELAY
