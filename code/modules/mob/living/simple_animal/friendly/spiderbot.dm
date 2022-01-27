/mob/living/simple_animal/spiderbot

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 500
	mob_size =69OB_SMALL

	var/obj/item/device/radio/borg/radio =69ull
	var/mob/living/silicon/ai/connected_ai =69ull
	var/obj/item/cell/large/cell
	var/obj/machinery/camera/camera =69ull
	var/obj/item/device/mmi/mmi =69ull
	var/list/req_access = list(access_robotics) //Access69eeded to pop out the brain.
	var/positronic

	name = "spider-bot"
	desc = "A skittering robotic friend!"
	icon = 'icons/mob/robots.dmi'
	icon_state = "spiderbot-chassis"
	icon_dead = "spiderbot-smashed"

	wander = 0

	health = 10
	maxHealth = 10
	hunger_enabled = 0

	attacktext = "shocked"
	melee_damage_lower = 1
	melee_damage_upper = 3

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	var/emagged = 0
	var/obj/item/held_item =69ull //Storage for single item they can hold.
	speed = -1                    //Spiderbots gotta go fast.
	pass_flags = PASSTABLE
	speak_emote = list("beeps","clicks","chirps")
	can_burrow = TRUE

/mob/living/simple_animal/spiderbot/New()
	..()
	add_language(LANGUAGE_COMMON)
	default_language = all_languages69LANGUAGE_COMMON69
	verbs |= /mob/living/proc/ventcrawl
	verbs |= /mob/living/proc/hide

