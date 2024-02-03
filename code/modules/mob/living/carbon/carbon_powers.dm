
//FILE: Borer gets powers from this one once he Assumes Control
//Brain slug proc for voluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Abilities"
	set name = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = get_brain_worms()

	if(B && B.host_brain)
		to_chat(src, "\red <B>You withdraw your probosci, releasing control of [B.host_brain]</B>")

		B.detach()

		verbs |= /mob/living/carbon/human/proc/commune
		verbs |= /mob/living/carbon/human/proc/psychic_whisper
		verbs |= /mob/living/carbon/human/proc/tackle
		verbs |= /mob/living/carbon/proc/spawn_larvae
		verbs |= /mob/living/carbon/proc/talk_host

	else
		to_chat(src, "\red <B>ERROR NO BORER OR BRAINMOB DETECTED IN THIS MOB, THIS IS A BUG !</B>")

//Brain slug proc for talking to the host.
/mob/living/carbon/proc/talk_host()
	set category = "Abilities"
	set name = "Talk to captive host"
	set desc = "Talk to your captive host."

	var/mob/living/simple_animal/borer/B = get_brain_worms()
	var/text = null

	if(!B)
		return

	if(B.host_brain.ckey)
		text = input("What would you like to say?", "Speak to captive host", null, null)
		text = capitalize(sanitize(text))
		if(!text) 
			return
		log_say("Borer said to its host [text]")

		to_chat(src, "You say to your host: [text]")
		to_chat(B.host_brain, "YOU say to yourself: [text]")

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set name = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = get_brain_worms()
	var/reproduce_cost = (round(B.max_chemicals_inhost * 0.75))
	if(!B)
		return

	if(B.chemicals >= reproduce_cost)
		to_chat(src, "\red <B>Your host twitches and quivers as you rapidly excrete a larva from your sluglike body.</B>")
		visible_message("\red <B>[src] heaves violently, expelling a rush of vomit and a wriggling, sluglike creature!</B>")
		B.chemicals -= reproduce_cost
		B.has_reproduced = 1
		if(istype(B.host, /mob/living/carbon/human/) && !B.host.isMonkey())// this is a mess but host's var grabs "[human_name] (mob/living/carbon/human/)"
			B.borer_add_exp(25)
		else
			to_chat(src, SPAN_WARNING("You do not have anything to learn from this host. Find a human!"))


		new /obj/effect/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src))

	else
		to_chat(src, "You do not have enough chemicals stored to reproduce. (You need [reproduce_cost]).")
		return