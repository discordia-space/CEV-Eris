#define BREAKDOWN_ALERT_COOLDOWN rand(45 SECONDS, 90 SECONDS)

/datum/breakdown/positive
	start_message_span = "bold notice"
	icon_state = "positive"
	breakdown_sound = 'sound/sanity/sane.ogg'

/datum/breakdown/negative
	start_message_span = "danger"
	restore_sanity_pre = 25
	icon_state = "negative"
	breakdown_sound = 'sound/sanity/insane.ogg'
	is_negative = TRUE

/datum/breakdown/common
	start_message_span = "danger"
	restore_sanity_pre = 25
	icon_state = "negative"
	breakdown_sound = 'sound/sanity/insane.ogg'




#define STALWART_THRESHOLD 30 // How damaged should owner be for Stalwart to be able to trigger

/datum/breakdown/positive/stalwart
	name = "Stalwart"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You endure your pain well, and emerge in bliss.",
		"You feel like you could take on the world!",
		"Your pain no longer bothers you.",
		"You feel like the pain has cleared your head.",
		"You feel the pain, and you feel the gain!"
	)

/datum/breakdown/positive/stalwart/can_occur()
	return holder.owner.maxHealth - holder.owner.health > STALWART_THRESHOLD

/datum/breakdown/positive/stalwart/conclude()
	holder.owner.adjustBruteLoss(-25)
	holder.owner.adjustFireLoss(-25)
	holder.owner.adjustOxyLoss(-45)
	holder.owner.reagents.add_reagent("tramadol", 5) // the way this works is silly as all fuck and should probably be fixed at some point
	..()



/datum/breakdown/positive/adaptation
	name = "Adaptation"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You feel like your mind has been sharpened by your experiences.",
		"You feel like you're starting to get used to this.",
		"You feel mentally prepared.",
		"You feel like you're one step ahead.",
		"You feel like you have the upper hand."
	)

/datum/breakdown/positive/adaptation/conclude()
	holder.positive_prob = min(holder.positive_prob + 10, 100)
	holder.negative_prob = max(holder.negative_prob - 5, 0)
	holder.max_level = max(holder.max_level + 20, 0)
	..()



/datum/breakdown/positive/concentration
	name = "Absolute Concentration"
	duration = 20 MINUTES

	start_messages = list(
		"You focus and feel your mind turning inward.",
		"You have taken the first step toward enlightenment.",
		"You are disconnected from the world around you.",
		"You have become iron willed.",
		"Nothing phases you anymore."
	)

/datum/breakdown/positive/concentration/New()
	..()
	restore_sanity_pre = holder.max_level

/datum/breakdown/positive/concentration/occur()
	++holder.sanity_invulnerability
	return ..()

/datum/breakdown/positive/concentration/conclude()
	--holder.sanity_invulnerability
	..()



/datum/breakdown/positive/determination
	name = "Determination"
	duration = 10 MINUTES
	restore_sanity_pre = 100

	start_messages = list(
		"You feel invincible!",
		"You are unstoppable, you are unbreakable!",
		"You feel like a GOD!",
		"You feel a rush of adrenaline in your veins. Nothing can hurt you now!",
		"You've learned to brush off wounds that would kill lesser beings!"
	)
	end_messages = list(
		"The last drop of adrenaline leaves your veins. You feel like a normal human now."
	)

/datum/breakdown/positive/determination/occur()
	++holder.owner.shock_resist
	return ..()

/datum/breakdown/positive/determination/conclude()
	--holder.owner.shock_resist
	..()



/datum/breakdown/positive/lesson
	name = "A Lesson Learnt"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You feel like you've learned from your experience.",
		"Something in your mind clicks. You feel more competent!",
		"You manage to learn from past mistakes.",
		"You take in the knowledge of your past experiences.",
		"Everything makes more sense now!"
	)

/datum/breakdown/positive/lesson/conclude()
	for(var/stat in ALL_STATS)
		holder.owner.stats.changeStat(stat, rand(5,10))
	..()



