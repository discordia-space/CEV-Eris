//This is set of item created to work with Eris stat and perk systems
//The idea here is simple, you find oddities in random spawners, you use them, and they grant you stats, or even perks.
//After use, the object is claimed, and cannot be used by someone else
//If rebalancing is needed, keep in mind spawning rate of those items, it might be good idea to change that as well
//Clockrigger 2019

/obj/item/oddity
	name = "Oddity"
	desc = "Strange item of uncertain origin."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "gift3"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL

	//spawn_values
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_ODDITY
	rarity_value = 10
	bad_type = /obj/item/oddity

	price_tag = 0

	//You choose what stat can be increased, and a maximum value that will be added to this stat
	//The minimum is defined above. The value of change will be decided by random
	var/random_stats = TRUE
	var/list/oddity_stats
	var/sanity_value = 1
	var/datum/perk/oddity/perk
	var/prob_perk = 100

/obj/item/oddity/Initialize()
	. = ..()
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	if(!perk && prob(prob_perk))
		perk = get_oddity_perk()

	if(oddity_stats)
		if(random_stats)
			for(var/stat in oddity_stats)
				oddity_stats[stat] = rand(2, oddity_stats[stat])
		AddComponent(/datum/component/inspiration, oddity_stats, perk)

/proc/get_oddity_perk()
	return pick(subtypesof(/datum/perk/oddity))

//Oddities are separated into categories depending on their origin. They are meant to be used both in maints and derelicts, so this is important
//This is done by subtypes, because this way even densiest code monkey will not able to misuse them
//They are meant to be put in appropriate random spawners

//Common - you can find those everywhere
/obj/item/oddity/common
	prob_perk = 60
	bad_type = /obj/item/oddity/common
	spawn_blacklisted = FALSE


//Single stat oddities. Starting with combat stats (ROB, TGH, and VIG)
/obj/item/oddity/common/lighter
	name = "rusted lighter"
	desc = "This zippo ligher has been rusted shut. It smells faintly of sulphur and blood."
	icon_state = "syndicate_lighter"
	oddity_stats = list(
		STAT_ROB = 10,
	)

/obj/item/oddity/common/old_id
	name = "old id"
	desc = "There is a story behind this name. Untold, and cruel in fate."
	icon_state = "old_id"
	oddity_stats = list(
		STAT_TGH = 10,
	)

/obj/item/oddity/common/photo_eyes
	name = "observer photo"
	desc = "Just looking at this photo sparks a primal fear in your heart."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_VIG = 10,
	)

//Single stat, work stat (BIO, COG, and MEC)
/obj/item/oddity/common/disk
	name = "broken design disk"
	desc = "This disk is corrupted and completely unusable. It has a hand-drawn picture of some strange mechanism on it - looking at it for too long makes your head hurt."
	icon_state = "disc"
	oddity_stats = list(
		STAT_MEC = 10,
	)

/obj/item/oddity/common/book_unholy
	name = "unholy book"
	desc = "The writings inside entail some strange ritual. Pages have been torn out or smudged to illegibility."
	icon_state = "book_skull"
	oddity_stats = list(
		STAT_COG = 10,
	)

/obj/item/oddity/common/healthscanner
	name = "odd health scanner"
	desc = "It's broken and stuck on some really strange readings. Was this even human?"
	icon_state = "healthscanner"
	item_state = "electronic"
	oddity_stats = list(
		STAT_BIO = 10,
	)

//Double stat oddities, combat.
/obj/item/oddity/common/coin
	name = "strange coin"
	desc = "It appears to be more of a collectible than any sort of actual currency. What metal it's made from seems to be a mystery."
	icon_state = "coin"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_TGH = 6,
	)

/obj/item/oddity/common/towel
	name = "trustworthy towel"
	desc = "It's always good to have one with you."
	icon_state = "towel"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_TGH = 6,
	)
	rarity_value = 15

/obj/item/oddity/common/book_bible
	name = "old bible"
	desc = "Oh, how quickly we forgot."
	icon_state = "book_bible"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_VIG = 6,
	)

/obj/item/oddity/common/old_money
	name = "old money"
	desc = "It's not like the organization that issued this exists anymore."
	icon_state = "old_money"
	oddity_stats = list(
		STAT_TGH = 6,
		STAT_VIG = 6,
	)

//Double stat, mixed
/obj/item/oddity/common/photo_crime
	name = "crime scene photo"
	desc = "It is unclear whether this is a victim of suicide or murder. His face is frozen in a look of agony and terror, and you shudder to think at what his last moments might have been."
	icon_state = "photo_crime"
	oddity_stats = list(
		STAT_BIO = 7,
		STAT_VIG = 7,
	)
	rarity_value = 17

