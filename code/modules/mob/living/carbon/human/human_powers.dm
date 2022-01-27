// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set69ame = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in69iew(1,src))
		if(!issilicon(M) && Adjacent(M))
			choices +=69
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as69ull|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot tackle in your current state.")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	mob_playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in69iewers(src,69ull))
		if ((O.client && !( O.blinded )))
			O.show_message(text("\red <B>6969 69failed ? "tried to tackle" : "has tackled"69 down 6969!</B>", src, T), 1)

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set69ame = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in69iew(6,src))
		if(!issilicon(M))
			choices +=69
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as69ull|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 4) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	src.visible_message(SPAN_DANGER("\The 69src69 leaps at 69T69!"))
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	mob_playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, SPAN_WARNING("You69iss!"))
		return

	T.Weaken(3)

	// Pariahs are69ot good at leaping. This is snowflakey, pls fix.
	if(species.name == "Vox Pariah")
		src.Weaken(5)
		return

	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			to_chat(src, SPAN_DANGER("You69eed to have one hand free to grab someone."))
			return
		else
			use_hand = "right"

	src.visible_message(SPAN_WARNING("<b>\The 69src69</b> seizes 69T69 aggressively!"))

	var/obj/item/grab/G =69ew(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set69ame = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, "\red You cannot do that in your current state.")
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, "\red You are69ot grabbing anyone.")
		return

	if(G.state < GRAB_AGGRESSIVE)
		to_chat(src, "\red You69ust have an aggressive grab to gut your prey!")
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>\The 69src69</b> rips69iciously at \the 69G.affecting69's body with its claws!"))

	if(ishuman(G.affecting))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib()
	else
		var/mob/living/M = G.affecting
		if(!istype(M)) return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib()

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set69ame = "Commune with creature"
	set desc = "Send a telepathic69essage to an unlucky recipient."

	var/list/targets = list()
	var/target =69ull
	var/text =69ull

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature",69ull,69ull) as69ull|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature",69ull,69ull)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets69target69

	if(isghost(M) ||69.stat == DEAD)
		to_chat(src, "Not even a 69src.species.name69 can speak to the dead.")
		return

	log_say("69key_name(src)69 communed to 69key_name(M)69: 69text69")

	to_chat(M, "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your69ind: 69text69")
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		if(H.species.name == src.species.name)
			return

		to_chat(H, SPAN_WARNING("Your69ose begins to bleed..."))
		H.drip_blood(1)


/mob/living/carbon/human/proc/regurgitate()
	set69ame = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.loc = loc
		src.visible_message("\red <B>69src69 hurls out the contents of their stomach!</B>")
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as69ob in oview())
	set69ame = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: 69key_name(src)69->69M.key69 : 69msg69")
		to_chat(M, "\green You hear a strange, alien69oice in your head... \italic 69msg69")
		to_chat(src, "\green You said: \"69msg69\" to 69M69")
	return
