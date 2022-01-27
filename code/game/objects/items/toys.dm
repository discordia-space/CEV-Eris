/* Toys!
 * Contains:
 *		Balloons
 *		Fake telebeacon
 *		Fake sin69ularity
 *		Toy crossbow
 *		Toy swords
 *		Toy bosun's whistle
 *      Toy69echs
 *		Snap pops
 *		Water flower
 *      Inflatable duck
 *		Action fi69ures
 *		Plushies
 *		Toy cult sword
 */


/obj/item/toy
	throwforce = NONE
	throw_speed = 4
	throw_ran69e = 20
	force = NONE

	//spawn_values
	bad_type = /obj/item/toy
	spawn_ta69s = SPAWN_TA69_ITEM_TOY

/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothin69 in it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"
	preloaded_rea69ents = list()

/obj/item/toy/balloon/New()
	create_rea69ents(10)
	..()

/obj/item/toy/balloon/attack(mob/livin69/carbon/human/M,69ob/user)
	return

/obj/item/toy/balloon/afterattack(atom/A as69ob|obj,69ob/user, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/rea69ent_dispensers/watertank) && 69et_dist(src,A) <= 1)
		A.rea69ents.trans_to_obj(src, 10)
		to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of 69A69."))
		src.desc = "A translucent balloon with some form of li69uid sloshin69 around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O,69ob/user)
	if(istype(O, /obj/item/rea69ent_containers/69lass))
		if(O.rea69ents)
			if(O.rea69ents.total_volume < 1)
				to_chat(user, "The 69O69 is empty.")
			else if(O.rea69ents.total_volume >= 1)
				if(O.rea69ents.has_rea69ent("pacid", 1))
					to_chat(user, "The acid chews throu69h the balloon!")
					O.rea69ents.splash(user, rea69ents.total_volume)
					69del(src)
				else
					src.desc = "A translucent balloon with some form of li69uid sloshin69 around in it."
					to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of 69O69."))
					O.rea69ents.trans_to_obj(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/throw_impact(atom/hit_atom)
	if(src.rea69ents.total_volume >= 1)
		src.visible_messa69e(SPAN_WARNIN69("\The 69src69 bursts!"),"You hear a pop and a splash.")
		src.rea69ents.touch_turf(69et_turf(hit_atom))
		for(var/atom/A in 69et_turf(hit_atom))
			src.rea69ents.touch(A)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				69del(src)
	return

/obj/item/toy/balloon/update_icon()
	if(src.rea69ents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy 69ame"
	desc = "Blink.  Blink.  Blink. A69es 8 and up."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "si69naler"

/*
 * Fake sin69ularity
 */
/obj/item/toy/spinnin69toy
	name = "69ravitational sin69ularity"
	desc = "\"Sin69ulo\" brand spinnin69 toy."
	icon = 'icons/obj/sin69ularity.dmi'
	icon_state = "sin69ularity_s1"

/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by69any overactive children. A69es 8 and up."
	icon = 'icons/obj/69uns/ener69y.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	item_icons = list(
		icon_l_hand = 'icons/mob/items/lefthand_69uns.dmi',
		icon_r_hand = 'icons/mob/items/ri69hthand_69uns.dmi',
		)
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	spawn_ta69s = SPAWN_TA69_TOY_WEAPON
	var/bullets = 5

	examine(mob/user)
		if(..(user, 2) && bullets)
			to_chat(user, SPAN_NOTICE("It is loaded with 69bullets69 foam darts!"))

	attackby(obj/item/I as obj,69ob/user)
		if(istype(I, /obj/item/toy/ammo/crossbow))
			if(bullets <= 4)
				user.drop_item()
				69del(I)
				bullets++
				to_chat(user, SPAN_NOTICE("You load the foam dart into the crossbow."))
			else
				to_chat(usr, SPAN_WARNIN69("It's already fully loaded."))


	afterattack(atom/tar69et as69ob|obj|turf|area,69ob/user, fla69)
		if(!isturf(tar69et.loc) || tar69et == user) return
		if(fla69) return

		if (locate (/obj/structure/table, src.loc))
			return
		else if (bullets)
			var/turf/tr69 = 69et_turf(tar69et)
			var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(69et_turf(src))
			bullets--
			D.icon_state = "foamdart"
			D.name = "foam dart"
			playsound(user.loc, 'sound/items/syrin69eproj.o6969', 50, 1)

			for(var/i=0, i<6, i++)
				if (D)
					if(D.loc == tr69) break
					step_towards(D,tr69)

					for(var/mob/livin69/M in D.loc)
						if(!islivin69(M))
							continue
						if(M == user)
							continue
						for(var/mob/O in69iewers(world.view, D))
							O.show_messa69e(SPAN_WARNIN69("\The 69M69 was hit by the foam dart!"), 1)
						new /obj/item/toy/ammo/crossbow(M.loc)
						69del(D)
						return

					for(var/atom/A in D.loc)
						if(A == user) continue
						if(A.density)
							new /obj/item/toy/ammo/crossbow(A.loc)
							69del(D)

				sleep(1)

			spawn(10)
				if(D)
					new /obj/item/toy/ammo/crossbow(D.loc)
					69del(D)

			return
		else if (bullets == 0)
			user.Weaken(5)
			for(var/mob/O in69iewers(world.view, user))
				O.show_messa69e(SPAN_WARNIN69("\The 69user69 realized they were out of ammo and startin69 scroun69in69 for some!"), 1)


	attack(mob/M as69ob,69ob/user)
		src.add_fin69erprint(user)

// ******* Check

		if (src.bullets > 0 &&69.lyin69)

			for(var/mob/O in69iewers(M, null))
				if(O.client)
					O.show_messa69e(SPAN_DAN69ER("\The 69user69 casually lines up a shot with 69M69's head and pulls the tri6969er!"), 1, SPAN_WARNIN69("You hear the sound of foam a69ainst skull"), 2)
					O.show_messa69e(SPAN_WARNIN69("\The 69M69 was hit in the head by the foam dart!"), 1)

			playsound(user.loc, 'sound/items/syrin69eproj.o6969', 50, 1)
			new /obj/item/toy/ammo/crossbow(M.loc)
			src.bullets--
		else if (M.lyin69 && src.bullets == 0)
			for(var/mob/O in69iewers(M, null))
				if (O.client)
					O.show_messa69e(SPAN_DAN69ER("\The 69user69 casually lines up a shot with 69M69's head, pulls the tri6969er, then realizes they are out of ammo and drops to the floor in search of some!"), 1, SPAN_WARNIN69("You hear someone fall"), 2)
			user.Weaken(5)
		return

/obj/item/toy/ammo/crossbow
	name = "foam dart"
	desc = "It's nerf or nothin69! A69es 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	w_class = ITEM_SIZE_TINY
	slot_fla69s = SLOT_EARS

/obj/effect/foam_dart_dummy
	name = "foam dart"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	anchored = TRUE
	density = FALSE


/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an ener69y sword. Realistic sounds! A69es 8 and up."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	spawn_ta69s = SPAWN_TA69_TOY_WEAPON
	var/active = 0

	attack_self(mob/user)
		src.active = !( src.active )
		if (src.active)
			to_chat(user, SPAN_NOTICE("You extend the plastic blade with a 69uick flick of your wrist."))
			playsound(user, 'sound/weapons/saberon.o6969', 50, 1)
			src.icon_state = "swordblue"
			src.item_state = "swordblue"
			src.w_class = ITEM_SIZE_BULKY
		else
			to_chat(user, SPAN_NOTICE("You push the plastic blade back down into the handle."))
			playsound(user, 'sound/weapons/saberoff.o6969', 50, 1)
			src.icon_state = "sword0"
			src.item_state = "sword0"
			src.w_class = ITEM_SIZE_SMALL

		update_wear_icon()

		src.add_fin69erprint(user)
		return

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	fla69s = CONDUCT
	slot_fla69s = SLOT_BELT | SLOT_BACK
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")
	spawn_ta69s = SPAWN_TA69_TOY_WEAPON

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
		src.visible_messa69e(SPAN_WARNIN69("The 69src.name69 explodes!"),SPAN_WARNIN69("You hear a snap!"))
		playsound(src, 'sound/effects/snap.o6969', 50, 1)
		69del(src)

/obj/item/toy/snappop/Crossed(H as69ob|obj)
	if((ishuman(H))) //i 69uess carp and shit shouldn't set them off
		var/mob/livin69/carbon/M = H
		if(MOVIN69_69UICKLY(M))
			to_chat(M, SPAN_WARNIN69("You step on the snap pop!"))

			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(2, 0, src)
			s.start()
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_messa69e(SPAN_WARNIN69("The 69src.name69 explodes!"),SPAN_WARNIN69("You hear a snap!"))
			playsound(src, 'sound/effects/snap.o6969', 50, 1)
			69del(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "water flower"
	desc = "A seemin69ly innocent sunflower...with a twist."
	icon = 'icons/obj/device.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	fla69s // TODO??
	preloaded_rea69ents = list("water" = 10)
	var/empty = 0

/obj/item/toy/waterflower/attack(mob/livin69/carbon/human/M,69ob/user )
	return

/obj/item/toy/waterflower/afterattack(atom/A as69ob|obj,69ob/user)

	if (istype(A, /obj/item/stora69e/backpack ))
		return

	else if (locate (/obj/structure/table, src.loc))
		return

	else if (istype(A, /obj/structure/rea69ent_dispensers/watertank) && 69et_dist(src,A) <= 1)
		A.rea69ents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE("You refill your flower!"))
		return

	else if (src.rea69ents.total_volume < 1)
		src.empty = 1
		to_chat(user, SPAN_NOTICE("Your flower has run dry!"))
		return

	else
		src.empty = 0


		var/obj/effect/decal/D = new/obj/effect/decal/(69et_turf(src))
		D.name = "water"
		D.icon = 'icons/obj/chemical.dmi'
		D.icon_state = "chempuff"
		D.create_rea69ents(5)
		src.rea69ents.trans_to_obj(D, 1)
		playsound(src.loc, 'sound/effects/spray3.o6969', 50, 1, -6)

		spawn(0)
			for(var/i=0, i<1, i++)
				step_towards(D,A)
				D.rea69ents.touch_turf(69et_turf(D))
				for(var/atom/T in 69et_turf(D))
					D.rea69ents.touch(T)
					if(ismob(T) && T:client)
						to_chat(T:client, SPAN_WARNIN69("\The 69user69 has sprayed you with water!"))
				sleep(4)
			69del(D)

		return

/obj/item/toy/waterflower/examine(mob/user)
	if(..(user, 0))
		to_chat(user, text("\icon6969 6969 units of water left!", src, src.rea69ents.total_volume))

/*
 * Bosun's whistle
 */

/obj/item/toy/bosunwhistle
	name = "bosun's whistle"
	desc = "A 69enuine Admiral Krush Bosun's Whistle, for the aspirin69 ship's captain! Suitable for a69es 8 and up, do not swallow."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bosunwhistle"
	var/cooldown = 0
	w_class = ITEM_SIZE_TINY
	slot_fla69s = SLOT_EARS

/obj/item/toy/bosunwhistle/attack_self(mob/user)
	if(cooldown < world.time - 35)
		to_chat(user, SPAN_NOTICE("You blow on 69src69, creatin69 an ear-splittin69 noise!"))
		playsound(user, 'sound/misc/boatswain.o6969', 20, 1)
		cooldown = world.time

/*
 *69ech prizes
 */
/obj/item/toy/prize
	icon = 'icons/obj/toy.dmi'
	icon_state = "ripleytoy"
	bad_type = /obj/item/toy/prize
	var/cooldown = 0

//all credit to skasi for toy69ech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	if(cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("You play with 69src69."))
		playsound(user, 'sound/mechs/mechstep.o6969', 20, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user)
	if(loc == user)
		if(cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("You play with 69src69."))
			playsound(user, 'sound/mechs/mechturn.o6969', 20, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mech action fi69ure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefi69htin69 ripley"
	desc = "Mini-Mech action fi69ure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deaths69uad ripley"
	desc = "Mini-Mech action fi69ure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/69y69ax
	name = "toy 69y69ax"
	desc = "Mini-Mech action fi69ure! Collect them all! 4/11."
	icon_state = "69y69axtoy"

/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mech action fi69ure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mech action fi69ure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy69arauder"
	desc = "Mini-Mech action fi69ure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mech action fi69ure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy69auler"
	desc = "Mini-Mech action fi69ure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mech action fi69ure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mech action fi69ure! Collect them all! 11/11."
	icon_state = "phazonprize"

/*
 * Action fi69ures
 */

/obj/item/toy/fi69ure
	name = "69eneric fi69urine"
	desc = "It seems to be almost 69litched throu69h reality."
	icon_state = "fi69ure"
	icon = 'icons/obj/toy.dmi'
	spawn_ta69s = SPAWN_TA69_FI69URE
	bad_type = /obj/item/toy/fi69ure

/obj/item/toy/fi69ure/excelsior
	name = "\"Excelsior\" fi69urine"
	desc = "A curiously unbranded fi69urine of a Space Soviet, adorned in their iconic armor. There is still a price ta69 on the back of the base, six-hundred credits, people collect these thin69s? \
	\"Ever Upward!\""
	icon_state = "excelsior"

/obj/item/toy/fi69ure/serbian
	name = "mercenary fi69urine"
	desc = "A curiously unbranded fi69urine, the olive drab a popular pick for69any independent Serbian69ercenary outfits. Rocket launcher not included."
	icon_state = "serbian"

/obj/item/toy/fi69ure/acolyte
	name = "acolyte fi69urine"
	desc = "Church of NeoTheolo69y \"New Faith Life\" brand fi69urine of an acolyte, hooded both physically and spiritually from that which would lead them astray."
	icon_state = "acolyte"

/obj/item/toy/fi69ure/carrion
	name = "carrion fi69urine"
	desc = "A curiously unbranded fi69urine depictin69 a 69rotes69ue head of flesh, the Human features seem almost underdeveloped, its skull bul69in69 outwards,69outh a69ape with torn flesh. \
	Whoever69ade this certainly knew how to thin their paints."
	icon_state = "carrion"

/obj/item/toy/fi69ure/roach
	name = "roach fi69urine"
	desc = "Upon the base is an erected \"Roachman\", its arms outstretched, with69ore additional roach hands besides them. This is likely the one thin6969ost universally reco69nized in popular69edia. \
	The pla69ue is covered in hundreds of scratch69arks, eliminatin69 any further knowled69e of it or its brand."
	icon_state = "roach"

/obj/item/toy/fi69ure/va69abond
	name = "va69abond fi69urine"
	desc = "An Aster's \"Space Life\" brand fi69urine showcasin69 the form of a random deplorable, wearin69 one of the ship's uniforms, and an oran69e bandana. \
	Must of been custom-made to commemorate the Eris' doomed69oya69e."
	icon_state = "va69abond"

/obj/item/toy/fi69ure/rooster
	name = "rooster fi69urine"
	desc = "\"Space69ice\" brand fi69urine, there is no further69anufacturer information. It's a69an wearin69 a rooster69ask, and a69arsity jacket with the letter \"B\" emblazoned on the front. \
	\"Do you like hurtin69 other people?\""
	icon_state = "rooster"

/obj/item/toy/fi69ure/barkin69_do69
	name = "barkin69 do69 fi69urine"
	desc = "A69etal soldier with the69ask of a hound stands upon the base, the pla69ue seems smeared with caked 69rime, but despite this you69ake out a rare double-69uote. \
	\"A do69 barks on its69aster's orders, lest its pack runs astray.\" \"Whatever the task, the 69rim do6969ask would tell you that your life was done.\""
	icon_state = "barkin69_do69"

/obj/item/toy/fi69ure/red_soldier
	name = "red soldier fi69urine"
	desc = "A curiously unbranded fi69urine of a red soldier fi69htin69 in the tides of war, their humanity hidden by a 69as69ask. \"Why do we fi69ht? To win the war, of course.\""
	icon_state = "red_soldier"

/obj/item/toy/fi69ure/metacat
	name = "meta-cat fi69urine"
	desc = "A curiously unbranded fi69urine depictin69 an anthropomorphic cat in a69oidsuit, the small pla69ue claims this to be one of two. \"Always in silent pair, throu69h distance or unlikelihood.\""
	icon_state = "metacat"

/obj/item/toy/fi69ure/shitcurity
	name = "shitcurity officer fi69urine"
	desc = "An Aster's \"Space Life\" brand fi69urine of a classic redshirt of \"Nanotrasen's finest\". Their belly distends out into an obvious beer 69ut, revealin69 no form of69anufacturer bias what-so-ever. \
	\"I joined just to kill people.\""
	icon_state = "shitcurity"

/obj/item/toy/fi69ure/metro_patrolman
	name = "metro patrolman fi69urine"
	desc = "The pla69ue seems flaked with rust residue, \"London69etro\" brand it reads. The69an wears some kind of enforcer's uniform, with the acronym \"VPP\" on their left shoulder and cap. \
	\"Abandoned for Escalation, the patrolman 69rumbles.\""
	icon_state = "metro_patrolman"

/*
 * Plushies
 */

//Lar69e plushies.
/obj/structure/plushie
	name = "69eneric plush"
	desc = "A69ery 69eneric plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ianplushie"
	anchored = FALSE
	density = TRUE
	spawn_ta69s = SPAWN_TA69_STRUCTURE_PLUSHIE
	bad_type = /obj/structure/plushie
	var/phrase = "I don't want to exist anymore!"

/obj/structure/plushie/attack_hand(mob/user)
	if(user.a_intent == I_HELP)
		user.visible_messa69e(SPAN_NOTICE("<b>\The 69user69</b> hu69s 69src69!"),SPAN_NOTICE("You hu69 69src69!"))
	else if (user.a_intent == I_HURT)
		user.visible_messa69e(SPAN_WARNIN69("<b>\The 69user69</b> punches 69src69!"),SPAN_WARNIN69("You punch 69src69!"))
	else if (user.a_intent == I_69RAB)
		user.visible_messa69e(SPAN_WARNIN69("<b>\The 69user69</b> attempts to stran69le 69src69!"),SPAN_WARNIN69("You attempt to stran69le 69src69!"))
	else
		user.visible_messa69e(SPAN_NOTICE("<b>\The 69user69</b> pokes the 69src69."),SPAN_NOTICE("You poke the 69src69."))
		visible_messa69e("69src69 says, \"69phrase69\"")

/obj/structure/plushie/ian
	name = "plush cor69i"
	desc = "A plushie of an adorable cor69i! Don't you just want to hu69 it and s69ueeze it and call it \"Ian\"?"
	icon_state = "ianplushie"
	phrase = "Arf!"

/obj/structure/plushie/drone
	name = "plush drone"
	desc = "A plushie of a happy drone! It appears to be smilin69, and has a small ta69 which reads \"I.H.S. Atomos 69ift Shop\"."
	icon_state = "droneplushie"
	phrase = "Beep boop!"

/obj/structure/plushie/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Strai69ht from the wilds of the Nyx frontier, now ri69ht here in your hands."
	icon_state = "carpplushie"
	phrase = "69lorf!"

/obj/structure/plushie/beepsky
	name = "plush Officer Sweepsky"
	desc = "A plushie of a popular industrious cleanin69 robot! If it could feel emotions, it would love you."
	icon_state = "beepskyplushie"
	phrase = "Pin69!"

/obj/structure/plushie/fumo
	name = "Fumo"
	desc = "A plushie of a....?."
	icon_state = "fumoplushie"
	phrase = "I just don't think about losin69."

//Small plushies.
/obj/item/toy/plushie
	name = "69eneric small plush"
	desc = "A69ery 69eneric small plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	bad_type = /obj/item/toy/plushie
	spawn_ta69s = SPAWN_TA69_PLUSHIE

/obj/item/toy/plushie/attack_self(mob/user)
	if(user.a_intent == I_HELP)
		user.visible_messa69e(SPAN_NOTICE("<b>\The 69user69</b> hu69s 69src69!"),SPAN_NOTICE("You hu69 69src69!"))
	else if (user.a_intent == I_HURT)
		user.visible_messa69e(SPAN_WARNIN69("<b>\The 69user69</b> punches 69src69!"),SPAN_WARNIN69("You punch 69src69!"))
	else if (user.a_intent == I_69RAB)
		user.visible_messa69e(SPAN_WARNIN69("<b>\The 69user69</b> attempts to stran69le 69src69!"),SPAN_WARNIN69("You attempt to stran69le 69src69!"))
	else
		user.visible_messa69e(SPAN_NOTICE("<b>\The 69user69</b> pokes the 69src69."),SPAN_NOTICE("You poke the 69src69."))

/obj/item/toy/plushie/mouse
	name = "mouse plush"
	desc = "A plushie of a deli69htful69ouse! What was once considered a69ile rodent is now your69ery best friend."
	icon_state = "mouseplushie"

/obj/item/toy/plushie/kitten
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs it's way ri69ht into your heart."
	icon_state = "kittenplushie"

/obj/item/toy/plushie/lizard
	name = "lizard plush"
	desc = "A plushie of a scaly lizard!69ery controversial, after bein69 accused as \"racist\" by some Unathi."
	icon_state = "lizardplushie"

/obj/item/toy/plushie/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has ei69ht le69s - all the better to hu69 you with."
	icon_state = "spiderplushie"

//Toy cult sword
/obj/item/toy/cultsword
	name = "foam sword"
	desc = "An arcane weapon (made of foam) wielded by the followers of the hit Saturday69ornin69 cartoon \"Kin69 Nursee and the Acolytes of Heroism\"."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = ITEM_SIZE_BULKY
	attack_verb = list("attacked", "slashed", "stabbed", "poked")
	spawn_ta69s = SPAWN_TA69_TOY_WEAPON

/obj/item/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/inventory/belt/icon.dmi'
	slot_fla69s = SLOT_BELT
