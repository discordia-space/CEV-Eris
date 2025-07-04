/* Toys!
 * Contains:
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *		Toy crossbow
 *		Toy swords
 *		Toy bosun's whistle
 *      Toy mechs
 *		Snap pops
 *		Water flower
 *      Inflatable duck
 *		Action figures
 *		Plushies
 *		Toy cult sword
 */


/obj/item/toy
	throwforce = NONE
	throw_speed = 4
	throw_range = 20
	force = NONE

	//spawn_values
	bad_type = /obj/item/toy
	spawn_tags = SPAWN_TAG_ITEM_TOY

/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"
	preloaded_reagents = list()

/obj/item/toy/balloon/New()
	create_reagents(10)
	..()

/obj/item/toy/balloon/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/toy/balloon/afterattack(atom/A as mob|obj, mob/user, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, 10)
		to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of [A]."))
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.splash(user, reagents.total_volume)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of [O]."))
					O.reagents.trans_to_obj(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/throw_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message(SPAN_WARNING("\The [src] bursts!"),"You hear a pop and a splash.")
		src.reagents.touch_turf(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.touch(A)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				qdel(src)
	return

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "gravitational singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	spawn_tags = SPAWN_TAG_TOY_WEAPON
	var/active = 0

	attack_self(mob/user)
		src.active = !( src.active )
		if (src.active)
			to_chat(user, SPAN_NOTICE("You extend the plastic blade with a quick flick of your wrist."))
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			src.icon_state = "swordblue"
			src.item_state = "swordblue"
			src.w_class = ITEM_SIZE_BULKY
		else
			to_chat(user, SPAN_NOTICE("You push the plastic blade back down into the handle."))
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
			src.icon_state = "sword0"
			src.item_state = "sword0"
			src.w_class = ITEM_SIZE_SMALL

		update_wear_icon()

		src.add_fingerprint(user)
		return

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")
	spawn_tags = SPAWN_TAG_TOY_WEAPON

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = ITEM_SIZE_TINY

	throw_impact(atom/hit_atom)
		..()
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message(SPAN_WARNING("The [src.name] explodes!"),SPAN_WARNING("You hear a snap!"))
		playsound(src, 'sound/effects/snap.ogg', 50, 1)
		qdel(src)

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(MOVING_QUICKLY(M))
			to_chat(M, SPAN_WARNING("You step on the snap pop!"))

			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(2, 0, src)
			s.start()
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message(SPAN_WARNING("The [src.name] explodes!"),SPAN_WARNING("You hear a snap!"))
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			qdel(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/device.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	flags // TODO??
	preloaded_reagents = list("water" = 10)
	var/empty = 0

/obj/item/toy/waterflower/attack(mob/living/carbon/human/M, mob/user )
	return

/obj/item/toy/waterflower/afterattack(atom/A as mob|obj, mob/user)

	if (istype(A, /obj/item/storage/backpack ))
		return

	else if (locate (/obj/structure/table, src.loc))
		return

	else if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE("You refill your flower!"))
		return

	else if (src.reagents.total_volume < 1)
		src.empty = 1
		to_chat(user, SPAN_NOTICE("Your flower has run dry!"))
		return

	else
		src.empty = 0


		var/obj/effect/decal/D = new/obj/effect/decal/(get_turf(src))
		D.name = "water"
		D.icon = 'icons/obj/chemical.dmi'
		D.icon_state = "chempuff"
		D.create_reagents(5)
		src.reagents.trans_to_obj(D, 1)
		playsound(src.loc, 'sound/effects/spray3.ogg', 50, 1, -6)

		spawn(0)
			for(var/i=0, i<1, i++)
				step_towards(D,A)
				D.reagents.touch_turf(get_turf(D))
				for(var/atom/T in get_turf(D))
					D.reagents.touch(T)
					if(ismob(T) && T:client)
						to_chat(T:client, SPAN_WARNING("\The [user] has sprayed you with water!"))
				sleep(4)
			qdel(D)

		return

/obj/item/toy/waterflower/examine(mob/user, extra_description = "")
	if(get_dist(user, src) < 2)
		extra_description += "\icon[src] [reagents.total_volume] units of water left!"
	..(user, extra_description)

/*
 * Bosun's whistle
 */

/obj/item/toy/bosunwhistle
	name = "bosun's whistle"
	desc = "A genuine Admiral Krush Bosun's Whistle, for the aspiring ship's captain! Suitable for ages 8 and up, do not swallow."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bosunwhistle"
	var/cooldown = 0
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS

/obj/item/toy/bosunwhistle/attack_self(mob/user)
	if(cooldown < world.time - 35)
		to_chat(user, SPAN_NOTICE("You blow on [src], creating an ear-splitting noise!"))
		playsound(user, 'sound/misc/boatswain.ogg', 20, 1)
		cooldown = world.time

/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon = 'icons/obj/toy.dmi'
	icon_state = "ripleytoy"
	bad_type = /obj/item/toy/prize
	var/cooldown = 0

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	if(cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("You play with [src]."))
		playsound(user, 'sound/mechs/mechstep.ogg', 20, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user)
	if(loc == user)
		if(cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("You play with [src]."))
			playsound(user, 'sound/mechs/mechturn.ogg', 20, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mech action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-Mech action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-Mech action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-Mech action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"

/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mech action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mech action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-Mech action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mech action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-Mech action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mech action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mech action figure! Collect them all! 11/11."
	icon_state = "phazonprize"

/*
 * Action figures
 */

/obj/item/toy/figure
	name = "generic figurine"
	desc = "It seems to be almost glitched through reality."
	icon_state = "figure"
	icon = 'icons/obj/toy.dmi'
	spawn_tags = SPAWN_TAG_FIGURE
	bad_type = /obj/item/toy/figure

/obj/item/toy/figure/excelsior
	name = "\"Excelsior\" figurine"
	desc = "A curiously unbranded figurine of a Space Soviet, adorned in their iconic armor. There is still a price tag on the back of the base, six-hundred credits, people collect these things? \
	\"Ever Upward!\""
	icon_state = "excelsior"

/obj/item/toy/figure/serbian
	name = "mercenary figurine"
	desc = "A curiously unbranded figurine, the olive drab a popular pick for many independent Serbian mercenary outfits. Rocket launcher not included."
	icon_state = "serbian"

/obj/item/toy/figure/acolyte
	name = "acolyte figurine"
	desc = "Church of NeoTheology \"New Faith Life\" brand figurine of an acolyte, hooded both physically and spiritually from that which would lead them astray."
	icon_state = "acolyte"

/obj/item/toy/figure/carrion
	name = "carrion figurine"
	desc = "A curiously unbranded figurine depicting a grotesque head of flesh, the Human features seem almost underdeveloped, its skull bulging outwards, mouth agape with torn flesh. \
	Whoever made this certainly knew how to thin their paints."
	icon_state = "carrion"

/obj/item/toy/figure/roach
	name = "roach figurine"
	desc = "Upon the base is an erected \"Roachman\", its arms outstretched, with more additional roach hands besides them. This is likely the one thing most universally recognized in popular media. \
	The plaque is covered in hundreds of scratch marks, eliminating any further knowledge of it or its brand."
	icon_state = "roach"

/obj/item/toy/figure/vagabond
	name = "vagabond figurine"
	desc = "An Aster's \"Space Life\" brand figurine showcasing the form of a random deplorable, wearing one of the ship's uniforms, and an orange bandana. \
	Must of been custom-made to commemorate the Eris' doomed voyage."
	icon_state = "vagabond"

/obj/item/toy/figure/rooster
	name = "rooster figurine"
	desc = "\"Space Vice\" brand figurine, there is no further manufacturer information. It's a man wearing a rooster mask, and a varsity jacket with the letter \"B\" emblazoned on the front. \
	\"Do you like hurting other people?\""
	icon_state = "rooster"

/obj/item/toy/figure/barking_dog
	name = "barking dog figurine"
	desc = "A metal soldier with the mask of a hound stands upon the base, the plaque seems smeared with caked grime, but despite this you make out a rare double-quote. \
	\"A dog barks on its master's orders, lest its pack runs astray.\" \"Whatever the task, the grim dog mask would tell you that your life was done.\""
	icon_state = "barking_dog"

/obj/item/toy/figure/red_soldier
	name = "red soldier figurine"
	desc = "A curiously unbranded figurine of a red soldier fighting in the tides of war, their humanity hidden by a gas mask. \"Why do we fight? To win the war, of course.\""
	icon_state = "red_soldier"

/obj/item/toy/figure/metacat
	name = "meta-cat figurine"
	desc = "A curiously unbranded figurine depicting an anthropomorphic cat in a voidsuit, the small plaque claims this to be one of two. \"Always in silent pair, through distance or unlikelihood.\""
	icon_state = "metacat"

/obj/item/toy/figure/shitcurity
	name = "shitcurity officer figurine"
	desc = "An Aster's \"Space Life\" brand figurine of a classic redshirt of \"Nanotrasen's finest\". Their belly distends out into an obvious beer gut, revealing no form of manufacturer bias what-so-ever. \
	\"I joined just to kill people.\""
	icon_state = "shitcurity"

/obj/item/toy/figure/metro_patrolman
	name = "metro patrolman figurine"
	desc = "The plaque seems flaked with rust residue, \"London Metro\" brand it reads. The man wears some kind of enforcer's uniform, with the acronym \"VPP\" on their left shoulder and cap. \
	\"Abandoned for Escalation, the patrolman grumbles.\""
	icon_state = "metro_patrolman"

/*
 * Plushies
 */

//Large plushies.
/obj/structure/plushie
	name = "generic plush"
	desc = "A very generic plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ianplushie"
	anchored = FALSE
	density = TRUE
	spawn_tags = SPAWN_TAG_STRUCTURE_PLUSHIE
	bad_type = /obj/structure/plushie
	var/phrase = "I don't want to exist anymore!"

/obj/structure/plushie/attack_hand(mob/user)
	if(user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> hugs [src]!"),SPAN_NOTICE("You hug [src]!"))
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("<b>\The [user]</b> punches [src]!"),SPAN_WARNING("You punch [src]!"))
	else if (user.a_intent == I_GRAB)
		user.visible_message(SPAN_WARNING("<b>\The [user]</b> attempts to strangle [src]!"),SPAN_WARNING("You attempt to strangle [src]!"))
	else
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> pokes the [src]."),SPAN_NOTICE("You poke the [src]."))
		visible_message("[src] says, \"[phrase]\"")

/obj/structure/plushie/ian
	name = "plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	icon_state = "ianplushie"
	phrase = "Arf!"

/obj/structure/plushie/drone
	name = "plush drone"
	desc = "A plushie of a happy drone! It appears to be smiling, and has a small tag which reads \"I.H.S. Atomos Gift Shop\"."
	icon_state = "droneplushie"
	phrase = "Beep boop!"

/obj/structure/plushie/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Straight from the wilds of the Nyx frontier, now right here in your hands."
	icon_state = "carpplushie"
	phrase = "Glorf!"

/obj/structure/plushie/beepsky
	name = "plush Officer Sweepsky"
	desc = "A plushie of a popular industrious cleaning robot! If it could feel emotions, it would love you."
	icon_state = "beepskyplushie"
	phrase = "Ping!"

//Small plushies.
/obj/item/toy/plushie
	name = "generic small plush"
	desc = "A very generic small plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	bad_type = /obj/item/toy/plushie
	spawn_tags = SPAWN_TAG_PLUSHIE

/obj/item/toy/plushie/attack_self(mob/user)
	if(user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> hugs [src]!"),SPAN_NOTICE("You hug [src]!"))
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("<b>\The [user]</b> punches [src]!"),SPAN_WARNING("You punch [src]!"))
	else if (user.a_intent == I_GRAB)
		user.visible_message(SPAN_WARNING("<b>\The [user]</b> attempts to strangle [src]!"),SPAN_WARNING("You attempt to strangle [src]!"))
	else
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> pokes the [src]."),SPAN_NOTICE("You poke the [src]."))

/obj/item/toy/plushie/mouse
	name = "mouse plush"
	desc = "A plushie of a delightful mouse! What was once considered a vile rodent is now your very best friend."
	icon_state = "mouseplushie"

/obj/item/toy/plushie/kitten
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs it's way right into your heart."
	icon_state = "kittenplushie"

/obj/item/toy/plushie/lizard
	name = "lizard plush"
	desc = "A plushie of a scaly lizard!"
	icon_state = "lizardplushie"

/obj/item/toy/plushie/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has eight legs - all the better to hug you with."
	icon_state = "spiderplushie"

/obj/item/toy/plushie/fumo
	name = "fumo"
	desc = "A plushie of a....?"
	icon_state = "fumoplushie_marisa"
	spawn_blacklisted = TRUE

/obj/item/toy/plushie/fumo/astolfo
	icon_state = "fumoplushie_astolfo"

/obj/item/toy/plushie/fumo/cirno
	icon_state = "fumoplushie_cirno"

/obj/item/toy/plushie/fumo/bocchi
	icon_state = "fumoplushie_bocchi"

//Toy cult sword
/obj/item/toy/cultsword
	name = "foam sword"
	desc = "An arcane weapon (made of foam) wielded by the followers of the hit Saturday morning cartoon \"King Nursee and the Acolytes of Heroism\"."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = ITEM_SIZE_BULKY
	attack_verb = list("attacked", "slashed", "stabbed", "poked")
	spawn_tags = SPAWN_TAG_TOY_WEAPON

/obj/item/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/inventory/belt/icon.dmi'
	slot_flags = SLOT_BELT

// That one funny oinking pig.
/obj/item/toy/rubber_pig
	name = "rubber pig"
	desc = "Rubber pig that oinks when squeezed."
	icon = 'icons/obj/rubber_pig.dmi'
	icon_state = "icon"
	item_state = "rubber_pig"

	var/cooldown = 0.5 SECONDS
	var/last_used = 0
	// Oinking pig sounds
	var/oinks = list(
		'sound/items/oink1.ogg',
		'sound/items/oink2.ogg',
		'sound/items/oink3.ogg',
		'sound/items/oink4.ogg',
		'sound/items/oink5.ogg',
		'sound/items/oink6.ogg'
	)

// Oink code
/obj/item/toy/rubber_pig/proc/oink()
	if((last_used + cooldown) < world.time)
		last_used = world.time
		playsound(src, pick(oinks), 50, 1)
		return TRUE

/obj/item/toy/rubber_pig/proc/user_oink(mob/user)
	if(oink())
		user.visible_message(SPAN_NOTICE("<b>\The [user]</b> squeezes a pig. It makes a loud funny oink!"), SPAN_NOTICE("You squeeze a pig. It makes a loud funny oink!"))

// All the oink situtions
/obj/item/toy/rubber_pig/attack_self(mob/user)
	user_oink(user)

/obj/item/toy/rubber_pig/attack_hand(mob/user)
	user_oink(user)

/obj/item/toy/rubber_pig/throw_impact(atom/impact_atom)
	visible_message(SPAN_NOTICE("Rubber pig oinks, as it impacts with surface."))
	oink()

// Oinker pick up
/obj/item/toy/rubber_pig/MouseDrop(over_object, src_location, over_location)
	..()
	var/mob/living/carbon/human/user = usr
	if(istype(user) && over_object == user && in_range(src, user))
		user.put_in_active_hand(src)

/obj/item/toy/card
	name = "collectible card"
	desc = "A high-tech collectible trading card. Squeeze it in your hand to switch between the viewing and transport modes."
	icon = 'icons/obj/nft.dmi'
	icon_state = "card"
	w_class = ITEM_SIZE_TINY
	price_tag = 5
	rarity_value = 10
	spawn_tags = SPAWN_TAG_TRADING_CARD
	spawn_blacklisted = TRUE
	bad_type = /obj/item/toy/card
	var/is_small = TRUE

/obj/item/toy/card/Initialize()
	. = ..()
	transform *= 0.5
	pixel_x = rand(-8,8)
	pixel_y = rand(-8,8)

/obj/item/toy/card/attack_self(mob/user)
	if(is_small)
		transform *= 2
	else
		transform *= 0.5
	is_small = !is_small

/obj/item/toy/card/monkey
	name = "monkey card"

/obj/item/toy/card/monkey/Initialize()
	var/card = max(rand(1,18) - 10, 1)
	var/monkey = max(rand(1,14) - 10, 1)
	var/suit = max(rand(1,30) - 20, 0)
	var/helmet = max(rand(1,50) - 40, 0)
	var/hat = max(rand(1,30) - 20, 0)
	var/glasses = max(rand(1,30) - 20, 0)

	icon_state = "card-[card]"

	overlays += "monkey-[monkey]"

	price_tag *= ((card / 2) * monkey)

	if(suit)
		overlays += "suit-[suit]"
		price_tag *= 1 + (0.25 * suit)

	if(!helmet)
		if(glasses)
			overlays += "glasses-[glasses]"
			price_tag *= 1 + (0.25 * glasses)
		if(hat)
			overlays += "hat-[hat]"
			price_tag *= 2 + (0.25 * hat)
	else
		hat = 0
		glasses = 0
		overlays += "helmet-[helmet]"
		price_tag *= 4 + (0.5 * helmet)

	price_tag = round(price_tag)
	name = initial(name) + " #[card][monkey][suit][glasses][hat][helmet]"

	. = ..()

/obj/item/toy/card/iriska
	name = "iriska card"
	price_tag = 100
	rarity_value = 69

/obj/item/toy/card/iriska/Initialize()
	var/card = max(rand(1,38) - 30, 1)
	var/hat = max(rand(1,30) - 20, 0)
	var/glasses = max(rand(1,30) - 20, 0)

	icon_state = "card-[card]"

	overlays += "iriska"

	price_tag *= card

	if(glasses)
		overlays += "glasses-[glasses]"
		price_tag *= 2 + (0.25 * glasses)

	if(hat)
		if(hat == 2 || hat == 4)	// Iriska doesn't look good with 2 and 4
			hat--
		overlays += "hat-[hat]"
		price_tag *= 2 + (0.25 * hat)

	name = initial(name) + " #[card][hat][glasses]"

	. = ..()
