// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z


/mob/living/carbon/human/proc/leap(mob/living/carbon/human/T)
	if(last_special > world.time)
		return
	if(!T || !src || src.stat)
		return
	if(stat || hasStatusEffect(T, SE_PARALYZED) || hasStatusEffect(T, SE_STUNNED) || hasStatusEffect(T, SE_WEAKENED) || lying || restrained() || buckled)
		to_chat(src, "You cannot lunge in your current state.")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	mob_playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, SPAN_WARNING("You miss!"))
		return

	src.visible_message(SPAN_WARNING("<b>\The [src]</b> lunges at [T]!"))

	var/obj/item/grab/G = new(src,T)
	src.put_in_hands(G)
	G.state = GRAB_PASSIVE
	G.synch()
	G.Process()


/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(isghost(M) || M.stat == DEAD)
		to_chat(src, "Not even a [src.species.name] can speak to the dead.")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	to_chat(M, "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return

		to_chat(H, SPAN_WARNING("Your nose begins to bleed..."))
		H.drip_blood(1)


/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.loc = loc
		src.visible_message("\red <B>[src] hurls out the contents of their stomach!</B>")
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, "\green You hear a strange, alien voice in your head... \italic [msg]")
		to_chat(src, "\green You said: \"[msg]\" to [M]")
	return