/datum/breakdown/negative/selfharm
	name = "Self-harm"
	duration = 1 MINUTES
	delay = 30 SECONDS
	restore_sanity_post = 70

	start_messages = list(
		"You can't take it anymore! You completely lose control!",
		"Make it stop, make it stop! You'd do anything to make it stop!",
		"Your mind cracks under the weight of the things you've seen and felt!",
		"Your brain screams for mercy! It's time to end it all!",
		"You can't handle the pressure anymore! Your head runs wild with thoughts of suicide!"
	)
	end_messages = list(
		"You feel the panic subside. Perhaps it's alright to live, after all?"
	)

/datum/breakdown/negative/selfharm/update()
	. = ..()
	if(!.)
		return
	if(init_update())
		var/datum/gender/G = gender_datums[holder.owner.gender]
		if(prob(50))
			var/emote = pick(list(
				"screams incoherently!",
				"bites [G.his] tongue and mutters under [G.his] breath.",
				"utters muffled curses.",
				"grumbles.",
				"screams with soulful agony!",
				"stares at the floor."
			))
			holder.owner.custom_emote(message=emote)
		else if(!holder.owner.incapacitated())
			var/obj/item/W = holder.owner.get_active_hand()
			if(W)
				W.attack(holder.owner, holder.owner, ran_zone())
			else
				var/damage_eyes = prob(40)
				if(damage_eyes)
					for(var/obj/item/protection in list(holder.owner.head, holder.owner.wear_mask, holder.owner.glasses))
						if(protection && (protection.body_parts_covered & EYES))
							damage_eyes = FALSE
							break
				if(damage_eyes)
					holder.owner.visible_message(SPAN_DANGER("[holder.owner] scratches at [G.his] eyes!"))
					var/obj/item/organ/internal/eyes/eyes = holder.owner.random_organ_by_process(OP_EYES)
					eyes.take_damage(rand(1,10), TRUE, BRUTE, TRUE, TRUE)
				else
					holder.owner.visible_message(SPAN_DANGER(pick(list(
						"[holder.owner] tries to end [G.his] misery!",
						"[holder.owner] tries to peel [G.his] own skin off!",
						"[holder.owner] bites [G.his] own limbs uncontrollably!"
					))))
					var/list/obj/item/organ/external/parts = holder.owner.get_damageable_organs()
					if(parts.len)
						holder.owner.damage_through_armor(list(ARMOR_BLUNT = list(DELEM(BRUTE, rand(2,4)))), pick(parts), src)

/datum/breakdown/negative/selfharm/occur()
	spawn(delay)
		++holder.owner.suppress_communication
	return ..()

/datum/breakdown/negative/selfharm/conclude()
	--holder.owner.suppress_communication
	..()



/datum/breakdown/negative/hysteric
	name = "Hysteric"
	duration = 1.5 MINUTES
	delay = 60 SECONDS
	restore_sanity_post = 50

	start_messages = list(
		"You get overwhelmed and start to panic!",
		"You're inconsolably terrified!",
		"You can't choke back the tears anymore!",
		"It's too much! You freak out and lose control!"
	)
	end_messages = list(
		"You calm down as your feelings subside. You feel horribly embarrassed!"
	)

/datum/breakdown/negative/hysteric/update()
	. = ..()
	if(!.)
		return FALSE
	if(init_update())
		holder.owner.Weaken(3)
		holder.owner.Stun(3)
		if(prob(50))
			holder.owner.emote("scream")
		else
			holder.owner.emote("cry")

/datum/breakdown/negative/hysteric/occur()
	spawn(delay)
		holder.owner.SetWeakened(4)
		holder.owner.SetStunned(4)
		++holder.owner.suppress_communication
	return ..()

/datum/breakdown/negative/hysteric/conclude()
	holder.owner.SetWeakened(0)
	holder.owner.SetStunned(0)
	--holder.owner.suppress_communication
	..()



