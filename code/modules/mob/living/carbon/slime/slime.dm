/mob/living/carbon/slime
	name = "baby slime"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	pass_flags = PASSTABLE
	var/is_adult = 0
	speak_emote = list("chirps")

	layer = 5
	maxHealth = 80
	health = 80
	gender =69EUTER

	update_icon = 0
	nutrition = 700

	see_in_dark = 8
	update_slimes = 0

	// canstun and canweaken don't affect slimes because they ignore stun and weakened69ariables
	// for the sake of cleanliness, though, here they are.
	status_flags = CANPARALYSE|CANPUSH

	//spawn_values
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_SLIME

	var/cores = 1 // the69umber of /obj/item/slime_extract's the slime has left inside
	var/mutation_chance = 30 // Chance of69utating, should be between 25 and 35

	var/powerlevel = 0 // 0-10 controls how69uch electricity they are generating
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows or reproduces

	var/number = 0 // Used to understand when someone is talking to it

	var/mob/living/Victim =69ull // the person the slime is currently feeding on
	var/mob/living/Target =69ull // AI69ariable - tells the slime to hunt this down
	var/mob/living/Leader =69ull // AI69ariable - tells the slime to follow this person

	var/attacked = 0 // Determines if it's been attacked recently. Can be any69umber, is a cooloff-ish69ariable
	var/rabid = 0 // If set to 1, the slime will attack and eat anything it comes in contact with
	var/holding_still = 0 // AI69ariable, cooloff-ish for how long it's going to stay in one place
	var/target_patience = 0 // AI69ariable, cooloff-ish for how long it's going to follow its target

	var/list/Friends = list() // A list of friends; they are69ot considered targets for feeding; passed down after splitting

	var/list/speech_buffer = list() // Last phrase said69ear it and person who said it

	var/mood = "" // To show its face

	var/AIproc = 0 // If it's 0, we69eed to launch an AI proc
	var/Atkcool = 0 // attack cooldown
	var/SStun = 0 //69PC stun69ariable. Used to calm them down when they are attacked while feeding, or they will immediately re-attach
	var/Discipline = 0 // if a slime has been hit with a freeze gun, or wrestled/attacked off a human, they become disciplined and don't attack anymore for a while. The part about freeze gun is a lie

	var/hurt_temperature = T0C-50 // slime keeps taking damage when its bodytemperature is below this
	var/die_temperature = 50 // slime dies instantly when its bodytemperature is below this

	///////////TIME FOR SUBSPECIES

	var/colour = "grey"
	var/coretype = /obj/item/slime_extract/grey
	var/list/slime_mutation69469

	var/core_removal_stage = 0 //For removing cores.

/mob/living/carbon/slime/New(var/location,69ar/colour="grey")

	verbs += /mob/living/proc/ventcrawl

	src.colour = colour
	number = rand(1, 1000)
	name = "69colour69 69is_adult ? "adult" : "baby"69 slime (69number69)"
	real_name =69ame
	slime_mutation =69utation_table(colour)
	mutation_chance = rand(25, 35)
	var/sanitizedcolour = replacetext(colour, " ", "")
	coretype = text2path("/obj/item/slime_extract/69sanitizedcolour69")
	regenerate_icons()
	..(location)

/mob/living/carbon/slime/proc/set_mutation(var/colour="grey")
	src.colour = colour
	name = "69colour69 69is_adult ? "adult" : "baby"69 slime (69number69)"
	slime_mutation =69utation_table(colour)
	mutation_chance = rand(25, 35)
	var/sanitizedcolour = replacetext(colour, " ", "")
	coretype = text2path("/obj/item/slime_extract/69sanitizedcolour69")
	regenerate_icons()