/obj/item/oddity/common/photo_coridor
	name = "surreal maint photo"
	desc = "The corridor in this photograph looks familiar, though something seems wrong about it; it's as if everything in it was replaced with an exact replica of itself."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_MEC = 7,
		STAT_VIG = 7,
	)
	rarity_value = 17

/obj/item/oddity/common/photo_landscape
	name = "alien landscape photo"
	desc = "There is some ire about the planet in this photograph."
	icon_state = "photo_landscape"
	oddity_stats = list(
		STAT_COG = 7,
		STAT_VIG = 7,
	)
	rarity_value = 17

/obj/item/oddity/common/old_radio
	name = "old radio"
	desc = "Close your eyes, bring it closer and listen. You can almost hear it, in the edge of your consciousness. The World is ticking."
	icon_state = "old_radio"
	oddity_stats = list(
		STAT_COG = 9,
		STAT_VIG = 9,
	)
	rarity_value = 23

/obj/item/oddity/common/mirror
	name = "cracked mirror"
	desc = "A thousand mirror images stare back at you as you examine the trinket. What if you're the reflection, staring back out at the real world? At the real you?"
	icon_state = "mirror"
	oddity_stats = list(
		STAT_COG = 5,
		STAT_TGH = 5,
	)
	rarity_value = 9

//Double stat, work
/obj/item/oddity/common/old_pda
	name = "broken pda"
	desc = "An old Nanotrasen era PDA. These were issued to their employees all throughout the galaxy."
	icon_state = "old_pda"
	item_state = "electronic"
	oddity_stats = list(
		STAT_COG = 6,
		STAT_BIO = 6,
	)
	rarity_value = 15

/obj/item/oddity/common/blueprint
	name = "strange blueprint"
	desc = "There's no telling what this design is supposed to be. Whatever could be built from this likely wouldn't work."
	icon_state = "blueprint"
	oddity_stats = list(
		STAT_COG = 5,
		STAT_MEC = 7,
	)
	rarity_value = 15

/obj/item/oddity/common/device
	name = "odd device"
	desc = "Something about this gadget both disturbs and interests you. It's manufacturer's name has been mostly smudged away, but you can see a strange mechanism as their logo."
	icon_state = "device"
	oddity_stats = list(
		STAT_COG = 8,
		STAT_MEC = 8,
	)
	rarity_value = 19

//Triple stat, combat
/obj/item/oddity/common/old_knife
	name = "old knife"
	desc = "Is this blood older then you? You can't tell, and will never know."
	icon_state = "old_knife"
	item_state = "knife"
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 5)
	force = WEAPON_FORCE_DANGEROUS
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	sharp = TRUE
	edge = TRUE
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_TGH = 6,
		STAT_VIG = 6,
	)
	rarity_value = 22

/obj/item/oddity/common/teddy
	name = "teddy bear"
	desc = "He will be there for you, even in tough times."
	icon_state = "teddy"
	oddity_stats = list(
		STAT_ROB = 7,
		STAT_TGH = 7,
		STAT_VIG = 7,
	)
	rarity_value = 20

/obj/item/oddity/common/book_eyes
	name = "observer book"
	desc = "This book contains detailed information on otherwise unknown cyber creatures. Who did this, how is this even possible?"
	icon_state = "book_eyes"
	oddity_stats = list(
		STAT_ROB = 9,
		STAT_TGH = 9,
		STAT_VIG = 9,
	)
	rarity_value = 30

//Triple stat, mixed
/obj/item/oddity/common/paper_bundle
	name = "paper bundle"
	desc = "Somewhere there is a truth, hidden under all of this scrap."
	icon_state = "paper_bundle"
	oddity_stats = list(
		STAT_BIO = 6,
		STAT_TGH = 6,
		STAT_VIG = 6,
	)
	rarity_value = 16

/obj/item/oddity/common/book_omega
	name = "occult book"
	desc = "Most of the stories in this book seem to be the writings of madmen, but at least the stories are interesting."
	icon_state = "book_omega"
	oddity_stats = list(
		STAT_BIO = 6,
		STAT_ROB = 6,
		STAT_TGH = 6,
	)
	rarity_value = 16

/obj/item/oddity/common/paper_crumpled
	name = "turn-out page"
	desc = "This ALMOST makes sense."
	icon_state = "paper_crumpled"
	oddity_stats = list(
		STAT_MEC = 6,
		STAT_ROB = 6,
		STAT_TGH = 6,
	)
	rarity_value = 16

