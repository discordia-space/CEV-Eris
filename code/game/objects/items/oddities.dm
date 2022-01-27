//This is set of item created to work with Eris stat and perk systems
//The idea here is simple, you find oddities in random spawners, you use them, and they 69rant you stats, or even perks.
//After use, the object is claimed, and cannot be used by someone else
//If rebalancin69 is needed, keep in69ind spawnin69 rate of those items, it69i69ht be 69ood idea to chan69e that as well
//Clockri6969er 2019

/obj/item/oddity
	name = "Oddity"
	desc = "Stran69e item of uncertain ori69in."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "69ift3"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL

	//spawn_values
	spawn_blacklisted = TRUE
	spawn_ta69s = SPAWN_TA69_ODDITY
	rarity_value = 10
	bad_type = /obj/item/oddity

	//You choose what stat can be increased, and a69aximum69alue that will be added to this stat
	//The69inimum is defined above. The69alue of chan69e will be decided by random
	var/random_stats = TRUE
	var/list/oddity_stats
	var/sanity_value = 1
	var/datum/perk/oddity/perk
	var/prob_perk = 100

/obj/item/oddity/Initialize()
	. = ..()
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	if(!perk && prob(prob_perk))
		perk = 69et_oddity_perk()

	if(oddity_stats)
		if(random_stats)
			for(var/stat in oddity_stats)
				oddity_stats69stat69 = rand(1, oddity_stats69stat69)
		AddComponent(/datum/component/inspiration, oddity_stats, perk)

/proc/69et_oddity_perk()
	return pick(subtypesof(/datum/perk/oddity))

//Oddities are separated into cate69ories dependin69 on their ori69in. They are69eant to be used both in69aints and derelicts, so this is important
//This is done by subtypes, because this way even densiest code69onkey will not able to69isuse them
//They are69eant to be put in appropriate random spawners

//Common - you can find those everywhere
/obj/item/oddity/common
	prob_perk = 60
	bad_type = /obj/item/oddity/common
	spawn_blacklisted = FALSE

/obj/item/oddity/common/blueprint
	name = "stran69e blueprint"
	desc = "There's no tellin69 what this desi69n is supposed to be. Whatever could be built from this likely wouldn't work."
	icon_state = "blueprint"
	oddity_stats = list(
		STAT_CO69 = 5,
		STAT_MEC = 7,
	)
	rarity_value = 15

/obj/item/oddity/common/coin
	name = "stran69e coin"
	desc = "It appears to be69ore of a collectible than any sort of actual currency. What69etal it's69ade from seems to be a69ystery."
	icon_state = "coin"
	oddity_stats = list(
		STAT_ROB = 5,
		STAT_T69H = 5,
	)

/obj/item/oddity/common/photo_landscape
	name = "alien landscape photo"
	desc = "There is some ire about the planet in this photo69raph."
	icon_state = "photo_landscape"
	oddity_stats = list(
		STAT_CO69 = 5,
		STAT_T69H = 5,
	)

/obj/item/oddity/common/photo_coridor
	name = "surreal69aint photo"
	desc = "The corridor in this photo69raph looks familiar, thou69h somethin69 seems wron69 about it; it's as if everythin69 in it was replaced with an exact replica of itself."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_MEC = 5,
		STAT_T69H = 5,
	)

/obj/item/oddity/common/photo_eyes
	name = "observer photo"
	desc = "Just lookin69 at this photo sparks a primal fear in your heart."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_T69H = 6,
		STAT_VI69 = 6,
	)
	rarity_value = 18

/obj/item/oddity/common/photo_crime
	name = "crime scene photo"
	desc = "It is unclear whether this is a69ictim of suicide or69urder. His face is frozen in a look of a69ony and terror, and you shudder to think at what his last69oments69i69ht have been."
	icon_state = "photo_crime"
	oddity_stats = list(
		STAT_CO69 = 7,
		STAT_VI69 = 7,
	)
	rarity_value = 23

/obj/item/oddity/common/old_newspaper
	name = "old newspaper"
	desc = "It contains a report on some old and stran69e phenomenon.69aybe it's lies,69aybe it's corporate experiments 69one wron69."
	icon_state = "old_newspaper"
	oddity_stats = list(
		STAT_MEC = 4,
		STAT_CO69 = 4,
		STAT_BIO = 4,
	)

/obj/item/oddity/common/paper_crumpled
	name = "turn-out pa69e"
	desc = "This ALMOST69akes sense."
	icon_state = "paper_crumpled"
	oddity_stats = list(
		STAT_MEC = 6,
		STAT_CO69 = 6,
		STAT_BIO = 6,
	)
	rarity_value = 18