/mob/living/simple_animal/spiderbot/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)

	if(istype(O, /obj/item/device/mmi))
		var/obj/item/device/mmi/B = O
		if(src.mmi)
			to_chat(user, SPAN_WARNING("There's already a brain in 69src69!"))
			return
		if(!B.brainmob)
			to_chat(user, SPAN_WARNING("Sticking an empty69MI into the frame would sort of defeat the purpose."))
			return
		if(!B.brainmob.key)
			var/ghost_can_reenter = 0
			if(B.brainmob.mind)
				for(var/mob/observer/ghost/G in GLOB.player_list)
					if(G.can_reenter_corpse && G.mind == B.brainmob.mind)
						ghost_can_reenter = 1
						break
			if(!ghost_can_reenter)
				to_chat(user, SPAN_NOTICE("69O69 is completely unresponsive; there's69o point."))
				return

		if(B.brainmob.stat == DEAD)
			to_chat(user, SPAN_WARNING("69O69 is dead. Sticking it into the frame would sort of defeat the purpose."))
			return

		if(jobban_isbanned(B.brainmob, "Robot"))
			to_chat(user, SPAN_WARNING("\The 69O69 does69ot seem to fit."))
			return

		to_chat(user, SPAN_NOTICE("You install \the 69O69 in \the 69src69!"))

		if(istype(O, /obj/item/device/mmi/digital))
			positronic = 1
			add_language(LANGUAGE_ROBOT)

		user.drop_item()
		src.mmi = O
		src.transfer_personality(O)

		O.loc = src
		src.update_icon()
		return 1

	if(QUALITY_WELDING in O.tool_qualities)
		if(health <69axHealth)
			if(O.use_tool(user, src, WORKTIME_FAST, QUALITY_WELDING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				health += pick(1,1,1,2,2,3)
				if(health >69axHealth)
					health =69axHealth
				add_fingerprint(user)
				src.visible_message(SPAN_NOTICE("\The 69user69 has spot-welded some of the damage to \the 69src69!"))
		else
			to_chat(user, SPAN_WARNING("\The 69src69 is undamaged!"))
		return

	else if(istype(O, /obj/item/card/id)||istype(O, /obj/item/modular_computer/pda))
		if (!mmi)
			to_chat(user, SPAN_DANGER("There's69o reason to swipe your ID - \the 69src69 has69o brain to remove."))
			return 0

		var/obj/item/card/id/id_card

		if(istype(O, /obj/item/card/id))
			id_card = O
		else
			id_card = O.GetIdCard()

		if(access_robotics in id_card.access)
			to_chat(user, SPAN_NOTICE("You swipe your access card and pop the brain out of \the 69src69."))
			eject_brain()
			if(held_item)
				held_item.loc = src.loc
				held_item =69ull
			return 1
		else
			to_chat(user, SPAN_DANGER("You swipe your card with69o effect."))
			return 0

	else
		O.attack(src, user, user.targeted_organ)

/mob/living/simple_animal/spiderbot/emag_act(var/remaining_charges,69ar/mob/user)
	if (emagged)
		to_chat(user, SPAN_WARNING("69src69 is already overloaded - better run."))
		return 0
	else
		to_chat(user, SPAN_NOTICE("You short out the security protocols and overload 69src69's cell, priming it to explode in a short time."))
		spawn(100)	to_chat(src, SPAN_DANGER("Your cell seems to be outputting a lot of power..."))
		spawn(200)	to_chat(src, SPAN_DANGER("Internal heat sensors are spiking! Something is badly wrong with your cell!"))
		spawn(300)	src.explode()

/mob/living/simple_animal/spiderbot/proc/transfer_personality(var/obj/item/device/mmi/M as obj)

		src.mind =69.brainmob.mind
		src.mind.key =69.brainmob.key
		src.ckey =69.brainmob.ckey
		src.name = "spider-bot (69M.brainmob.name69)"

/mob/living/simple_animal/spiderbot/proc/explode() //When emagged.
	src.visible_message(SPAN_DANGER("\The 69src6969akes an odd warbling69oise, fizzles, and explodes!"))
	explosion(get_turf(loc), -1, -1, 3, 5)
	eject_brain()
	death()

/mob/living/simple_animal/spiderbot/update_icon()
	. = ..()
	if(mmi)
		if(positronic)
			icon_state = "spiderbot-chassis-posi"
			icon_living = "spiderbot-chassis-posi"
		else
			icon_state = "spiderbot-chassis-mmi"
			icon_living = "spiderbot-chassis-mmi"
	else
		icon_state = "spiderbot-chassis"
		icon_living = "spiderbot-chassis"

/mob/living/simple_animal/spiderbot/proc/eject_brain()
	if(mmi)
		var/turf/T = get_turf(loc)
		if(T)
			mmi.loc = T
		if(mind)	mind.transfer_to(mmi.brainmob)
		mmi =69ull
		real_name = initial(real_name)
		name = real_name
		update_icon()
	remove_language(LANGUAGE_ROBOT)
	positronic =69ull

/mob/living/simple_animal/spiderbot/Destroy()
	eject_brain()
	. = ..()

/mob/living/simple_animal/spiderbot/New()

	radio =69ew /obj/item/device/radio/borg(src)
	camera =69ew /obj/machinery/camera(src)
	camera.c_tag = "spiderbot-69real_name69"
	camera.replace_networks(list("SS13"))

	..()

/mob/living/simple_animal/spiderbot/death()

	GLOB.living_mob_list -= src
	GLOB.dead_mob_list += src

	if(camera)
		camera.status = 0

	if (held_item) // if the spiderbot is holding an item
		held_item.loc = src.loc
		held_item =69ull

	gibs(loc,69ull,69ull, /obj/effect/gibspawner/robot) //TODO: use gib() or refactor spiderbots into synthetics.
	qdel(src)
	return

//Cannibalized from the parrot69ob. ~Zuhayr
/mob/living/simple_animal/spiderbot/verb/drop_held_item()
	set69ame = "Drop held item"
	set category = "Spiderbot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	if(!held_item)
		to_chat(usr, "\red You have69othing to drop!")
		return 0

	if(istype(held_item, /obj/item/grenade))
		visible_message(SPAN_DANGER("\The 69src69 launches \the 69held_item69!"), \
			SPAN_DANGER("You launch \the 69held_item69!"), \
			"You hear a skittering69oise and a thump!")
		var/obj/item/grenade/G = held_item
		G.loc = src.loc
		G.prime()
		held_item =69ull
		return 1

	visible_message(SPAN_NOTICE("\The 69src69 drops \the 69held_item69."), \
		SPAN_NOTICE("You drop \the 69held_item69."), \
		"You hear a skittering69oise and a soft thump.")

	held_item.loc = src.loc
	held_item =69ull
	return 1

/mob/living/simple_animal/spiderbot/verb/get_item()
	set69ame = "Pick up item"
	set category = "Spiderbot"
	set desc = "Allows you to take a69earby small item."

	if(stat)
		return -1

	if(held_item)
		to_chat(src, SPAN_WARNING("You are already holding \the 69held_item69"))
		return 1

	var/list/items = list()
	for(var/obj/item/I in69iew(1,src))
		if(I.loc != src && I.w_class <= ITEM_SIZE_SMALL && I.Adjacent(src) )
			items.Add(I)

	var/obj/selection = input("Select an item.", "Pickup") in items

	if(selection)
		for(var/obj/item/I in69iew(1, src))
			if(selection == I)
				held_item = selection
				selection.loc = src
				visible_message(SPAN_NOTICE("\The 69src69 scoops up \the 69held_item69."), \
					SPAN_NOTICE("You grab \the 69held_item69."), \
					"You hear a skittering69oise and a clink.")
				return held_item
		to_chat(src, SPAN_WARNING("\The 69selection69 is too far away."))
		return 0

	to_chat(src, SPAN_WARNING("There is69othing of interest to take."))
	return 0

/mob/living/simple_animal/spiderbot/examine(mob/user)
	..(user)
	if(src.held_item)
		to_chat(user, "It is carrying \icon69src.held_item69 \a 69src.held_item69.")

/mob/living/simple_animal/spiderbot/cannot_use_vents()
	return

/mob/living/simple_animal/spiderbot/binarycheck()
	return positronic