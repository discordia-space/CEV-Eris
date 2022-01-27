#define BREAKDOWN_ALERT_COOLDOWN rand(45 SECONDS, 90 SECONDS)

/datum/breakdown/positive
	start_message_span = "bold69otice"
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
		"Your pain69o longer bothers you.",
		"You feel like the pain has cleared your head.",
		"You feel the pain, and you feel the gain!"
	)

/datum/breakdown/positive/stalwart/can_occur()
	return holder.owner.maxHealth - holder.owner.health > STALWART_THRESHOLD

/datum/breakdown/positive/stalwart/conclude()
	holder.owner.adjustBruteLoss(-25)
	holder.owner.adjustCloneLoss(-10)
	holder.owner.adjustFireLoss(-25)
	holder.owner.adjustOxyLoss(-45)
	holder.owner.adjustToxLoss(-25)
	holder.owner.reagents.add_reagent("tramadol", 5) // the way this works is silly as all fuck and should probably be fixed at some point
	..()



/datum/breakdown/positive/adaptation
	name = "Adaptation"
	duration = 0
	restore_sanity_post = 100

	start_messages = list(
		"You feel like your69ind has been sharpened by your experiences.",
		"You feel like you're starting to get used to this.",
		"You feel69entally prepared.",
		"You feel like you're one step ahead.",
		"You feel like you have the upper hand."
	)

/datum/breakdown/positive/adaptation/conclude()
	holder.positive_prob =69in(holder.positive_prob + 10, 100)
	holder.negative_prob =69ax(holder.negative_prob - 5, 0)
	holder.max_level =69ax(holder.max_level + 20, 0)
	..()