/datum/breakdown/negative/delusion
	//name = "Delusion"
	duration = 1 MINUTES
	restore_sanity_post = 50

	start_messages = list(
		"You feel like something is speaking to you from within!",
		"You feel a voice starting to scream in your head!",
		"You feel like your brain decided to scream at you!",
		"You feel like voices are marching in your mind!",
		"You feel sounds warp into cacophony!"
	)
	end_messages = list(
		"You feel silence, again."
	)

/datum/breakdown/negative/delusion/update()
	. = ..()
	if(!.)
		return	FALSE
	if(prob(10))
		var/power = rand(9,27)
		holder.owner.playsound_local(holder.owner, 'sound/effects/explosionfar.ogg', 100, 1, round(power*2,1) )
		holder.owner.playsound_local(holder.owner, "explosion", 100, 1, round(power,1) )
		shake_camera(holder.owner, 2)
	if(prob(10))
		holder.owner.playsound_local(holder.owner, 'sound/effects/alert.ogg')



/datum/breakdown/negative/fabric
	name = "The Fabric"
	duration = 3 MINUTES
	var/list/image/images = list()

	start_messages = list(
		"You feel like you understand something that you shouldn't!",
		"You feel the thoughts crawling in your head!",
		"You feel like your mind is trying to comprehend the secrets of the universe itself!",
		"You feel it. Secrets. They are all around you.",
		"You feel your tower of knowledge on course to reach the stars, with only a single brick missing!"
	)
	end_messages = list(
		"You feel like it is gone. But will it return?"
	)

/datum/breakdown/negative/fabric/occur()
	RegisterSignal(SSdcs, COMSIG_GLOB_FABRIC_NEW, PROC_REF(add_image))
	RegisterSignal(holder.owner, COMSIG_MOB_LOGIN, PROC_REF(update_client_images))
	for(var/datum/component/fabric/F in GLOB.fabric_list)
		if(F.parent == holder.owner)
			continue
		add_image(F.fabric_image)
	++holder.owner.language_blackout
	return ..()

/datum/breakdown/negative/fabric/conclude()
	--holder.owner.language_blackout
	holder.owner.client?.images -= images
	UnregisterSignal(SSdcs, COMSIG_GLOB_FABRIC_NEW)
	UnregisterSignal(holder.owner, COMSIG_MOB_LOGIN)
	images.Cut()
	..()

/datum/breakdown/negative/fabric/proc/add_image(image/I)
	SIGNAL_HANDLER
	images |= I
	holder.owner.client?.images |= I

/datum/breakdown/negative/fabric/proc/update_client_images()
	SIGNAL_HANDLER
	holder.owner.client?.images |= images


/datum/breakdown/negative/spiral
	name = "Downward-spiral"
	duration = 0
	restore_sanity_post = 50

	start_messages = list(
		"You feel like there is no point in any of this!",
		"Your brain refuses to comprehend any of this!",
		"You feel like you don't want to continue whatever you're doing!",
		"You feel like your best days are gone forever!",
		"You feel it. You know it. There is no turning back!"
	)

/datum/breakdown/negative/spiral/conclude()
	holder.positive_prob = max(holder.positive_prob - 10, 0)
	holder.negative_prob = min(holder.negative_prob + 20, 100)
	holder.max_level = max(holder.max_level - 20, 0)
	..()


/datum/breakdown/common/power_hungry
	name = "Power Hungry"
	duration = 15 MINUTES
	insight_reward = 20
	restore_sanity_post = 80

	start_messages = list("You think this doesn’t feel real... But reality hurts! Ensure that you will feel again!")
	end_messages = list("You feel alive again.")
	var/message_time = 0
	var/messages = list("You want to receive an electric shock.",
						"How does it feel to control the power of lightning? let's find out.",
						"More, more, more, more you want more power. Take it in your hands.",
						"Electricity belongs to everyone, why does machinery grab it?")

