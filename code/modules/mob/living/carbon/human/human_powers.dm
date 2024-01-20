// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!issilicon(M) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

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

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("\red <B>[] [failed ? "tried to tackle" : "has tackled"] down []!</B>", src, T), 1)

/mob/living/carbon/human/proc/leap(mob/living/carbon/human/T)
	if(last_special > world.time)
		return
	if(!T || !src || src.stat)
		return
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
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

/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying)
		to_chat(src, "\red You cannot do that in your current state.")
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, "\red You are not grabbing anyone.")
		return

	if(G.state < GRAB_AGGRESSIVE)
		to_chat(src, "\red You must have an aggressive grab to gut your prey!")
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>\The [src]</b> rips viciously at \the [G.affecting]'s body with its claws!"))

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
				M.forceMove(loc)
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


/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Abilities"

	if(stat)
		reset_view(0)
		remoteview_target = null
		return

	// Can use ability multiple times in a row if necessary, but there is a price
	vessel.remove_reagent("blood", 50)

	var/new_facial = input("Please select facial hair color.", "Character Generation",facial_color) as color
	if(new_facial)
		facial_color = new_facial

	var/new_hair = input("Please select hair color.", "Character Generation",hair_color) as color
	if(new_hair)
		hair_color = new_hair

	var/new_eyes = input("Please select eye color.", "Character Generation",eyes_color) as color
	if(new_eyes)
		eyes_color = new_eyes
		update_eyes()

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "[35-s_tone]")  as text

	if(!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 220), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if(new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if(new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	regenerate_icons()

	visible_message("\blue \The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!", "\blue You change your appearance!", "\red Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")

/mob/living/carbon/human/proc/phaze_trough()
	set name = "Phaze"
	set category = "Abilities"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return

	// TODO: Here and in other psionic abilities - add checks for NT obelisks,
	// reality cores and whatever else could prevent use of said abilities -- KIROV

	var/original_x = pixel_x
	var/original_y = pixel_y

	var/atom/bingo
	var/turf/T = get_step(loc, dir)
	if(T.density)
		bingo = T
	else
		for(var/atom/i in T)
			if(i.density)
				bingo = i
				break

	if(bingo)
		to_chat(src, SPAN_NOTICE("You begin to phaze trough \the [bingo]"))
		var/target_y = 0
		var/target_x = 0
		switch(dir)
			if(NORTH)
				target_y = 32
			if(SOUTH)
				target_y = -32
			if(WEST)
				target_x = -32
			if(EAST)
				target_x = 32
		animate(src, pixel_x = target_x, pixel_y = target_y, time = 15 SECONDS, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)
		if(do_after(src, 15 SECONDS, bingo))
			forceMove(get_turf(bingo))

		animate(src)
		pixel_x = original_x
		pixel_y = original_y


/mob/living/carbon/human/proc/forcespeak()
	set name = "Force Speak"
	set category = "Abilities"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return

	var/list/mobs_in_view = list()
	for(var/i in mobs_in_view(7, src))
		var/mob/living/carbon/human/H = i
		if(istype(H) && !H.stat)
			mobs_in_view += H

	if(!mobs_in_view.len)
		to_chat(src, SPAN_NOTICE("There is no valid targets around."))
		return

	var/mob/living/carbon/human/H = input("", "Who do you want to speak as?") as null|mob in mobs_in_view
	if(H && istype(H))
		var/message = input("", "Say") as text|null
		if(message)
			log_admin("[key_name(usr)] forced [key_name(H)] to say: [message]")
			H.say(message)
			if(prob(70))
				to_chat(H, SPAN_WARNING("You see [src]\'s image in your head, commanding you to speak."))


/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Abilities"

	if(stat)
		reset_view(0)
		remoteview_target = null
		return

	var/list/mobs = list()
	for(var/mob/living/carbon/C in SSmobs.mob_list | SShumans.mob_list)
		mobs += C

	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in mobs
	if(isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(get_active_mutation(target, MUTATION_REMOTESAY))
		target.show_message("\blue You hear [real_name]'s voice: [say]")
	else
		target.show_message("\blue You hear a voice that seems to echo around the room: [say]")
	show_message("\blue You project your mind into [target.real_name]: [say]")
	log_say("[key_name(usr)] sent a telepathic message to [key_name(target)]: [say]")
	for(var/mob/observer/ghost/G in world)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Abilities"

	if(stat)
		remoteview_target = null
		reset_view(0)
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	if(!check_ability_cooldown(1 MINUTE))
		return

	var/list/mobs = list()

	for(var/mob/living/carbon/H in SSmobs.mob_list | SShumans.mob_list)
		if(H.ckey && H.stat == CONSCIOUS)
			mobs += H

	mobs -= src
	var/mob/target = input("", "Who do you want to project your mind to?") as mob in mobs

	if(target)
		remoteview_target = target
		reset_view(target)
		to_chat(target, SPAN_NOTICE("You feel an odd presence in the back of your mind. A lingering sense that someone is watching you..."))
	else
		remoteview_target = null
		reset_view(0)


/mob/living/carbon/human/proc/roach_pheromones()
	set name = "Release roach pheromones"
	set category = "Abilities"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return

	if(check_ability_cooldown(2 MINUTES))
		for(var/M in mobs_in_view(7, src) - src)
			if(isroach(M))
				var/mob/living/carbon/superior_animal/roach/R = M
				R.target_mob = null
				R.set_faction(faction)
				addtimer(CALLBACK(R, PROC_REF(set_faction)), 1 MINUTE)

			else if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(!H.get_breath_from_internal() && !(H.wear_mask?.item_flags & BLOCK_GAS_SMOKE_EFFECT))
					to_chat(H, "You feel disgusting smell coming from [src]")
					H.sanity.changeLevel(-20)


/mob/living/carbon/human/proc/spider_pheromones()
	set name = "Release spider pheromones"
	set category = "Abilities"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return

	if(check_ability_cooldown(2 MINUTES))
		for(var/M in mobs_in_view(7, src) - src)
			if(istype(M, /mob/living/carbon/superior_animal/giant_spider))
				var/mob/living/carbon/superior_animal/giant_spider/S = M
				S.target_mob = null
				S.set_faction(faction)
				addtimer(CALLBACK(S, PROC_REF(set_faction)), 1 MINUTE)

			else if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(!H.get_breath_from_internal() && !(H.wear_mask?.item_flags & BLOCK_GAS_SMOKE_EFFECT))
					to_chat(H, "You feel disgusting smell coming from [src]")
					H.sanity.changeLevel(-20)


/mob/living/carbon/human/proc/inner_fuhrer()
	set name = "Screech"
	set category = "Abilities"

	if(stat)
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return

	if(check_ability_cooldown(2 MINUTES))
		playsound(loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
		spawn(2)
			playsound(loc, 'sound/voice/shriek1.ogg', 100, 1, 8, 8)
		visible_message(SPAN_DANGER("[src] emits a frightening screech as you feel the ground tramble!"))
		for(var/obj/structure/burrow/B in find_nearby_burrows(src))
			B.distress(TRUE)

