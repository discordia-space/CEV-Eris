/datum/breakdown/positive
	start_message_span = "bold notice"
	icon_state = "positive"
	breakdown_sound = 'sound/sanity/sane.ogg'

/datum/breakdown/negative
	start_message_span = "danger"
	restore_sanity_pre = 25
	icon_state = "negative"
	breakdown_sound = 'sound/sanity/insane.ogg'


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
				var/obj/item/organ/internal/eyes/eyes = holder.owner.internal_organs_by_name[BP_EYES]
				eyes.take_damage(rand(1,2), 1)
			else
				holder.owner.visible_message(SPAN_DANGER(pick(list(
					"[holder.owner] tries to end [G.his] misery!",
					"[holder.owner] tries to peel [G.his] own skin off!",
					"[holder.owner] bites [G.his] own limbs uncontrollably!"
				))))
				var/list/obj/item/organ/external/parts = holder.owner.get_damageable_organs()
				if(parts.len)
					holder.owner.damage_through_armor(rand(2,4), def_zone = pick(parts))

/datum/breakdown/negative/selfharm/occur()
	++holder.owner.suppress_communication
	return ..()

/datum/breakdown/negative/selfharm/conclude()
	--holder.owner.suppress_communication
	..()



/datum/breakdown/negative/hysteric
	name = "Hysteric"
	duration = 1.5 MINUTES
	restore_sanity_post = 50

	start_messages = list(
		"You get overwhelmed and start to panic!",
		"You're inconsolably terrified!",
		"You can't choke back the tears anymore!",
		"The hair on your nape stands on end! The fear sends you into a frenzy!",
		"It's too much! You freak out and lose control!"
	)
	end_messages = list(
		"You calm down as your feelings subside. You feel horribly embarassed!"
	)

/datum/breakdown/negative/hysteric/update()
	. = ..()
	if(!.)
		return
	holder.owner.Weaken(3)
	holder.owner.Stun(3)
	if(prob(50))
		holder.owner.emote("scream")
	else
		holder.owner.emote("cry")

/datum/breakdown/negative/hysteric/occur()
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
		return
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
		"You feel like there is no point in any of this!",
		"You brain refuses to comprehend any of this!",
		"You feel like you don't want to continue whatever you're doing!",
		"You feel like your best days are gone forever!",
		"You feel it. You know it. There is no turning back!"
	)

/datum/breakdown/negative/spiral/conclude()
	holder.positive_prob = max(holder.positive_prob - 10, 0)
	holder.negative_prob = min(holder.negative_prob + 20, 100)
	holder.max_level = max(holder.max_level - 20, 0)
	..()



#define OBSESSION_COOLDOWN rand(30 SECONDS, 120 SECONDS)

/datum/breakdown/common/obsession
	name = "Obsession"
	var/obj/item/target
	var/objectname
	var/message_time = 0

	start_messages = list(
		"You hear a sickening, raspy voice in your head. It requires one small task of you...",
		"Your mind is impaled with the sickening need to hold something.",
		"Your mind whispers one of its secrets to you - but you need a token to access its true treasures...",
		"You feel like the old saying is true - the key to true power is real...",
		"You feel under constant pressure, but there is a way to ease the pain..."
	)
	end_messages = list(
		"You feel at ease again, suddenly."
	)

/datum/breakdown/common/obsession/New()
	..()
	if(prob(97))
		var/list/candidates = list() //subtypesof(/obj/item/weapon/oddity)
		while(candidates.len)
			target = pick(candidates)
			if(!locate(target))
				candidates -= target
				target = null
				continue
			objectname = initial(target.name)
			break
	if(!target)
		var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - holder.owner
		if(candidates.len)
			var/mob/living/carbon/human/H = pick(candidates)
			target = pick(H.organs - H.organs_by_name[BP_CHEST])
			objectname = "[H.real_name]'s [target.name]"

/datum/breakdown/common/obsession/can_occur()
	return !!target

/datum/breakdown/common/obsession/update()
	. = ..()
	if(!.)
		return
	var/obj/item/found = FALSE
	if(ispath(target))
		found = locate(target) in holder.owner
	else
		if(QDELETED(target))
			conclude()
			return FALSE
		found = target.loc == holder.owner
	if(found)
		var/message = pick(list(
			"Your mind convulses in the ecstasy. The sacred [objectname] is now yours!",
			"You feel the warmth of the [objectname] in your head.",
			"You suffered so long to achieve greatness! The sacred [objectname] is now yours. Only yours."
		))
		to_chat(holder.owner, SPAN_NOTICE(message))
		holder.restoreLevel(70)
		conclude()
		return FALSE
	if(world.time >= message_time)
		message_time = world.time + OBSESSION_COOLDOWN
		var/message = pick(list(
			"You knew it. The [objectname] will ease your journey to the stars.",
			"You look all around, but the only thing you can see is the [objectname].",
			"Your thoughts are all about the [objectname].",
			"You imagine how you will pour your hands into the still warm [objectname].",
			"Vivid imagery of the [objectname] fills your brain.",
			"You know it. It is the key to your salvation. [capitalize(objectname)]. [capitalize(objectname)]. [capitalize(objectname)]!",
			"The voice within you demands only one thing: the [objectname].",
			"It hurts you to keep pretending that your life without the [objectname] has meaning.",
			"Your mind whispers to you with the only words in its silent throat: [objectname].",
			"You know that only salvation from your sins is [objectname]."
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
	RegisterSignal(holder.owner, COMSIG_HUMAN_SAY, .proc/check_message)
	return ..()

/datum/breakdown/common/signs/conclude()
	UnregisterSignal(holder.owner, COMSIG_HUMAN_SAY)
	..()

/datum/breakdown/common/signs/proc/check_message(msg)
	if(msg == message)
		finished = TRUE
