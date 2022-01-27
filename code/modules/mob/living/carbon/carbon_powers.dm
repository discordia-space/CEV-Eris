//Brain slug proc for69oluntary removal of control.
/mob/living/carbon/proc/release_control()

	set category = "Abilities"
	set69ame = "Release Control"
	set desc = "Release control of your host's body."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(B && B.host_brain)
		to_chat(src, "\red <B>You withdraw your probosci, releasing control of 69B.host_brain69</B>")

		B.detatch()

		verbs |= /mob/living/carbon/human/proc/commune
		verbs |= /mob/living/carbon/human/proc/psychic_whisper
		verbs |= /mob/living/carbon/human/proc/tackle
		verbs |= /mob/living/carbon/proc/spawn_larvae
		verbs |= /mob/living/carbon/proc/talk_host

	else
		to_chat(src, "\red <B>ERROR69O BORER OR BRAINMOB DETECTED IN THIS69OB, THIS IS A BUG !</B>")

//Brain slug proc for talking to the host.
/mob/living/carbon/proc/talk_host()
	set category = "Abilities"
	set69ame = "Talk to captive host"
	set desc = "Talk to your captive host."

	var/mob/living/simple_animal/borer/B = has_brain_worms()
	var/text =69ull

	if(!B)
		return

	if(B.host_brain.ckey)
		text = input("What would you like to say?", "Speak to captive host",69ull,69ull)
		text = capitalize(sanitize(text))
		if(!text) 
			return
		log_say("Borer said to its host 69text69")

		to_chat(src, "You say to your host: 69text69")
		to_chat(B.host_brain, "YOU say to yourself: 69text69")

/mob/living/carbon/proc/spawn_larvae()
	set category = "Abilities"
	set69ame = "Reproduce"
	set desc = "Spawn several young."

	var/mob/living/simple_animal/borer/B = has_brain_worms()

	if(!B)
		return

	if(B.chemicals >= 100)
		to_chat(src, "\red <B>Your host twitches and quivers as you rapidly excrete a larva from your sluglike body.</B>")
		visible_message("\red <B>69src69 heaves69iolently, expelling a rush of69omit and a wriggling, sluglike creature!</B>")
		B.chemicals -= 100
		B.has_reproduced = 1
		B.borer_add_exp(10)

		new /obj/effect/decal/cleanable/vomit(get_turf(src))
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		new /mob/living/simple_animal/borer(get_turf(src))

	else
		to_chat(src, "You do69ot have enough chemicals stored to reproduce.")
		return