/datum/breakdown/common/power_hungry/can_occur()
	if(holder.owner.species.siemens_coefficient > 0)
		return TRUE
	return FALSE

/datum/breakdown/common/power_hungry/occur()
	RegisterSignal(holder.owner, COMSIG_CARBON_ELECTROCTE, PROC_REF(check_shock))
	RegisterSignal(holder.owner, COMSIG_LIVING_STUN_EFFECT, PROC_REF(check_shock))
	return ..()

/datum/breakdown/common/power_hungry/update()
	. = ..()
	if(!.)
		return FALSE
	if(world.time >= message_time)
		message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
		to_chat(holder.owner, SPAN_NOTICE(pick(messages)))

/datum/breakdown/common/power_hungry/conclude()
	UnregisterSignal(holder.owner, COMSIG_CARBON_ELECTROCTE)
	UnregisterSignal(holder.owner, COMSIG_LIVING_STUN_EFFECT)
	..()

/datum/breakdown/common/power_hungry/proc/check_shock()
	SIGNAL_HANDLER
	finished = TRUE

#define ACTVIEW_ONE TRUE
#define ACTVIEW_BOTH 2

/datum/breakdown/negative/glassification
	name = "Glassification"
	duration = 2 MINUTES
	restore_sanity_post = 40
	var/time
	var/cooldown = 20 SECONDS
	var/time_view = 1 SECONDS
	var/active_view = FALSE
	var/mob/living/carbon/human/target
	start_messages = list("You start to see through everything. Your mind expands.")
	end_messages = list("The world has returned to normal ... right?")

/datum/breakdown/negative/glassification/can_occur()
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - holder.owner
	if(candidates.len)
		return TRUE
	return FALSE

/datum/breakdown/negative/glassification/update()
	if(world.time < time)
		return TRUE
	if(active_view) //Just in case the callback doesn't catch
		reset_views()
		return TRUE
	. = ..()
	if(!.)
		return FALSE
	var/list/targets = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - holder.owner
	if(targets.len)
		target = pick(targets)
		holder.owner.remoteviewer = TRUE
		holder.owner.set_remoteview(target)
		to_chat(holder.owner, SPAN_WARNING("It seems as if you are looking through someone else's eyes."))
		active_view = ACTVIEW_ONE
		if(target.sanity.level < 50)
			target.remoteviewer = TRUE
			target.set_remoteview(holder.owner)
			to_chat(target, SPAN_WARNING("It seems as if you are looking through someone else's eyes."))
			active_view = ACTVIEW_BOTH
		target.sanity.changeLevel(-rand(5,10)) //This phenomena will prove taxing on the viewed regardless
		addtimer(CALLBACK(src, PROC_REF(reset_views), TRUE), time_view)
		time = world.time + time_view

/datum/breakdown/negative/glassification/proc/reset_views()
	holder.owner.set_remoteview()
	holder.owner.remoteviewer = FALSE
	if(active_view == ACTVIEW_BOTH)
		target.set_remoteview()
		target.remoteviewer = FALSE
	target = null
	active_view = FALSE
	time = world.time + cooldown

/datum/breakdown/common/herald
	name = "Herald"
	restore_sanity_pre = 5
	restore_sanity_post = 45
	duration = 5 MINUTES
	start_messages = list("You've seen the abyss too long, and now forbidden knowledge haunts you.")
	end_messages = list("You feel like you've forgotten something important. But this comforts you.")
	var/message_time = 0
	var/cooldown_message = 10 SECONDS


/datum/breakdown/common/herald/update()
	. = ..()
	if(!.)
		return FALSE
	if(world.time >= message_time)
		message_time = world.time + cooldown_message
		var/chance = rand(1, 100)
		holder.owner.say(chance <= 50 ? "[holder.pick_quote_20()]" : "[holder.pick_quote_40()]")

/datum/breakdown/common/desire_for_chrome
	name = "Desire for Chrome"
	insight_reward = 30
	restore_sanity_post = 60
	start_messages = list("Flesh is weak, you are disgusted by the weakness of your own body.")
	end_messages = list("Nothing like a mechanical upgrade to feel like new.")