//Triple stat, work
/obj/item/oddity/common/old_newspaper
	name = "old newspaper"
	desc = "It contains a report on some old and strange phenomenon. Maybe it's lies, maybe it's corporate experiments gone wrong. Wait, there are two comically obvious holes for peering through!"
	icon_state = "old_newspaper"
	oddity_stats = list(
		STAT_MEC = 6,
		STAT_COG = 6,
		STAT_BIO = 6,
	)
	rarity_value = 18

/obj/item/oddity/common/old_newspaper/attack_self(mob/user)
	zoom(8, 8)
	..()

/obj/item/oddity/common/paper_omega
	name = "collection of obscure reports"
	desc = "Even the authors seem to be rather skeptical about their findings. The reports are not connected to each other, but their results are similar."
	icon_state = "folder-omega" //changed from "paper_omega"
	oddity_stats = list(
		STAT_MEC = 8,
		STAT_COG = 8,
		STAT_BIO = 8,
	)
	rarity_value = 27

//Oddity generated from Technomancer's Techno-Tribalism Enforcer
/obj/item/oddity/techno
	name = "Unknown technological part"
	desc = "Technological part created by Techno-Tribalism Enforcer."
	icon_state = "techno_part1"

/obj/item/oddity/techno/Initialize()
	icon_state = "techno_part[rand(1,7)]"
	.=..()

//Rare bluespace oddity.
/obj/item/oddity/broken_necklace
	name = "Broken necklace"
	desc = "A broken necklace that has a blue crystal as a trinket."
	icon_state = "broken_necklace"
	origin_tech = list(TECH_BLUESPACE = 9)
	spawn_frequency = 0//unique
	oddity_stats = list(
		STAT_COG = 9,
		STAT_VIG = 9,
		STAT_ROB = 9,
		STAT_TGH = 9,
		STAT_BIO = 9,
		STAT_MEC = 9
	)
	var/cooldown
	var/entropy_value = 5
	var/blink_range = 8

/obj/item/oddity/broken_necklace/New()
	..()
	GLOB.bluespace_gift++
	GLOB.bluespace_entropy -= rand(30, 50)

/obj/item/oddity/broken_necklace/examine(user, distance)
	. = ..()
	var/area/my_area = get_area(src)
	switch(my_area.bluespace_entropy)
		if(0 to my_area.bluespace_hazard_threshold*0.3)
			to_chat(user, SPAN_NOTICE("This feels cold to the touch."))

		if(my_area.bluespace_hazard_threshold*0.7 to INFINITY)
			to_chat(user, SPAN_NOTICE("This feels warm to the touch."))

	if(GLOB.bluespace_entropy > GLOB.bluespace_hazard_threshold*0.7)
		to_chat(user, SPAN_NOTICE("Has it always shone so brightly?"))

	if(my_area.bluespace_entropy > my_area.bluespace_hazard_threshold*0.95 || GLOB.bluespace_entropy > GLOB.bluespace_hazard_threshold*0.95)
		to_chat(user, SPAN_NOTICE("You can see an inscription in some language unknown to you."))

/obj/item/oddity/broken_necklace/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		bluespace_entropy(80,T)
		new /obj/item/bluespace_dust(T)
	GLOB.bluespace_gift--
	return ..()