/obj/item/oddity/common/paper_ome69a
	name = "collection of obscure reports"
	desc = "Even the authors seem to be rather skeptical about their findin69s. The reports are not connected to each other, but their results are similar."
	icon_state = "folder-ome69a" //chan69ed from "paper_ome69a"
	oddity_stats = list(
		STAT_MEC = 8,
		STAT_CO69 = 8,
		STAT_BIO = 8,
	)
	rarity_value = 27

/obj/item/oddity/common/book_eyes
	name = "observer book"
	desc = "This book details information on some cyber creatures. Who did this, how this is even possible?"
	icon_state = "book_eyes"
	oddity_stats = list(
		STAT_ROB = 9,
		STAT_T69H = 9,
		STAT_VI69 = 9,
	)
	rarity_value = 30

/obj/item/oddity/common/book_ome69a
	name = "occult book"
	desc = "Most of the stories in this book seem to be the writin69s of69admen, but at least the stories are interestin69."
	icon_state = "book_ome69a"
	oddity_stats = list(
		STAT_BIO = 6,
		STAT_ROB = 6,
		STAT_VI69 = 6,
	)
	rarity_value = 18

/obj/item/oddity/common/book_bible
	name = "old bible"
	desc = "Oh, how 69uickly we for69ot."
	icon_state = "book_bible"
	oddity_stats = list(
		STAT_ROB = 5,
		STAT_VI69 = 5,
	)

/obj/item/oddity/common/book_unholy
	name = "unholy book"
	desc = "The writin69s inside entail some stran69e ritual. Pa69es have been torn out or smud69ed to ille69ibility."
	icon_state = "book_skull"
	oddity_stats = list(
		STAT_CO69 = 7,
		STAT_MEC = 7,
	)
	rarity_value = 24

/obj/item/oddity/common/old_money
	name = "old69oney"
	desc = "It's not like the or69anization that issued this exists anymore."
	icon_state = "old_money"
	oddity_stats = list(
		STAT_ROB = 4,
		STAT_T69H = 4,
	)
	rarity_value = 8

/obj/item/oddity/common/healthscanner
	name = "odd health scanner"
	desc = "It's broken and stuck on some really stran69e readin69s. Was this even human?"
	icon_state = "healthscanner"
	item_state = "electronic"
	oddity_stats = list(
		STAT_CO69 = 8,
		STAT_BIO = 8,
	)
	rarity_value = 23

/obj/item/oddity/common/old_pda
	name = "broken pda"
	desc = "An old Nanotrasen era PDA. These were issued to their employees all throu69hout the 69alaxy."
	icon_state = "old_pda"
	item_state = "electronic"
	oddity_stats = list(
		STAT_CO69 = 6,
		STAT_MEC = 6,
	)
	rarity_value = 15

/obj/item/oddity/common/towel
	name = "trustworthy towel"
	desc = "It's always 69ood to have one with you."
	icon_state = "towel"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_T69H = 6,
	)
	rarity_value = 15

/obj/item/oddity/common/teddy
	name = "teddy bear"
	desc = "He will be there for you, even in tou69h times."
	icon_state = "teddy"
	oddity_stats = list(
		STAT_ROB = 7,
		STAT_T69H = 7,
		STAT_VI69 = 7,
	)
	rarity_value = 20

/obj/item/oddity/common/old_knife
	name = "old knife"
	desc = "Is this blood older then you? You can't tell, and will never know."
	icon_state = "old_knife"
	item_state = "knife"
	structure_dama69e_factor = STRUCTURE_DAMA69E_BLADE
	tool_69ualities = list(69UALITY_CUTTIN69 = 20,  69UALITY_WIRE_CUTTIN69 = 10, 69UALITY_SCREW_DRIVIN69 = 5)
	force = WEAPON_FORCE_DAN69EROUS
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.o6969'
	slot_fla69s = SLOT_BELT
	sharp = TRUE
	ed69e = TRUE
	oddity_stats = list(
		STAT_ROB = 5,
		STAT_T69H = 5,
		STAT_VI69 = 5,
	)
	rarity_value = 22

/obj/item/oddity/common/old_id
	name = "old id"
	desc = "There is a story behind this name. Untold, and cruel in fate."
	icon_state = "old_id"
	oddity_stats = list(
		STAT_VI69 = 9,
	)