/datum/breakdown/common/desire_for_chrome/can_occur()
	for(var/obj/item/organ/external/Ex in holder.owner.organs)
		if(!BP_IS_ROBOTIC(Ex))
			return TRUE
	return FALSE

/datum/breakdown/common/desire_for_chrome/occur()
	RegisterSignal(holder.owner, COMSIG_HUMAN_ROBOTIC_MODIFICATION, PROC_REF(check_organ))
	return ..()

/datum/breakdown/common/desire_for_chrome/conclude()
	UnregisterSignal(holder.owner, COMSIG_HUMAN_ROBOTIC_MODIFICATION)
	..()

/datum/breakdown/common/desire_for_chrome/proc/check_organ()
	SIGNAL_HANDLER
	finished = TRUE


/datum/breakdown/common/false_nostalgy
	name = "False Nostalgy"
	duration = 10 MINUTES
	insight_reward = 10
	restore_sanity_post = 50
	var/message_time = 0
	var/area/target
	var/messages
	end_messages = list("Just like you remembered it.")

/datum/breakdown/common/false_nostalgy/occur()
	var/list/candidates = ship_areas.Copy()
	message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
	for(var/area/A in candidates)
		if(A.is_maintenance)
			candidates -= A
			continue
	target = pick(candidates)
	messages = list("Remember your last time in [target], those were the days",
					"You feel like you’re drawn to [target] because you were always happy there. Right..?",
					"When you are in [target] you feel like home... You want to feel like home.",
					"[target] reminds you of the hunt.")

	to_chat(holder.owner, SPAN_NOTICE(pick(messages)))
	return ..()

/datum/breakdown/common/false_nostalgy/update()
	. = ..()
	if(!.)
		return FALSE
	if(get_area(holder.owner) == target)
		finished = TRUE
		conclude()
		return FALSE
	if(world.time >= message_time)
		message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
		to_chat(holder.owner, SPAN_NOTICE(pick(messages)))

/datum/breakdown/common/new_heights
	name = "New Heights"
	duration = 10 MINUTES
	insight_reward = 25
	restore_sanity_post = 80
	start_messages = list("This no longer suffices. You turned stale and gray. You need more! Reach for a new horizon!")
	end_messages = list("You have lost the desire to go further.")
	var/message_time = 0
	var/messages = list("You want to test your endurance, what better way to do it than consuming drugs?",
						"It doesn't matter if they judge you, they miss out on the pleasure of drugs.",
						"Drugs are life, drugs are love, they are never enough.",
						"A little more, a little more, you would pay anything to consume a little more.")

/datum/breakdown/common/new_heights/update()
	. = ..()
	if(!.)
		return FALSE
	if(holder.owner.metabolism_effects.nsa_current >= 100)
		finished = TRUE
		conclude()
		return FALSE
	if(world.time >= message_time)
		message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
		to_chat(holder.owner, SPAN_NOTICE(pick(messages)))

/datum/breakdown/common/obsession
	name = "Obsession"
	insight_reward = 20
	restore_sanity_post = 70
	var/mob/living/carbon/human/target
	var/message_time = 0
	var/obsession_time = 3 MINUTES
	var/last_time
	var/delta_time


	end_messages = list(
		"You feel at ease again, suddenly."
	)

/datum/breakdown/common/obsession/can_occur()
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - holder.owner
	if(candidates.len)
		target = pick(candidates)
		start_messages = list("[target.name] knows the way out. [target.name] is hiding something. [target.name] is the key! [target.name] is yours!")
		return TRUE
	return FALSE