/datum/breakdown/positive/concentration
	name = "Absolute Concentration"
	duration = 2069INUTES

	start_messages = list(
		"You focus and feel your69ind turning inward.",
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
	duration = 1069INUTES
	restore_sanity_pre = 100

	start_messages = list(
		"You feel invincible!",
		"You are unstoppable, you are unbreakable!",
		"You feel like a GOD!",
		"You feel a rush of adrenaline in your69eins.69othing can hurt you69ow!",
		"You've learned to brush off wounds that would kill lesser beings!"
	)
	end_messages = list(
		"The last drop of adrenaline leaves your69eins. You feel like a69ormal human69ow."
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
		"Something in your69ind clicks. You feel69ore competent!",
		"You69anage to learn from past69istakes.",
		"You take in the knowledge of your past experiences.",
		"Everything69akes69ore sense69ow!"
	)

/datum/breakdown/positive/lesson/conclude()
	for(var/stat in ALL_STATS)
		holder.owner.stats.changeStat(stat, rand(5,10))
	..()



/datum/breakdown/negative/selfharm
	name = "Self-harm"
	duration = 169INUTES
	delay = 30 SECONDS
	restore_sanity_post = 70

	start_messages = list(
		"You can't take it anymore! You completely lose control!",
		"Make it stop,69ake it stop! You'd do anything to69ake it stop!",
		"Your69ind cracks under the weight of the things you've seen and felt!",
		"Your brain screams for69ercy! It's time to end it all!",
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
		var/datum/gender/G = gender_datums69holder.owner.gender69
		if(prob(50))
			var/emote = pick(list(
				"screams incoherently!",
				"bites 69G.his69 tongue and69utters under 69G.his69 breath.",
				"utters69uffled curses.",
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
					holder.owner.visible_message(SPAN_DANGER("69holder.owner69 scratches at 69G.his69 eyes!"))
					var/obj/item/organ/internal/eyes/eyes = holder.owner.random_organ_by_process(OP_EYES)
					eyes.take_damage(rand(1,2), 1)
				else
					holder.owner.visible_message(SPAN_DANGER(pick(list(
						"69holder.owner69 tries to end 69G.his6969isery!",
						"69holder.owner69 tries to peel 69G.his69 own skin off!",
						"69holder.owner69 bites 69G.his69 own limbs uncontrollably!"
					))))
					var/list/obj/item/organ/external/parts = holder.owner.get_damageable_organs()
					if(parts.len)
						holder.owner.damage_through_armor(rand(2,4), def_zone = pick(parts))

/datum/breakdown/negative/selfharm/occur()
	spawn(delay)
		++holder.owner.suppress_communication
	return ..()

/datum/breakdown/negative/selfharm/conclude()
	--holder.owner.suppress_communication
	..()



/datum/breakdown/negative/hysteric
	name = "Hysteric"
	duration = 1.569INUTES
	delay = 60 SECONDS
	restore_sanity_post = 50

	start_messages = list(
		"You get overwhelmed and start to panic!",
		"You're inconsolably terrified!",
		"You can't choke back the tears anymore!",
		"The hair on your69ape stands on end! The fear sends you into a frenzy!",
		"It's too69uch! You freak out and lose control!"
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
	duration = 169INUTES
	restore_sanity_post = 50

	start_messages = list(
		"You feel like something is speaking to you from within!",
		"You feel a69oice starting to scream in your head!",
		"You feel like your brain decided to scream at you!",
		"You feel like69oices are69arching in your69ind!",
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
	duration = 369INUTES
	var/list/image/images = list()

	start_messages = list(
		"You feel like you understand something that you shouldn't!",
		"You feel the thoughts crawling in your head!",
		"You feel like your69ind is trying to comprehend the secrets of the universe itself!",
		"You feel it. Secrets. They are all around you.",
		"You feel your tower of knowledge on course to reach the stars, with only a single brick69issing!"
	)
	end_messages = list(
		"You feel like it is gone. But will it return?"
	)

/datum/breakdown/negative/fabric/occur()
	RegisterSignal(SSdcs, COMSIG_GLOB_FABRIC_NEW, .proc/add_image)
	RegisterSignal(holder.owner, COMSIG_MOB_LOGIN, .proc/update_client_images)
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
	images |= I
	holder.owner.client?.images |= I

/datum/breakdown/negative/fabric/proc/update_client_images()
	holder.owner.client?.images |= images


/datum/breakdown/negative/spiral
	name = "Downward-spiral"
	duration = 0
	restore_sanity_post = 50

	start_messages = list(
		"You feel like there is69o point in any of this!",
		"Your brain refuses to comprehend any of this!",
		"You feel like you don't want to continue whatever you're doing!",
		"You feel like your best days are gone forever!",
		"You feel it. You know it. There is69o turning back!"
	)

/datum/breakdown/negative/spiral/conclude()
	holder.positive_prob =69ax(holder.positive_prob - 10, 0)
	holder.negative_prob =69in(holder.negative_prob + 20, 100)
	holder.max_level =69ax(holder.max_level - 20, 0)
	..()


/datum/breakdown/common/power_hungry
	name = "Power Hungry"
	duration = 1569INUTES
	insight_reward = 20
	restore_sanity_post = 80

	start_messages = list("You think this doesn’t feel real... But reality hurts! Ensure that you will feel again!")
	end_messages = list("You feel alive again.")
	var/message_time = 0
	var/messages = list("You want to receive an electric shock.",
						"How does it feel to control the power of lightning? let's find out.",
						"More,69ore,69ore,69ore you want69ore power. Take it in your hands.",
						"Electricity belongs to everyone, why does69achinery grab it?")

/datum/breakdown/common/power_hungry/can_occur()
	if(holder.owner.species.siemens_coefficient > 0)
		return TRUE
	return FALSE

/datum/breakdown/common/power_hungry/occur()
	RegisterSignal(holder.owner, COMSIG_CARBON_ELECTROCTE, .proc/check_shock)
	RegisterSignal(holder.owner, COMSIG_LIVING_STUN_EFFECT, .proc/check_shock)
	return ..()

/datum/breakdown/common/power_hungry/update()
	. = ..()
	if(!.)
		return FALSE
	if(world.time >=69essage_time)
		message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
		to_chat(holder.owner, SPAN_NOTICE(pick(messages)))

/datum/breakdown/common/power_hungry/conclude()
	UnregisterSignal(holder.owner, COMSIG_CARBON_ELECTROCTE)
	UnregisterSignal(holder.owner, COMSIG_LIVING_STUN_EFFECT)
	..()

/datum/breakdown/common/power_hungry/proc/check_shock()
	finished = TRUE

#define ACTVIEW_ONE TRUE
#define ACTVIEW_BOTH 2

/datum/breakdown/negative/glassification
	name = "Glassification"
	duration = 269INUTES
	restore_sanity_post = 40
	var/time
	var/cooldown = 20 SECONDS
	var/time_view = 1 SECONDS
	var/active_view = FALSE
	var/mob/living/carbon/human/target
	start_messages = list("You start to see through everything. Your69ind expands.")
	end_messages = list("The world has returned to69ormal ... right?")

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
		target.sanity.changeLevel(-rand(5,10)) //This phenomena will prove taxing on the69iewed regardless
		addtimer(CALLBACK(src, .proc/reset_views, TRUE), time_view)
		time = world.time + time_view

/datum/breakdown/negative/glassification/proc/reset_views()
	holder.owner.set_remoteview()
	holder.owner.remoteviewer = FALSE
	if(active_view == ACTVIEW_BOTH)
		target.set_remoteview()
		target.remoteviewer = FALSE
	target =69ull
	active_view = FALSE
	time = world.time + cooldown

/datum/breakdown/common/herald
	name = "Herald"
	restore_sanity_pre = 5
	restore_sanity_post = 45
	duration = 569INUTES
	start_messages = list("You've seen the abyss too long, and69ow forbidden knowledge haunts you.")
	end_messages = list("You feel like you've forgotten something important. But this comforts you.")
	var/message_time = 0
	var/cooldown_message = 10 SECONDS


/datum/breakdown/common/herald/update()
	. = ..()
	if(!.)
		return FALSE
	if(world.time >=69essage_time)
		message_time = world.time + cooldown_message
		var/chance = rand(1, 100)
		holder.owner.say(chance <= 50 ? "69holder.pick_69uote_20()69" : "69holder.pick_69uote_40()69")

/datum/breakdown/common/desire_for_chrome
	name = "Desire for Chrome"
	insight_reward = 30
	restore_sanity_post = 60
	start_messages = list("Flesh is weak, you are disgusted by the weakness of your own body.")
	end_messages = list("Nothing like a69echanical upgrade to feel like69ew.")


/datum/breakdown/common/desire_for_chrome/can_occur()
	for(var/obj/item/organ/external/Ex in holder.owner.organs)
		if(!BP_IS_ROBOTIC(Ex))
			return TRUE
	return FALSE

/datum/breakdown/common/desire_for_chrome/occur()
	RegisterSignal(holder.owner, COMSIG_HUMAN_ROBOTIC_MODIFICATION, .proc/check_organ)
	return ..()

/datum/breakdown/common/desire_for_chrome/conclude()
	UnregisterSignal(holder.owner, COMSIG_HUMAN_ROBOTIC_MODIFICATION)
	..()

/datum/breakdown/common/desire_for_chrome/proc/check_organ()
	finished = TRUE


/datum/breakdown/common/false_nostalgy
	name = "False69ostalgy"
	duration = 1069INUTES
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
	messages = list("Remember your last time in 69target69, those were the days",
					"You feel like you’re drawn to 69target69 because you were always happy there. Right..?",
					"When you are in 69target69 you feel like home... You want to feel like home.",
					"69target69 reminds you of the hunt.")

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
	if(world.time >=69essage_time)
		message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
		to_chat(holder.owner, SPAN_NOTICE(pick(messages)))

/datum/breakdown/common/new_heights
	name = "New Heights"
	duration = 1069INUTES
	insight_reward = 25
	restore_sanity_post = 80
	start_messages = list("This69o longer suffices. You turned stale and gray. You69eed69ore! Reach for a69ew horizon!")
	end_messages = list("You have lost the desire to go further.")
	var/message_time = 0
	var/messages = list("You want to test your endurance, what better way to do it than consuming drugs?",
						"It doesn't69atter if they judge you, they69iss out on the pleasure of drugs.",
						"Drugs are life, drugs are love, they are69ever enough.",
						"A little69ore, a little69ore, you would pay anything to consume a little69ore.")

/datum/breakdown/common/new_heights/update()
	. = ..()
	if(!.)
		return FALSE
	if(holder.owner.metabolism_effects.nsa_current >= 100)
		finished = TRUE
		conclude()
		return FALSE
	if(world.time >=69essage_time)
		message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
		to_chat(holder.owner, SPAN_NOTICE(pick(messages)))

/datum/breakdown/common/obsession
	name = "Obsession"
	insight_reward = 20
	restore_sanity_post = 70
	var/mob/living/carbon/human/target
	var/message_time = 0
	var/obsession_time = 369INUTES
	var/last_time
	var/delta_time


	end_messages = list(
		"You feel at ease again, suddenly."
	)

/datum/breakdown/common/obsession/can_occur()
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - holder.owner
	if(candidates.len)
		target = pick(candidates)
		start_messages = list("69target.name69 knows the way out. 69target.name69 is hiding something. 69target.name69 is the key! 69target.name69 is yours!")
		return TRUE
	return FALSE

/datum/breakdown/common/obsession/update()
	. = ..()
	if(!.)
		return FALSE
	if(69DELETED(target))
		to_chat(holder.owner, SPAN_WARNING("69target.name69 is lost!"))
		finished = TRUE
		conclude()
		return FALSE
	if(target in69iew(holder.owner))
		delta_time += abs(world.time - last_time)
		last_time = world.time
		holder.owner.whisper_say("69target.name69")
		if(delta_time >= obsession_time)
			finished = TRUE
			conclude()
			return FALSE
	else
		last_time = world.time
		if(world.time >=69essage_time)
			message_time = world.time + BREAKDOWN_ALERT_COOLDOWN
			var/message = pick(list("69target.name69 knows the way out.",
									"69target.name69 is hiding something.",
									"69target.name69 is the key!",
									"69target.name69 smells good.",
									"you want to be close to 69target.name69.",
									"Seeing 69target.name6969akes you happy."
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
	duration = 569INUTES
	restore_sanity_post = 50
	var/pickup_time = 0

	start_messages = list(
		"You feel the69eed to hold something that you perhaps shouldn't...",
		"You feel like others don't69alue what they have - but you on the other hand...",
		"You feel like everything should be in your possession...",
		"You feel like everything can be yours, with just the smallest effort...",
		"You feel like some things have a strong aura around them. It won't hurt to take them for a while..."
	)
	end_messages = list(
		"You feel easier about69ot stealing things69ow."
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
				holder.owner.unE69uip(holder.owner.get_inactive_hand())
				holder.owner.put_in_hands(I)
			break



/datum/breakdown/common/signs
	//name = "Signs"
	restore_sanity_post = 70
	insight_reward = 5
	var/message

	start_messages = list(
		"You feel like the fabric of reality is69isible to you...",
		"You feel that the truth is hidden somewhere, within your69ind...",
		"You feel like your69ind has spoken to you, after centuries of silence...",
		"You feel like you were blind, but69ow you see...",
		"You feel like the universe itself is speaking to you..."
	)
	end_messages = list(
		"The truth have spoken. You feel it again. The69elody of sound returns to you."
	)

/datum/breakdown/common/signs/New()
	..()
	message = "Etiam tempor orci eu lobortis elementum69ibh tellus69olestie"

/datum/breakdown/common/signs/update()
	. = ..()
	if(!.)
		return
	if(!prob(40))
		return
	var/list/words = splittext(message, " ")
	var/phrase_len = rand(1,2)
	var/phrase_pos = rand(1, words.len - phrase_len)
	to_chat(holder.owner,"...69jointext(words, " ", phrase_pos, phrase_pos + phrase_len + 1)69...")

/datum/breakdown/common/signs/occur()
	RegisterSignal(holder.owner, COMSIG_HUMAN_SAY, .proc/check_message)
	return ..()

/datum/breakdown/common/signs/conclude()
	UnregisterSignal(holder.owner, COMSIG_HUMAN_SAY)
	..()

/datum/breakdown/common/signs/proc/check_message(msg)
	if(msg ==69essage)
		finished = TRUE