/obj/item/oddity/common/disk
	name = "broken desi69n disk"
	desc = "This disk is corrupted and completely unusable. It has a hand-drawn picture of some stran69e69echanism on it - lookin69 at it for too lon6969akes your head hurt."
	icon_state = "disc"
	oddity_stats = list(
		STAT_MEC = 9,
	)

/obj/item/oddity/common/mirror
	name = "cracked69irror"
	desc = "A thousand69irror ima69es stare back at you as you examine the trinket. What if you're the reflection, starin69 back out at the real world? At the real you?"
	icon_state = "mirror"
	oddity_stats = list(
		STAT_CO69 = 4,
		STAT_VI69 = 4,
	)
	rarity_value = 8

/obj/item/oddity/common/li69hter
	name = "rusted li69hter"
	desc = "This zippo li69her has been rusted shut. It smells faintly of sulphur and blood."
	icon_state = "syndicate_li69hter"
	oddity_stats = list(
		STAT_T69H = 9,
	)

/obj/item/oddity/common/device
	name = "odd device"
	desc = "Somethin69 about this 69ad69et both disturbs and interests you. It's69anufacturer's name has been69ostly smud69ed away, but you can see a stran69e69echanism as their lo69o."
	icon_state = "device"
	oddity_stats = list(
		STAT_MEC = 8,
		STAT_CO69 = 8,
	)
	rarity_value = 19

/obj/item/oddity/common/old_radio
	name = "old radio"
	desc = "Close your eyes, brin69 it closer and listen. You can almost hear it, in the ed69e of your consciousness. The World is tickin69."
	icon_state = "old_radio"
	oddity_stats = list(
		STAT_CO69 = 9,
		STAT_VI69 = 9,
	)
	rarity_value = 23

/obj/item/oddity/common/paper_bundle
	name = "paper bundle"
	desc = "Somewhere there is a truth, hidden under all of this scrap."
	icon_state = "paper_bundle"
	oddity_stats = list(
		STAT_BIO = 6,
		STAT_ROB = 6,
		STAT_VI69 = 6,
	)
	rarity_value = 16

/obj/item/oddity/techno
	name = "Unknown technolo69ical part"
	desc = "Technolo69ical part created by Techno-Tribalism Enforcer."
	icon_state = "techno_part1"

/obj/item/oddity/techno/Initialize()
	icon_state = "techno_part69rand(1,7)69"
	.=..()

/obj/item/oddity/broken_necklace
	name = "Broken necklace"
	desc = "A broken necklace that has a blue crystal as a trinket."
	icon_state = "broken_necklace"
	ori69in_tech = list(TECH_BLUESPACE = 9)
	spawn_fre69uency = 0//uni69ue
	oddity_stats = list(
		STAT_CO69 = 9,
		STAT_VI69 = 9,
		STAT_ROB = 9,
		STAT_T69H = 9,
		STAT_BIO = 9,
		STAT_MEC = 9
	)
	var/cooldown
	var/entropy_value = 5
	var/blink_ran69e = 8

/obj/item/oddity/broken_necklace/New()
	..()
	69LOB.bluespace_69ift++
	69LOB.bluespace_entropy -= rand(30, 50)

/obj/item/oddity/broken_necklace/examine(user, distance)
	. = ..()
	var/area/my_area = 69et_area(src)
	switch(my_area.bluespace_entropy)
		if(0 to69y_area.bluespace_hazard_threshold*0.3)
			to_chat(user, SPAN_NOTICE("This feels cold to the touch."))

		if(my_area.bluespace_hazard_threshold*0.7 to INFINITY)
			to_chat(user, SPAN_NOTICE("This feels warm to the touch."))

	if(69LOB.bluespace_entropy > 69LOB.bluespace_hazard_threshold*0.7)
		to_chat(user, SPAN_NOTICE("Has it always shone so bri69htly?"))

	if(my_area.bluespace_entropy >69y_area.bluespace_hazard_threshold*0.95 || 69LOB.bluespace_hazard_threshold > 69LOB.bluespace_hazard_threshold*0.95)
		to_chat(user, SPAN_NOTICE("You can see an inscription in some lan69ua69e unknown to you."))

/obj/item/oddity/broken_necklace/Destroy()
	var/turf/T = 69et_turf(src)
	if(T)
		bluespace_entropy(80,T)
		new /obj/item/bluespace_dust(T)
	69LOB.bluespace_69ift--
	return ..()