/datum/breakdown/common/obsession/update()
	. = ..()
	if(!.)
		return FALSE
	if(QDELETED(target))
		to_chat(holder.owner, SPAN_WARNING("[target.name] is lost!"))
		finished = TRUE
		conclude()
		return FALSE
	if(target in view(holder.owner))
		delta_time += abs(world.time - last_time)
		last_time = world.time
		holder.owner.whisper_say("[target.name]")
		if(delta_time >= obsession_time)
			finished = TRUE
			conclude()
			return FALSE
	else
		last_time = world.time
		if(world.time >= message_time)
			message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
			var/message = pick(list("[target.name] knows the way out.",
									"[target.name] is hiding something.",
									"[target.name] is the key!",
									"[target.name] smells good.",
									"you want to be close to [target.name].",
									"Seeing [target.name] makes you happy."
									))
			to_chat(holder.owner, SPAN_NOTICE(message))

/datum/breakdown/common/obsession/occur()
	for(var/stat in ALL_STATS)
		holder.owner.stats.addTempStat(stat, -5, INFINITY, "Obsession")
	return ..()

/datum/breakdown/common/obsession/conclude()
	for(var/stat in ALL_STATS)
		holder.owner.stats.removeTempStat(stat, "Obsession")
	..()

#define KLEPTOMANIA_COOLDOWN rand(30 SECONDS, 60 SECONDS)

/datum/breakdown/common/kleptomania
	name = "Kleptomania"
	duration = 5 MINUTES
	restore_sanity_post = 50
	var/pickup_time = 0

	start_messages = list(
		"You feel the need to hold something that you perhaps shouldn't...",
		"You feel like others don't value what they have - but you on the other hand...",
		"You feel like everything should be in your possession...",
		"You feel like everything can be yours, with just the smallest effort...",
		"You feel like some things have a strong aura around them. It won't hurt to take them for a while..."
	)
	end_messages = list(
		"You feel easier about not stealing things now."
	)

/datum/breakdown/common/kleptomania/update()
	. = ..()
	if(!. || holder.owner.incapacitated())
		return
	if(world.time >= pickup_time)
		pickup_time = world.time + KLEPTOMANIA_COOLDOWN
		var/list/obj/item/candidates = oview(1, holder.owner)
		while(candidates.len)
			var/obj/item/I = pick(candidates)
			if(!istype(I) || I.anchored || !I.Adjacent(holder.owner) || !I.pre_pickup(holder.owner))
				candidates -= I
				continue
			if(!holder.owner.put_in_hands(I) && prob(50))
				holder.owner.unEquip(holder.owner.get_inactive_hand())
				holder.owner.put_in_hands(I)
			break



/datum/breakdown/common/signs
	//name = "Signs"
	restore_sanity_post = 70
	insight_reward = 5
	var/message

	start_messages = list(
		"You feel like the fabric of reality is visible to you...",
		"You feel that the truth is hidden somewhere, within your mind...",
		"You feel like your mind has spoken to you, after centuries of silence...",
		"You feel like you were blind, but now you see...",
		"You feel like the universe itself is speaking to you..."
	)
	end_messages = list(
		"The truth have spoken. You feel it again. The melody of sound returns to you."
	)

/datum/breakdown/common/signs/New()
	..()
	message = "Etiam tempor orci eu lobortis elementum nibh tellus molestie"

/datum/breakdown/common/signs/update()
	. = ..()
	if(!.)
		return
	if(!prob(40))
		return
	var/list/words = splittext(message, " ")
	var/phrase_len = rand(1,2)
	var/phrase_pos = rand(1, words.len - phrase_len)
	to_chat(holder.owner,"...[jointext(words, " ", phrase_pos, phrase_pos + phrase_len + 1)]...")

/datum/breakdown/common/signs/occur()
	RegisterSignal(holder.owner, COMSIG_HUMAN_SAY, PROC_REF(check_message))
	return ..()

/datum/breakdown/common/signs/conclude()
	UnregisterSignal(holder.owner, COMSIG_HUMAN_SAY)
	..()

/datum/breakdown/common/signs/proc/check_message(msg)
	SIGNAL_HANDLER
	if(msg == message)
		finished = TRUE