/obj/item/oddity/broken_necklace/attack_self(mob/user)
	if(world.time < cooldown)
		return
	cooldown = world.time + 3 SECONDS
	user.visible_message(SPAN_WARNING("[user] crushes [src]!"), SPAN_DANGER("You crush [src]!"))
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, get_turf(user))
	sparks.start()
	var/turf/T = get_random_secure_turf_in_range(user, blink_range, 2)
	go_to_bluespace(get_turf(user), entropy_value, TRUE, user, T)
	for(var/obj/item/grab/G in user.contents)
		if(G.affecting)
			go_to_bluespace(get_turf(user), entropy_value, FALSE, G.affecting, locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
	if(prob(1))
		qdel(src)

/obj/item/oddity/broken_necklace/throw_impact(atom/movable/hit_atom)
	if(!..()) // not caught in mid-air
		visible_message(SPAN_NOTICE("[src] fizzles upon impact!"))
		var/turf/T = get_turf(hit_atom)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()
		if(!hit_atom.anchored)
			var/turf/NT = get_random_turf_in_range(hit_atom, blink_range, 2)
			go_to_bluespace(T, entropy_value, TRUE, hit_atom, NT)
		if(prob(1))
			qdel(src)

//A randomized oddity with random stats, meant for artist job project
/obj/item/oddity/artwork
	name = "Strange Device"
	desc = "You can't find out how to turn it on. Maybe it's already working?"
	icon_state = "artwork_1"
	price_tag = 200
	prob_perk = 0//no perks for artwork oddities
	spawn_frequency = 0

/obj/item/oddity/artwork/Initialize()
	name = get_weapon_name(capitalize = TRUE)
	icon_state = "artwork_[rand(1,6)]"
	return ..()

/obj/item/oddity/artwork/get_item_cost(export)
	. = ..()
	GET_COMPONENT(comp_sanity, /datum/component/atom_sanity)
	. += comp_sanity.affect * 100
	GET_COMPONENT(comp_insp, /datum/component/inspiration)
	var/list/true_stats = comp_insp.calculate_statistics()
	for(var/stat in true_stats)
		. += true_stats[stat] * 50

//NT Oddities
/obj/item/oddity/nt
	bad_type = /obj/item/oddity/nt
	spawn_blacklisted = TRUE
	random_stats = FALSE

/obj/item/oddity/nt/seal
	name = "High Inquisitor's Seal"
	desc = "An honorary badge given to the most devout of NeoTheology preachers by the High Inquisitor. Such a badge is a rare sight indeed - rumor has it that the badge imbues the holder with the power of the Angels themselves."
	icon_state = "nt_seal"
	oddity_stats = list(
		STAT_COG = 12,
		STAT_VIG = 12,
		STAT_ROB = 8
	)
	price_tag = 8000
	perk = /datum/perk/nt_oddity/holy_light

//Hivemind oddity
/obj/item/oddity/hivemind
	name = "Hivemind Oddity"
	desc = "You shouldn't be seeing this. Report to your nearest reeducation camp comrade (report it on discord)."
	spawn_blacklisted = TRUE
	bad_type = /obj/item/oddity/hivemind

/obj/item/oddity/hivemind/old_radio
	name = "warped radio"
	desc = "An old radio covered in growths. You can hear nothing from it, nothing but the sound of machinery and souls begging for release."
	icon_state = "warped_radio"
	oddity_stats = list(
		STAT_COG = 8,
		STAT_VIG = 8,
		STAT_MEC = 7,
	)

/obj/item/oddity/hivemind/old_pda
	name = "abnormal pda"
	desc = "An old Nanotrasen era PDA covered in growths. Is the hive Nanotrasen's creation, or made by something worse?"
	icon_state = "abnormal_pda"
	oddity_stats = list(
		STAT_COG = 8,
		STAT_MEC = 8,
		STAT_VIG = 7
	)

/obj/item/oddity/hivemind/hive_core
	name = "makeshift datapad"
	desc = "A makeshift datapad covered in growths. Whatever data was stored here is now gone, part of it transferred to an unknown source, the rest simply wiped."
	icon_state = "hivemind_core"
	w_class = ITEM_SIZE_NORMAL
	random_stats = FALSE
	oddity_stats = list(
		STAT_COG = 8,
		STAT_VIG = 8,
		STAT_MEC = 8,
		STAT_BIO = 8
	)
	perk = /datum/perk/hive_oddity/hive_born

//i copied the entire thing because beforehand it just did not work
/obj/item/oddity/hivemind/hive_core/Initialize()
	. = ..()
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	if(!perk && prob(prob_perk))
		perk = get_oddity_perk()

	if(oddity_stats)
		if(random_stats)
			for(var/stat in oddity_stats)
				oddity_stats[stat] = rand(1, oddity_stats[stat])
		AddComponent(/datum/component/inspiration, oddity_stats, perk)
	set_light(2, 1, COLOR_BLUE_LIGHT)

/obj/item/oddity/pendant
	name = "pendant of Kultainen"
	desc = "An ornate golden necklace."
	icon_state = "golden_necklace"
	slot_flags = SLOT_MASK
	origin_tech = list(TECH_MATERIAL = 3)
	matter = list(MATERIAL_GOLD = 4)
	spawn_frequency = 0
	spawn_blacklisted = TRUE
	prob_perk = 0
	oddity_stats = list(
		STAT_MEC = 4,
		STAT_BIO = 4
	)
	var/produce_ready = TRUE
	var/produce_next

/obj/item/oddity/pendant/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/oddity/pendant/Process()
	if(world.time > produce_next)
		visible_message(SPAN_NOTICE("[src] stops humming suddenly."))
		src.desc = "An ornate golden necklace."
		produce_ready = TRUE
		STOP_PROCESSING(SSobj, src)
		. = ..()

/obj/item/oddity/pendant/attack_self(mob/user)
	if(produce_ready)
		new /obj/item/golden_leaf(get_turf(src))
		user.visible_message(SPAN_NOTICE("[user] opens [src], and a little golden leaf falls from it. \The [src] closes shut right after."), SPAN_NOTICE("As you open [src], a little golden leaf falls from it. \The [src] closes shut right after and start to hum quietly."))
		src.desc = "An ornate golden necklace. It's closed and hums quietly."
		produce_next = world.time + 10 MINUTES
		produce_ready = FALSE
		START_PROCESSING(SSobj, src)
	else
		user.visible_message(SPAN_NOTICE("[user] tries to open [src] without success."), SPAN_NOTICE("You fail to open [src]."))

/hook/roundstart/proc/place_pendant()
	var/obj/landmark/storyevent/potential_unique_oddity_spawn/L = pick_landmark(/obj/landmark/storyevent/potential_unique_oddity_spawn)
	new /obj/item/oddity/pendant(L.get_loc())
	return TRUE

/obj/item/golden_leaf
	name = "golden leaf"
	desc = "Little piece of gold resembling a tea leaf."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "golden_leaf"
	matter = list(MATERIAL_GOLD = 0.5)
	spawn_frequency = 0
	spawn_blacklisted = TRUE
	w_class = ITEM_SIZE_TINY

/obj/item/golden_leaf/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(target.is_refillable())
		if(!target.reagents.has_reagent("water", 30))
			to_chat(user, SPAN_NOTICE("You need some water for that."))
		else
			target.reagents.remove_reagent("water", 30)
			target.reagents.add_reagent("oddity_tea", 30)
			to_chat(user, SPAN_NOTICE("You drop \the [src] in the water, it dissolves slowly."))
			qdel(src)

//Complex Functional Oddities (Spawn in maint too, but moving them up would eat quite a bit of the document)
/obj/item/clothing/mask/gas/big_shot
	name = "big shot mask"
	desc = "A cheerful mask of a cartoonish salesman."
	icon_state = "big_shot"
	item_state = "big_shot"


	armor = list(
		melee = 3,
		bullet = 3,
		energy = 3,
		bomb = 50,
		bio = 75,
		rad = 10
	)
	price_tag = 1997

	spawn_tags = SPAWN_TAG_ODDITY
	spawn_blacklisted = TRUE

/obj/item/clothing/mask/gas/big_shot/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == slot_wear_mask)
		user.stats.addPerk(/datum/perk/big_shot)
		var/datum/perk/big_shot/perk = user.stats.getPerk(PERK_BIG_SHOT)
		perk.my_mask = src

