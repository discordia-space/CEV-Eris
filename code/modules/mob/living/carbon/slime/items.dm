/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	description_antag = "These always have 30u of slime jelly , a deadly toxin"
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

	attackby(obj/item/O, mob/user)
		if(istype(O, /obj/item/slimesteroid2))
			if(enhanced == 1)
				to_chat(user, SPAN_WARNING(" This extract has already been enhanced!"))
				return ..()
			if(Uses == 0)
				to_chat(user, SPAN_WARNING(" You can't enhance a used extract!"))
				return ..()
			to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
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
	description_info = "Inject with plasma to create another slime. Inject with water to create 3 monkey cubes."

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"
	description_info = "Inject with plasma to create 2 roach cubes."

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"
	description_info = "Inject with plasma to create food!"

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"
	description_info = "Inject with plasma to create 15 sheets of metal and 5 of plasteel"

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"
	description_info = "Inject with plasma to create slime steroids. Inject with sugar to create even more slime jelly."

/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"
	description_info = "Inject with plasma to create 10 sheets of plasma. Break the economy!"

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"
	description_info = "Inject with blood to create capsaicin. Inject with plasma to trigger a fiery explosion with a 5 second delay"
	description_antag = "The plasma fire reaction will severely burn anyone stuck in small spaces."

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"
	description_info = "Inject with blood to create a strong EMP pulse. Inject with plasma to create a large powerfull cell. Inject with water to create a long-lasting light-source"


/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"
	description_info = "Inject with plasma to create gylcerol at a 1/8 ratio. Inject with blood to turn all nearby slimes rabid"
	description_antag = "Rabid slimes are extremly dangerous. They will hunt and attack people regardless of hunger until they're dead."

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"
	description_info = "Inject with plasma to create frostoil at a 1/10 ratio."

/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"
	description_info = "Inject with plasma to trigger a freeze-reaction with 5 second delay."
	description_antag ="The temperature shift is low enough to cause massive slowdown to anyone caught nearby, great for getting away"

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"
	description_info = "Inject with plasma to create a slime docility potion."

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"
	description_info = "Inject with plasma to create Slime Mutation Toxin , which can be used to turn yourself into a Slime-Human hybrid"
	description_antag = "Slime-Human hybrids are highly dangerous, can regenerate limbs, are far tougher, can't slip, but have no way of naturally metabolizing reagents. Their punches can also electrocute people"

/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"
	description_info = "Inject with plasma to create a more potent docility potion, useable on adult slimes."

/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black slime extract"
	description_info = "Inject with plasma to create advanced slime mutation toxin"
	description_antag = "Once someone becomes a slime, there is no turning back."

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"
	description_info = "Inject with plasma to trigger a explosive reaction with a 5 second delay."

/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine slime extract"
	description_info = "Inject with plasma to create a golem rune, that can be used to summon a royal servant"

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace slime extract"
	description_info = "Does nothing. Its meaningless other than for exporting"

/obj/item/slime_extract/pyrite
	name = "pyrite slime extract"
	icon_state = "pyrite slime extract"
	description_info = "Does nothing. Can't even be used for export."

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean slime extract"
	description_info = "Does nothing. Can't even be used for export."

/obj/item/slime_extract/sepia
	name = "sepia slime extract"
	icon_state = "sepia slime extract"
	description_info = "Does nothing. Can't even be used for export"

/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow slime extract"
	description_info = "Does nothing. Highly valuable for export"

////Pet Slime Creation///

/obj/item/slimepotion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!isslime(M))//If target is not a slime.
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
		var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
		pet.icon_state = "[M.colour] baby slime"
		pet.icon_living = "[M.colour] baby slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)

/obj/item/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
			to_chat(user, SPAN_WARNING(" The potion only works on slimes!"))
			return ..()
		if(M.stat)
			to_chat(user, SPAN_WARNING(" The slime is dead!"))
			return..()
		if(M.mind)
			to_chat(user, SPAN_WARNING(" The slime resists!"))
			return ..()
		var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "[M.colour] adult slime"
		pet.icon_living = "[M.colour] adult slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)


/obj/item/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!isslime(M))//If target is not a slime.
			to_chat(user, SPAN_WARNING(" The steroid only works on baby slimes!"))
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, SPAN_WARNING(" Only baby slimes can use the steroid!"))
			return..()
		if(M.stat)
			to_chat(user, SPAN_WARNING(" The slime is dead!"))
			return..()
		if(M.cores == 3)
			to_chat(user, SPAN_WARNING(" The slime already has the maximum amount of extract!"))
			return..()

		to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
		M.cores = 3
		qdel(src)

/obj/item/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	/*afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/item/slime_extract))
			if(target.enhanced == 1)
				to_chat(user, SPAN_WARNING(" This extract has already been enhanced!"))
				return ..()
			if(target.Uses == 0)
				to_chat(user, SPAN_WARNING(" You can't enhance a used extract!"))
				return ..()
			to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
			target.Uses = 3
			target.enahnced = 1
			qdel(src)*/

/obj/effect/golemrune
	anchored = TRUE
	desc = "a strange rune used to create golems. It glows when spirits are nearby."
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

	attack_hand(mob/living/user as mob)
		var/mob/observer/ghost/ghost
		for(var/mob/observer/ghost/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(!ghost)
			to_chat(user, "The rune fizzles uselessly. There is no spirit nearby.")
			return
		var/mob/living/carbon/human/G = new(src.loc)
		G.set_species("Golem")
		G.key = ghost.key
		to_chat(G, "You are an adamantine golem. You move slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use most tools. Serve [user], and assist them in completing their goals at any cost.")
		qdel(src)


	proc/announce_to_ghosts()
		for(var/mob/observer/ghost/G in GLOB.player_list)
			if(G.client)
				var/area/A = get_area(src)
				if(A)
					to_chat(G, "Golem rune created in [A.name].")

/mob/living/carbon/slime/has_eyes()
	return 0