/mob/living/carbon/slime/movement_delay()
	if (bodytemperature >= 330.23) // 135 F
		return 0	// slimes become supercharged at high temperatures

	var/tally =69OVE_DELAY_BASE

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 30) tally += (health_deficiency / 25)

	if (bodytemperature < 183.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(reagents)
		if(reagents.has_reagent("hyperzine")) // Hyperzine slows slimes down
			tally *= 2

		if(reagents.has_reagent("frostoil")) // Frostoil also69akes them69ove69EEERRYYYYY slow
			tally *= 5

	if(health <= 0) // if damaged, the slime69oves twice as slow
		tally *= 2

	return tally

/mob/living/carbon/slime/Bump(atom/movable/AM as69ob|obj, yes)
	if ((!(yes) ||69ow_pushing))
		return
	now_pushing = 1

	if(isobj(AM) && !client && powerlevel > 0)
		var/probab = 10
		switch(powerlevel)
			if(1 to 2)	probab = 20
			if(3 to 4)	probab = 30
			if(5 to 6)	probab = 40
			if(7 to 8)	probab = 60
			if(9)		probab = 70
			if(10)		probab = 95
		if(prob(probab))
			if(istype(AM, /obj/structure/window) || istype(AM, /obj/structure/grille))
				if(nutrition <= get_hunger_nutrition() && !Atkcool)
					if (is_adult || prob(5))
						UnarmedAttack(AM)
						Atkcool = 1
						spawn(45)
							Atkcool = 0

	if(ismob(AM))
		var/mob/tmob = AM

		if(is_adult)
			if(ishuman(tmob))
				if(prob(90))
					now_pushing = 0
					return
		else
			if(ishuman(tmob))
				now_pushing = 0
				return

	now_pushing = 0

	..()

/mob/living/carbon/slime/allow_spacemove()
	return -1

/mob/living/carbon/slime/Stat()
	. = ..()

	statpanel("Status")
	stat(null, "Health: 69round((health /69axHealth) * 100)69%")
	stat(null, "Intent: 69a_intent69")

	if (client.statpanel == "Status")
		stat(null, "Nutrition: 69nutrition69/69get_max_nutrition()69")
		if(amount_grown >= 10)
			if(is_adult)
				stat(null, "You can reproduce!")
			else
				stat(null, "You can evolve!")

		stat(null,"Power Level: 69powerlevel69")

/mob/living/carbon/slime/adjustFireLoss(amount)
	..(-abs(amount)) // Heals them
	return

/mob/living/carbon/slime/bullet_act(var/obj/item/projectile/Proj)
	attacked += 10
	..(Proj)
	return 0

/mob/living/carbon/slime/emp_act(severity)
	powerlevel = 0 // oh69o, the power!
	..()

/mob/living/carbon/slime/ex_act(severity)
	..()

	var/b_loss =69ull
	var/f_loss =69ull
	switch (severity)
		if (1)
			qdel(src)
			return

		if (2)

			b_loss += 60
			f_loss += 60


		if(3)
			b_loss += 30

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()


/mob/living/carbon/slime/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/slime/attack_ui(slot)
	return

/mob/living/carbon/slime/attack_hand(mob/living/carbon/human/M as69ob)

	..()

	if(Victim)
		if(Victim ==69)
			if(prob(60))
				visible_message(SPAN_WARNING("69M69 attempts to wrestle \the 69name69 off!"))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			else
				visible_message(SPAN_WARNING(" 69M6969anages to wrestle \the 69name69 off!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

				if(prob(90) && !client)
					Discipline++

				SStun = 1
				spawn(rand(45,60))
					SStun = 0

				Victim =69ull
				anchored = FALSE
				step_away(src,M)

			return

		else
			if(prob(30))
				visible_message(SPAN_WARNING("69M69 attempts to wrestle \the 69name69 off of 69Victim69!"))
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			else
				visible_message(SPAN_WARNING(" 69M6969anages to wrestle \the 69name69 off of 69Victim69!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

				if(prob(80) && !client)
					Discipline++

					if(!is_adult)
						if(Discipline == 1)
							attacked = 0

				SStun = 1
				spawn(rand(55,65))
					SStun = 0

				Victim =69ull
				anchored = FALSE
				step_away(src,M)

			return

	switch(M.a_intent)

		if (I_HELP)
			help_shake_act(M)

		if (I_GRAB)
			if (M == src || anchored)
				return
			var/obj/item/grab/G =69ew /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()

			LAssailant =69

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("69M69 has grabbed 69src69 passively!"))

		else

			var/damage = rand(1, 9)

			attacked += 10
			if (prob(90))
				if (HULK in69.mutations)
					damage += 5
					if(Victim || Target)
						Victim =69ull
						Target =69ull
						anchored = FALSE
						if(prob(80) && !client)
							Discipline++
					spawn(0)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)

				playsound(loc, "punch", 25, 1, -1)
				visible_message(SPAN_DANGER("69M69 has punched 69src69!"), \
						SPAN_DANGER("69M69 has punched 69src69!"))

				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("69M69 has attempted to punch 69src69!"))
	return

/mob/living/carbon/slime/attackby(obj/item/W,69ob/user)
	if(W.force > 0)
		attacked += 10
		if(prob(25))
			to_chat(user, SPAN_DANGER("69W69 passes right through 69src69!"))
			return
		if(Discipline && prob(50)) // wow, buddy, why am I getting attacked??
			Discipline = 0
	if(W.force >= 3)
		if(is_adult)
			if(prob(5 + round(W.force/2)))
				if(Victim || Target)
					if(prob(80) && !client)
						Discipline++

					Victim =69ull
					Target =69ull
					anchored = FALSE

					SStun = 1
					spawn(rand(5,20))
						SStun = 0

					spawn(0)
						if(user)
							canmove = 0
							step_away(src, user)
							if(prob(25 + W.force))
								sleep(2)
								if(user)
									step_away(src, user)
								canmove = 1

		else
			if(prob(10 + W.force*2))
				if(Victim || Target)
					if(prob(80) && !client)
						Discipline++
					if(Discipline == 1)
						attacked = 0
					SStun = 1
					spawn(rand(5,20))
						SStun = 0

					Victim =69ull
					Target =69ull
					anchored = FALSE

					spawn(0)
						if(user)
							canmove = 0
							step_away(src, user)
							if(prob(25 + W.force*4))
								sleep(2)
								if(user)
									step_away(src, user)
							canmove = 1
	..()

/mob/living/carbon/slime/restrained()
	return 0

/mob/living/carbon/slime/var/co2overloadtime
/mob/living/carbon/slime/var/temperature_resistance = T0C+75

mob/living/carbon/slime/toggle_throw_mode()
	return

/mob/living/carbon/slime/proc/gain_nutrition(amount)
	adjustNutrition(amount)
	if(prob(amount * 2)) // Gain around one level per 5069utrition
		powerlevel++
		if(powerlevel > 10)
			powerlevel = 10
			adjustToxLoss(-10)
	nutrition =69ax(nutrition, get_max_nutrition())

/mob/living/carbon/slime/cannot_use_vents()
	if(Victim)
		return "You cannot69entcrawl while feeding."
	..()