/obj/item/oddity/common/bearmath
	name = "scrap of semi-semiotics research pamphlet"
	desc = "A piece of paper with an unfinished mathematical equation."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_words_crumpled"
	prob_perk = 0
	oddity_stats = list(
		STAT_ROB = 4,
		STAT_TGH = 4,
		STAT_COG = 7
	)


/obj/item/oddity/common/bearmath/attack_self(mob/living/carbon/human/user)
	if(istype(user))
		if(alert(user, "Do you want to try and solve the equation on the scrap?", "Math problems!", "Yes", "No") == "Yes")
			if(user.stat_check(STAT_COG, STAT_LEVEL_ADEPT))
				if(prob(95))
					user.visible_message(SPAN_WARNING("A bear appears out of nowhere!"), SPAN_DANGER("The equation results in a bear!"))
					var/turf/T = get_turf(pick(oview(2, user)))
					var/mob/living/simple_animal/hostile/bear/B = new /mob/living/simple_animal/hostile/bear(T)
					var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
					sparks.set_up(3, 0, get_turf(B.loc))
					sparks.start()
					if(prob(15))
						user.visible_message(SPAN_WARNING("The paper disintegrates!"))
						qdel(src)
				else
					new /obj/spawner/oddities(get_turf(pick(oview(2, user))))
					new /obj/spawner/oddities(get_turf(pick(oview(2, user))))
					new /obj/spawner/oddities(get_turf(pick(oview(2, user))))
					var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
					sparks.set_up(3, 0, get_turf(user.loc))
					sparks.start()
					user.visible_message(SPAN_WARNING("A bunch of items appear out of nowhere!"), SPAN_DANGER("The equation results in several unique objects!"))
					qdel(src)
			else
				to_chat(user, "You fail to solve the equation, did you carry the [rand(1, 9)]?")
	else
		to_chat(user, "You're not smart enough to comprehend what this says.")