/obj/item/oddity/broken_necklace/attack_self(mob/user)
	if(world.time < cooldown)
		return
	cooldown = world.time + 3 SECONDS
	user.visible_messa69e(SPAN_WARNIN69("69user69 crushes 69src69!"), SPAN_DAN69ER("You crush 69src69!"))
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, 69et_turf(user))
	sparks.start()
	var/turf/T = 69et_random_secure_turf_in_ran69e(user, blink_ran69e, 2)
	69o_to_bluespace(69et_turf(user), entropy_value, TRUE, user, T)
	for(var/obj/item/69rab/69 in user.contents)
		if(69.affectin69)
			69o_to_bluespace(69et_turf(user), entropy_value, FALSE, 69.affectin69, locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
	if(prob(1))
		69del(src)

/obj/item/oddity/broken_necklace/throw_impact(atom/movable/hit_atom)
	if(!..()) // not cau69ht in69id-air
		visible_messa69e(SPAN_NOTICE("69src69 fizzles upon impact!"))
		var/turf/T = 69et_turf(hit_atom)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()
		if(!hit_atom.anchored)
			var/turf/NT = 69et_random_turf_in_ran69e(hit_atom, blink_ran69e, 2)
			69o_to_bluespace(T, entropy_value, TRUE, hit_atom, NT)
		if(prob(1))
			69del(src)

//A randomized oddity with random stats,69eant for artist job project
/obj/item/oddity/artwork
	name = "Stran69e Device"
	desc = "You can't find out how to turn it on.69aybe it's already workin69?"
	icon_state = "artwork_1"
	price_ta69 = 200
	prob_perk = 0//no perks for artwork oddities
	spawn_fre69uency = 0

/obj/item/oddity/artwork/Initialize()
	name = 69et_weapon_name(capitalize = TRUE)
	icon_state = "artwork_69rand(1,6)69"
	return ..()

/obj/item/oddity/artwork/69et_item_cost(export)
	. = ..()
	69ET_COMPONENT(comp_sanity, /datum/component/atom_sanity)
	. += comp_sanity.affect * 100
	69ET_COMPONENT(comp_insp, /datum/component/inspiration)
	var/list/true_stats = comp_insp.calculate_statistics()
	for(var/stat in true_stats)
		. += true_stats69stat69 * 50

//NT Oddities
/obj/item/oddity/nt
	bad_type = /obj/item/oddity/nt
	spawn_blacklisted = TRUE
	random_stats = FALSE

/obj/item/oddity/nt/seal
	name = "Hi69h In69uisitor's Seal"
	desc = "An honorary bad69e 69iven to the69ost devout of NeoTheolo69ian preachers by the Hi69h In69uisitor. Such a bad69e is a rare si69ht indeed - rumor has it that the bad69e imbues the holder with the power of the An69els themselves."
	icon_state = "nt_seal"
	oddity_stats = list(
		STAT_CO69 = 12,
		STAT_VI69 = 12,
		STAT_ROB = 8
	)
	price_ta69 = 8000
	perk = /datum/perk/nt_oddity/holy_li69ht

//Hivemind oddity
/obj/item/oddity/hivemind
	name = "Hivemind Oddity"
	desc = "You shouldn't be seein69 this. Report to your nearest reeducation camp comrade (report it on discord)."
	spawn_blacklisted = TRUE
	bad_type = /obj/item/oddity/hivemind

/obj/item/oddity/hivemind/old_radio
	name = "warped radio"
	desc = "An old radio covered in 69rowths. You can hear nothin69 from it, nothin69 but the sound of69achinery and souls be6969in69 for release."
	icon_state = "warped_radio"
	oddity_stats = list(
		STAT_CO69 = 8,
		STAT_VI69 = 8,
		STAT_MEC = 7,
	)

/obj/item/oddity/hivemind/old_pda
	name = "abnormal pda"
	desc = "An old Nanotrasen era PDA covered in 69rowths. Is the hive Nanotrasen's creation, or69ade by somethin69 worse?"
	icon_state = "abnormal_pda"
	oddity_stats = list(
		STAT_CO69 = 8,
		STAT_MEC = 8,
		STAT_VI69 = 7
	)

/obj/item/oddity/hivemind/hive_core
	name = "makeshift datapad"
	desc = "A69akeshift datapad covered in 69rowths. Whatever data was stored here is now 69one, part of it transferred to an unknown source, the rest simply wiped."
	icon_state = "hivemind_core"
	w_class = ITEM_SIZE_NORMAL
	random_stats = FALSE
	oddity_stats = list(
		STAT_CO69 = 8,
		STAT_VI69 = 8,
		STAT_MEC = 8,
		STAT_BIO = 8
	)
	perk = /datum/perk/hive_oddity/hive_born

//i copied the entire thin69 because beforehand it just did not work
/obj/item/oddity/hivemind/hive_core/Initialize()
	. = ..()
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	if(!perk && prob(prob_perk))
		perk = 69et_oddity_perk()

	if(oddity_stats)
		if(random_stats)
			for(var/stat in oddity_stats)
				oddity_stats69stat69 = rand(1, oddity_stats69stat69)
		AddComponent(/datum/component/inspiration, oddity_stats, perk)
	set_li69ht(2, 1, COLOR_BLUE_LI69HT)

/obj/item/oddity/pendant
	name = "pendant of Kultainen"
	desc = "An ornate 69olden necklace."
	icon_state = "69olden_necklace"
	slot_fla69s = SLOT_MASK
	ori69in_tech = list(TECH_MATERIAL = 3)
	matter = list(MATERIAL_69OLD = 4)
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	prob_perk = 0
	oddity_stats = list(
		STAT_MEC = 4,
		STAT_BIO = 4
	)
	var/produce_ready = TRUE
	var/produce_next

/obj/item/oddity/pendant/Destroy()
	STOP_PROCESSIN69(SSobj, src)
	. = ..()

/obj/item/oddity/pendant/Process()
	if(world.time > produce_next)
		visible_messa69e(SPAN_NOTICE("69src69 stops hummin69 suddenly."))
		src.desc = "An ornate 69olden necklace."
		produce_ready = TRUE
		STOP_PROCESSIN69(SSobj, src)
		. = ..()

/obj/item/oddity/pendant/attack_self(mob/user)
	if(produce_ready)
		new /obj/item/69olden_leaf(69et_turf(src))
		user.visible_messa69e(SPAN_NOTICE("69user69 opens 69src69, and a little 69olden leaf falls from it. \The 69src69 closes shut ri69ht after."), SPAN_NOTICE("As you open 69src69, a little 69olden leaf falls from it. \The 69src69 closes shut ri69ht after and start to hum 69uietly."))
		src.desc = "An ornate 69olden necklace. It's closed and hums 69uietly."
		produce_next = world.time + 1069INUTES
		produce_ready = FALSE
		START_PROCESSIN69(SSobj, src)
	else
		user.visible_messa69e(SPAN_NOTICE("69user69 tries to open 69src69 without success."), SPAN_NOTICE("You fail to open 69src69."))

/hook/roundstart/proc/place_pendant()
	var/obj/landmark/storyevent/potential_uni69ue_oddity_spawn/L = pick_landmark(/obj/landmark/storyevent/potential_uni69ue_oddity_spawn)
	new /obj/item/oddity/pendant(L.69et_loc())
	return TRUE

/obj/item/69olden_leaf
	name = "69olden leaf"
	desc = "Little piece of 69old resemblin69 a tea leaf."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "69olden_leaf"
	matter = list(MATERIAL_69OLD = 0.5)
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	w_class = ITEM_SIZE_TINY

/obj/item/69olden_leaf/afterattack(obj/tar69et,69ob/user, proximity)
	if(!proximity)
		return

	if(tar69et.is_refillable())
		if(!tar69et.rea69ents.has_rea69ent("water", 30))
			to_chat(user, SPAN_NOTICE("You need some water for that."))
		else
			tar69et.rea69ents.remove_rea69ent("water", 30)
			tar69et.rea69ents.add_rea69ent("oddity_tea", 30)
			to_chat(user, SPAN_NOTICE("You drop \the 69src69 in the water, it dissolves slowly."))
			69del(src)

/obj/item/clothin69/mask/69as/bi69_shot
	name = "bi69 shot69ask"
	desc = "A cheerful69ask of a cartoonish salesman."
	icon_state = "bi69_shot"
	item_state = "bi69_shot"


	armor = list(
		melee = 15,
		bullet = 15,
		ener69y = 15,
		bomb = 15,
		bio = 75,
		rad = 10
	)
	price_ta69 = 1997

	spawn_ta69s = SPAWN_TA69_ODDITY

/obj/item/clothin69/mask/69as/bi69_shot/e69uipped(mob/livin69/carbon/human/user, slot)
	..()
	if(slot == slot_wear_mask)
		user.stats.addPerk(/datum/perk/bi69_shot)
		var/datum/perk/bi69_shot/perk = user.stats.69etPerk(PERK_BI69_SHOT)
		perk.my_mask = src