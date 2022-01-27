/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1
	w_class = ITEM_SIZE_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(TECH_BIO = 4)
	reagent_flags = REFILLABLE | DRAINABLE | AMOUNT_VISIBLE
	bad_type = /obj/item/slime_extract
	spawn_blacklisted = TRUE//antag_item_targets
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?

	attackby(obj/item/O,69ob/user)
		if(istype(O, /obj/item/slimesteroid2))
			if(enhanced == 1)
				to_chat(user, SPAN_WARNING(" This extract has already been enhanced!"))
				return ..()
			if(Uses == 0)
				to_chat(user, SPAN_WARNING(" You can't enhance a used extract!"))
				return ..()
			to_chat(user, "You apply the enhancer. It69ow has triple the amount of uses.")
			Uses = 3
			enhanced = 1
			qdel(O)

/obj/item/slime_extract/New()
	..()
	create_reagents(100)
	reagents.add_reagent("slimejelly", 30)

/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey slime extract"

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"

/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"

/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"

/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"

/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"

/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black slime extract"

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"

/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine slime extract"

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace slime extract"

/obj/item/slime_extract/pyrite
	name = "pyrite slime extract"
	icon_state = "pyrite slime extract"

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean slime extract"

/obj/item/slime_extract/sepia
	name = "sepia slime extract"
	icon_state = "sepia slime extract"

/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow slime extract"

////Pet Slime Creation///

/obj/item/slimepotion
	name = "docility potion"
	desc = "A potent chemical69ix that will69ullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as69ob,69ob/user as69ob)
		if(!isslime(M))//If target is69ot a slime.
			to_chat(user, SPAN_WARNING(" The potion only works on baby slimes!"))
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, SPAN_WARNING(" Only baby slimes can be tamed!"))
			return..()
		if(M.stat)
			to_chat(user, SPAN_WARNING(" The slime is dead!"))
			return..()
		if(M.mind)
			to_chat(user, SPAN_WARNING(" The slime resists!"))
			return ..()
		var/mob/living/simple_animal/slime/pet =69ew /mob/living/simple_animal/slime(M.loc)
		pet.icon_state = "69M.colour69 baby slime"
		pet.icon_living = "69M.colour69 baby slime"
		pet.icon_dead = "69M.colour69 baby slime dead"
		pet.colour = "69M.colour69"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a69ame?", "Name your69ew pet", "pet slime") as69ull|text,69AX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name =69ewname
		pet.real_name =69ewname
		qdel(src)

/obj/item/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical69ix that will69ullify a slime's powers, causing it to become docile and tame. This one is69eant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as69ob,69ob/user as69ob)
		if(!istype(M, /mob/living/carbon/slime/))//If target is69ot a slime.
			to_chat(user, SPAN_WARNING(" The potion only works on slimes!"))
			return ..()
		if(M.stat)
			to_chat(user, SPAN_WARNING(" The slime is dead!"))
			return..()
		if(M.mind)
			to_chat(user, SPAN_WARNING(" The slime resists!"))
			return ..()
		var/mob/living/simple_animal/adultslime/pet =69ew /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "69M.colour69 adult slime"
		pet.icon_living = "69M.colour69 adult slime"
		pet.icon_dead = "69M.colour69 baby slime dead"
		pet.colour = "69M.colour69"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a69ame?", "Name your69ew pet", "pet slime") as69ull|text,69AX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name =69ewname
		pet.real_name =69ewname
		qdel(src)


/obj/item/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical69ix that will cause a slime to generate69ore extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	attack(mob/living/carbon/slime/M as69ob,69ob/user as69ob)
		if(!isslime(M))//If target is69ot a slime.
			to_chat(user, SPAN_WARNING(" The steroid only works on baby slimes!"))
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, SPAN_WARNING(" Only baby slimes can use the steroid!"))
			return..()
		if(M.stat)
			to_chat(user, SPAN_WARNING(" The slime is dead!"))
			return..()
		if(M.cores == 3)
			to_chat(user, SPAN_WARNING(" The slime already has the69aximum amount of extract!"))
			return..()

		to_chat(user, "You feed the slime the steroid. It69ow has triple the amount of extract.")
		M.cores = 3
		qdel(src)

/obj/item/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical69ix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	/*afterattack(obj/target,69ob/user , flag)
		if(istype(target, /obj/item/slime_extract))
			if(target.enhanced == 1)
				to_chat(user, SPAN_WARNING(" This extract has already been enhanced!"))
				return ..()
			if(target.Uses == 0)
				to_chat(user, SPAN_WARNING(" You can't enhance a used extract!"))
				return ..()
			to_chat(user, "You apply the enhancer. It69ow has triple the amount of uses.")
			target.Uses = 3
			target.enahnced = 1
			qdel(src)*/

/obj/effect/golemrune
	anchored = TRUE
	desc = "a strange rune used to create golems. It glows when spirits are69earby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = TURF_LAYER

	New()
		..()
		START_PROCESSING(SSobj, src)

	Process()
		var/mob/observer/ghost/ghost
		for(var/mob/observer/ghost/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(ghost)
			icon_state = "golem2"
		else
			icon_state = "golem"

	attack_hand(mob/living/user as69ob)
		var/mob/observer/ghost/ghost
		for(var/mob/observer/ghost/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(!ghost)
			to_chat(user, "The rune fizzles uselessly. There is69o spirit69earby.")
			return
		var/mob/living/carbon/human/G =69ew(src.loc)
		G.set_species("Golem")
		G.key = ghost.key
		to_chat(G, "You are an adamantine golem. You69ove slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use69ost tools. Serve 69user69, and assist them in completing their goals at any cost.")
		qdel(src)


	proc/announce_to_ghosts()
		for(var/mob/observer/ghost/G in GLOB.player_list)
			if(G.client)
				var/area/A = get_area(src)
				if(A)
					to_chat(G, "Golem rune created in 69A.name69.")

/mob/living/carbon/slime/has_eyes()
	return 0

