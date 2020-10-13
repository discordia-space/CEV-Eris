#define MAX_FACTION_SCORE 1000
//////SCORE STUFF
//Goonstyle scoreboard
GLOBAL_VAR_INIT(score_crewscore, 0) // this is the overall var/score for the whole round
GLOBAL_VAR_INIT(score_stuffshipped, 0) // how many useful items have cargo shipped out?
GLOBAL_VAR_INIT(score_stuffharvested, 0) // how many harvests have hydroponics done?
GLOBAL_VAR_INIT(score_oremined, 0) // obvious
GLOBAL_VAR_INIT(score_researchdone, 0)
GLOBAL_VAR_INIT(score_eventsendured, 0) // how many random events did the station survive?
GLOBAL_VAR_INIT(score_escapees, 0) // how many people got out alive?
GLOBAL_VAR_INIT(score_deadcrew, 0) // dead bodies on the station, oh no
GLOBAL_VAR_INIT(score_mess, 0) // how much poo, puke, gibs, etc went uncleaned
GLOBAL_VAR_INIT(score_meals, 0)
GLOBAL_VAR_INIT(score_disease, 0) // how many rampant, uncured diseases are on board the station
GLOBAL_VAR_INIT(score_deadcommand, 0) // used during rev, how many command staff perished
GLOBAL_VAR_INIT(score_arrested, 0) // how many traitors/revs/whatever are alive in the brig
GLOBAL_VAR_INIT(score_traitorswon, 0) // how many traitors were successful?
GLOBAL_VAR_INIT(score_allarrested, 0) // did the crew catch all the enemies alive?
GLOBAL_VAR_INIT(score_opkilled, 0) // used during nuke mode, how many operatives died?
GLOBAL_VAR_INIT(score_disc, 0) // is the disc safe and secure?
GLOBAL_VAR_INIT(score_nuked, 0) // was the station blown into little bits?
GLOBAL_VAR_INIT(score_nuked_penalty, 0) //penalty for getting blown to bits

// these ones are mainly for the stat panel
GLOBAL_VAR_INIT(score_messbonus, 0) // if there are no messes on the station anywhere, huge bonus
GLOBAL_VAR_INIT(score_deadaipenalty, 0) // is the AI dead? if so, big penalty
GLOBAL_VAR_INIT(score_foodeaten, 0)	// nom nom nom
GLOBAL_VAR_INIT(score_clownabuse, 0)	// how many times a clown was punched, struck or otherwise maligned
GLOBAL_VAR(score_richestname)	// this is all stuff to show who was the richest alive on the shuttle
GLOBAL_VAR(score_richestjob)	// kinda pointless if you dont have a money system i guess
GLOBAL_VAR_INIT(score_richestcash, 0)
GLOBAL_VAR(score_richestkey)
GLOBAL_VAR(score_dmgestname) // who had the most damage on the shuttle (but was still alive)
GLOBAL_VAR(score_dmgestjob)
GLOBAL_VAR_INIT(score_dmgestdamage, 0)
GLOBAL_VAR(score_dmgestkey)


//TECHNOMANCERS
GLOBAL_VAR_INIT(technomancer_score, 0)
GLOBAL_VAR_INIT(initial_technomancer_score, 0)

GLOBAL_VAR_INIT(area_powerloss, 0) // how many APCs have poor charge?
GLOBAL_VAR_INIT(score_powerloss, 0)


GLOBAL_VAR_INIT(area_fireloss, 0) //air/fire issues
GLOBAL_VAR_INIT(score_fireloss, 0)

GLOBAL_VAR_INIT(score_ship_shield, 0)
GLOBAL_VAR_INIT(field_radius, 0)

GLOBAL_VAR_INIT(all_smes_powered, TRUE)
GLOBAL_VAR_INIT(score_smes_powered, 0)


GLOBAL_VAR_INIT(technomancer_objectives_completed, 0)
GLOBAL_VAR_INIT(score_technomancer_objectives, 0)
GLOBAL_VAR_INIT(technomancer_faction_item_loss, 0)
GLOBAL_VAR_INIT(score_technomancer_faction_item_loss, 0)

GLOBAL_VAR_INIT(ironhammer_score, 750)
GLOBAL_VAR_INIT(initial_ironhammer_score, 750)
GLOBAL_VAR_INIT(moebius_score, 0)
GLOBAL_VAR_INIT(initial_moebius_score, 0)
GLOBAL_VAR_INIT(neotheology_score, 250)
GLOBAL_VAR_INIT(initial_neotheology_score, 250)
GLOBAL_VAR_INIT(guild_score, 0)
GLOBAL_VAR_INIT(initial_guild_score, 0)


GLOBAL_VAR_INIT(ironhammer_objectives_score, 0)
GLOBAL_VAR_INIT(moebius_objectives_score, 0)
GLOBAL_VAR_INIT(neotheology_objectives_score, 0)
GLOBAL_VAR_INIT(guild_objectives_score, 0)

/datum/controller/subsystem/ticker/proc/scoreboard()
	//Thresholds for Score Ratings
	#define SINGULARITY_DESERVES_BETTER -3500
	#define SINGULARITY_FODDER -3000
	#define ALL_FIRED -2500
	#define WASTE_OF_OXYGEN -2000
	#define HEAP_OF_SCUM -1500
	#define LAB_MONKEYS -1000
	#define UNDESIREABLES -500
	#define SERVANTS_OF_SCIENCE 500
	#define GOOD_BUNCH 1000
	#define MACHINE_THIRTEEN 1500
	#define PROMOTIONS_FOR_EVERYONE 2000
	#define AMBASSADORS_OF_DISCOVERY 3000
	#define PRIDE_OF_SCIENCE 4000
	#define NANOTRANSEN_FINEST 5000

	// Score Calculation and Display

	// Who is alive/dead, who escaped
	for(var/mob/living/silicon/ai/I in GLOB.player_list)//evan vigila esto
		if(I.stat == DEAD && isStationLevel(I.z))
			GLOB.score_deadaipenalty++
			GLOB.score_deadcrew++

	for(var/thing in GLOB.human_mob_list)
		var/mob/living/carbon/human/I = thing
		if(I.stat == DEAD && isStationLevel(I.z))
			GLOB.score_deadcrew++

	//if(SSshuttle.emergency.mode >= SHUTTLE_ENDGAME)
	for(var/mob/living/player in GLOB.player_list)//evan vigila esto
		if(player.stat != DEAD)
			var/turf/location = get_turf(player.loc)
			var/area/escape_zone = locate(/area/shuttle/escape)
			if(location in escape_zone)
				GLOB.score_escapees++

	var/cash_score = 0
	var/dmg_score = 0

	//if(SSshuttle.emergency.mode >= SHUTTLE_ENDGAME)
	for(var/thing in GLOB.human_mob_list)
		var/mob/living/carbon/human/E = thing
		cash_score = 0
		dmg_score = 0
		var/turf/location = get_turf(E.loc)
		//var/area/escape_zone = SSshuttle.emergency.areaInstance

		if(E.stat != DEAD && location)// && (location in escape_zone)) // Escapee Scores
			cash_score = get_score_container_worth(E)

			if(cash_score > GLOB.score_richestcash)
				GLOB.score_richestcash = cash_score
				GLOB.score_richestname = E.real_name
				GLOB.score_richestjob = E.job
				GLOB.score_richestkey = E.key

			dmg_score = E.getBruteLoss() + E.getFireLoss() + E.getToxLoss() + E.getOxyLoss()
			if(dmg_score > GLOB.score_dmgestdamage)
				GLOB.score_dmgestdamage = dmg_score
				GLOB.score_dmgestname = E.real_name
				GLOB.score_dmgestjob = E.job
				GLOB.score_dmgestkey = E.key

	//if(SSticker && SSticker.mode)
	//	SSticker.mode.set_scoreboard_gvars()

	//init technomancer score
	var/obj/item/weapon/cell/large/high/HC = /obj/item/weapon/cell/large/high
	var/min_chage = initial(HC.maxcharge) * 0.6
	// Check station's power levels
	for(var/area/A in ship_areas)//evan revisa esto
		if(A.fire || A.atmosalm)
			GLOB.area_fireloss++
		if(!A.apc)
			GLOB.area_powerloss++ 
			continue
		for(var/obj/item/weapon/cell/C in A.apc.contents)
			if(C.charge < min_chage)
				GLOB.area_powerloss++

	var/smes_count = 0
	for(var/obj/machinery/power/smes/S in SSmachines.machinery)//evan revisa esto
		if(!isStationLevel(S.z)) continue
		smes_count++
		if(S.charge < S.capacity*0.7)
			GLOB.all_smes_powered = FALSE
			break
	if(smes_count == 0)
		GLOB.all_smes_powered = FALSE


	for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery)//evan revisa esto
		if(!isStationLevel(S.z)) continue
		smes_count++
		if(!S.running) continue
		GLOB.field_radius += S.field_radius
	GLOB.field_radius = CLAMP(GLOB.field_radius, 0, world.maxx)



	// Modifiers
	if(GLOB.all_smes_powered)
		GLOB.score_smes_powered = 350 //max = 350
	GLOB.score_technomancer_objectives = GLOB.technomancer_objectives_completed * 25
	GLOB.score_ship_shield = 2 * GLOB.field_radius //max ~= 500
	GLOB.score_fireloss -= GLOB.area_fireloss * 25
	GLOB.score_powerloss -= GLOB.area_powerloss * 25
	GLOB.score_technomancer_faction_item_loss -= 150 * GLOB.technomancer_faction_item_loss
	GLOB.technomancer_score = GLOB.initial_technomancer_score + GLOB.score_smes_powered + GLOB.score_technomancer_objectives + GLOB.score_ship_shield + GLOB.score_fireloss + GLOB.score_powerloss + GLOB.score_technomancer_faction_item_loss
	//END technomancers

	// Check how much uncleaned mess is on the station
	for(var/obj/effect/decal/cleanable/M in world)
		if(!isStationLevel(M.z)) continue
		var/area/A = get_area(M)
		if(!(A in ship_areas)) continue
		if(A.is_maintenance) continue
		if(istype(M, /obj/effect/decal/cleanable/blood/gibs))
			GLOB.score_mess += 3

		if(istype(M, /obj/effect/decal/cleanable/blood))
			GLOB.score_mess += 1

		if(istype(M, /obj/effect/decal/cleanable/vomit))
			GLOB.score_mess += 1


	// Bonus Modifiers
	var/deathpoints = GLOB.score_deadcrew * 25 //done
	var/researchpoints = GLOB.score_researchdone * 30
	var/eventpoints = GLOB.score_eventsendured * 50
	var/escapoints = GLOB.score_escapees * 25 //done
	var/harvests = GLOB.score_stuffharvested * 5
	var/shipping = GLOB.score_stuffshipped * 5
	var/mining = GLOB.score_oremined * 2 //done, might want polishing
	var/meals = GLOB.score_meals * 5
	var/messpoints

	if(GLOB.score_mess != 0)
		messpoints = GLOB.score_mess //done
	var/plaguepoints = GLOB.score_disease * 30


	// Good Things
	GLOB.score_crewscore += shipping
	GLOB.score_crewscore += harvests
	GLOB.score_crewscore += mining
	GLOB.score_crewscore += researchpoints
	GLOB.score_crewscore += eventpoints
	GLOB.score_crewscore += escapoints


	GLOB.score_crewscore += meals
	if(GLOB.score_allarrested) // This only seems to be implemented for Rev and Nukies. -DaveKorhal
		GLOB.score_crewscore *= 3 // This needs to be here for the bonus to be applied properly


	GLOB.score_crewscore -= deathpoints
	if(GLOB.score_deadaipenalty)
		GLOB.score_crewscore -= 250


	GLOB.score_crewscore -= messpoints
	GLOB.score_crewscore -= plaguepoints

	// Show the score - might add "ranks" later
	to_chat(world, "<b>The crew's final score is:</b>")
	to_chat(world, "<b><font size='4'>[GLOB.score_crewscore]</font></b>")
	for(var/mob/E in GLOB.player_list)
		//if(E.client && !E.get_preference(PREFTOGGLE_DISABLE_SCOREBOARD))
		E.scorestats()

// A recursive function to properly determine the wealthiest escapee
/datum/controller/subsystem/ticker/proc/get_score_container_worth(atom/C, level=0)
	if(level >= 5)
		// in case the containers recurse or something
		return 0
	else
		. = 0
		//for(var/obj/item/weapon/card/id/id in C.contents)
			//var/datum/money_account/A = get_money_account(id.associated_account_number)revisa esto
			// has an account?
		//	if(A)
		//		. += A.money
		for(var/obj/item/weapon/spacecash/cash in C.contents)
			. += cash.worth
		for(var/obj/item/weapon/storage/S in C.contents)
			. += .(S, level + 1)

/datum/game_mode/proc/get_scoreboard_stats()
	return

/datum/game_mode/proc/set_scoreboard_gvars()
	return
/* backup
/mob/proc/scorestats()
	var/dat = "<b>Round Statistics and Score</b><br><hr>"
	//if(SSticker && SSticker.mode)
	//	dat += SSticker.mode.get_scoreboard_stats()

	dat += {"
	<b><u>General Statistics</u></b><br>
	<u>The Good</u><br>
	<b>Ore Mined:</b> [GLOB.score_oremined] ([GLOB.score_oremined * 2] Points)<br>"}
	//if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME) dat += "<b>Shuttle Escapees:</b> [GLOB.score_escapees] ([GLOB.score_escapees * 25] Points)<br>"
	dat += {"
	<b>Whole Station Powered:</b> [GLOB.score_powerbonus ? "Yes" : "No"] ([GLOB.score_powerbonus * 2500] Points)<br><br>

	<U>The Bad</U><br>
	<b>Dead bodies on Station:</b> [GLOB.score_deadcrew] (-[GLOB.score_deadcrew * 25] Points)<br>
	<b>Uncleaned Messes:</b> [GLOB.score_mess] (-[GLOB.score_mess] Points)<br>
	<b>Station Power Issues:</b> [GLOB.score_powerloss] (-[GLOB.score_powerloss * 20] Points)<br>
	<b>AI Destroyed:</b> [GLOB.score_deadaipenalty ? "Yes" : "No"] (-[GLOB.score_deadaipenalty * 250] Points)<br><br>

	<U>The Weird</U><br>
	<b>Food Eaten:</b> [GLOB.score_foodeaten] bites/sips<br>
	<b>Times a Clown was Abused:</b> [GLOB.score_clownabuse]<br><br>
	"}
	if(GLOB.score_escapees)
		dat += {"<b>Richest Escapee:</b> [GLOB.score_richestname], [GLOB.score_richestjob]: $[num2text(GLOB.score_richestcash,50)] ([GLOB.score_richestkey])<br>
		<b>Most Battered Escapee:</b> [GLOB.score_dmgestname], [GLOB.score_dmgestjob]: [GLOB.score_dmgestdamage] damage ([GLOB.score_dmgestkey])<br>"}
	else
		//if(SSshuttle.emergency.mode <= SHUTTLE_STRANDED)
		//	dat += "The station wasn't evacuated!<br>"
		//else
		dat += "No-one escaped!<br>"

	//dat += SSticker.mode.declare_job_completion()

	dat += {"
	<hr><br>
	<b><u>FINAL SCORE: [GLOB.score_crewscore]</u></b><br>
	"}

	var/score_rating = "The Aristocrats!"
	switch(GLOB.score_crewscore)
		if(-99999 to SINGULARITY_DESERVES_BETTER) score_rating = 					"Even the Singularity Deserves Better"
		if(SINGULARITY_DESERVES_BETTER+1 to SINGULARITY_FODDER) score_rating = 		"Singularity Fodder"
		if(SINGULARITY_FODDER+1 to ALL_FIRED) score_rating = 						"You're All Fired"
		if(ALL_FIRED+1 to WASTE_OF_OXYGEN) score_rating = 							"A Waste of Perfectly Good Oxygen"
		if(WASTE_OF_OXYGEN+1 to HEAP_OF_SCUM) score_rating = 						"A Wretched Heap of Scum and Incompetence"
		if(HEAP_OF_SCUM+1 to LAB_MONKEYS) score_rating = 							"Outclassed by Lab Monkeys"
		if(LAB_MONKEYS+1 to UNDESIREABLES) score_rating = 							"The Undesirables"
		if(UNDESIREABLES+1 to SERVANTS_OF_SCIENCE-1) score_rating = 				"Ambivalently Average"
		if(SERVANTS_OF_SCIENCE to GOOD_BUNCH-1) score_rating = 						"Skillful Servants of Science"
		if(GOOD_BUNCH to MACHINE_THIRTEEN-1) score_rating = 						"Best of a Good Bunch"
		if(MACHINE_THIRTEEN to PROMOTIONS_FOR_EVERYONE-1) score_rating = 			"Lean Mean Machine Thirteen"
		if(PROMOTIONS_FOR_EVERYONE to AMBASSADORS_OF_DISCOVERY-1) score_rating = 	"Promotions for Everyone"
		if(AMBASSADORS_OF_DISCOVERY to PRIDE_OF_SCIENCE-1) score_rating = 			"Ambassadors of Discovery"
		if(PRIDE_OF_SCIENCE to NANOTRANSEN_FINEST-1) score_rating = 				"The Pride of Science Itself"
		if(NANOTRANSEN_FINEST to INFINITY) score_rating = 							"Nanotrasen's Finest"

	dat += "<b><u>RATING:</u></b> [score_rating]"
	src << browse(dat, "window=roundstats;size=500x600")

	#undef SINGULARITY_DESERVES_BETTER
	#undef SINGULARITY_FODDER
	#undef ALL_FIRED
	#undef WASTE_OF_OXYGEN
	#undef HEAP_OF_SCUM
	#undef LAB_MONKEYS
	#undef UNDESIREABLES
	#undef SERVANTS_OF_SCIENCE
	#undef GOOD_BUNCH
	#undef MACHINE_THIRTEEN
	#undef PROMOTIONS_FOR_EVERYONE
	#undef AMBASSADORS_OF_DISCOVERY
	#undef PRIDE_OF_SCIENCE
	#undef NANOTRANSEN_FINEST

backup */

/proc/get_color_score(msg, score, maxscore=MAX_FACTION_SCORE)
	if(score>maxscore*0.5)
		return "<font color='green'>[msg]</font>"
	return "<font color='red'>[msg]</font>"

/proc/to_score_color(nnum)
	if(nnum > 0)
		return green_text(nnum)
	if(nnum < 0)
		return red_text(nnum)
	return "[nnum]"

/proc/green_text(msg)
	return "<font color='green'>[msg]</font>"

/proc/red_text(msg)
	return "<font color='red'>[msg]</font>"

/mob/proc/scorestats()
	var/dat = "<b>Round Statistics and Score</b><br><hr>"
	//if(SSticker && SSticker.mode)
	//	dat += SSticker.mode.get_scoreboard_stats()

	dat += {"
	<b><u>Faction Scores</u></b><br>
	<u>Technomancers scores</u><br>
	<b>Base score:</b> [green_text(GLOB.initial_technomancer_score)]<br>
	<b>Faction Objectives:</b> [GLOB.technomancer_objectives_completed] ([to_score_color(GLOB.score_technomancer_objectives)] Points)<br>
	<b>All smes chargered:</b> [GLOB.all_smes_powered ? "Yes" : "No"] ([to_score_color(GLOB.score_smes_powered)] Points)<br>
	<b>Alcance del escudo:</b> [GLOB.field_radius] ([to_score_color(GLOB.score_ship_shield)] Points)<br>
	<b>Faction item perdidos:</b> [GLOB.technomancer_faction_item_loss] ([to_score_color(GLOB.score_technomancer_faction_item_loss)] Points)<br>
	<b>Areas sin energia:</b> [GLOB.area_powerloss] ([to_score_color(GLOB.score_powerloss)] Points)<br>
	<b>Areas con problemas atmosfericos:</b> [GLOB.area_fireloss] ([to_score_color(GLOB.score_fireloss)] Points)<br>
	<b>Final score:</b> [get_color_score(GLOB.technomancer_score, GLOB.technomancer_score)] Points<br>
	"}

	/*
	dat += {"
	<b><u>General Statistics</u></b><br>
	<u>The Good</u><br>
	<b>Ore Mined:</b> [GLOB.score_oremined] ([GLOB.score_oremined * 2] Points)<br>"}
	//if(SSshuttle.emergency.mode == SHUTTLE_ENDGAME) dat += "<b>Shuttle Escapees:</b> [GLOB.score_escapees] ([GLOB.score_escapees * 25] Points)<br>"
	dat += {"
	<b>Whole Station Powered:</b> [GLOB.score_powerbonus ? "No" : "Yes"] ([GLOB.score_powerbonus * 2500] Points)<br><br>

	<U>The Bad</U><br>
	<b>Dead bodies on Station:</b> [GLOB.score_deadcrew] (-[GLOB.score_deadcrew * 25] Points)<br>
	<b>Uncleaned Messes:</b> [GLOB.score_mess] (-[GLOB.score_mess] Points)<br>
	<b>Station Power Issues:</b> [GLOB.score_powerloss] (-[GLOB.score_powerloss * 20] Points)<br>
	<b>AI Destroyed:</b> [GLOB.score_deadaipenalty ? "Yes" : "No"] (-[GLOB.score_deadaipenalty * 250] Points)<br><br>

	<U>The Weird</U><br>
	<b>Food Eaten:</b> [GLOB.score_foodeaten] bites/sips<br>
	<b>Times a Clown was Abused:</b> [GLOB.score_clownabuse]<br><br>
	"}
	*/
	if(GLOB.score_escapees)
		dat += {"<b>Richest Escapee:</b> [GLOB.score_richestname], [GLOB.score_richestjob]: $[num2text(GLOB.score_richestcash,50)] ([GLOB.score_richestkey])<br>
		<b>Most Battered Escapee:</b> [GLOB.score_dmgestname], [GLOB.score_dmgestjob]: [GLOB.score_dmgestdamage] damage ([GLOB.score_dmgestkey])<br>"}
	else
		//if(SSshuttle.emergency.mode <= SHUTTLE_STRANDED)
		//	dat += "The station wasn't evacuated!<br>"
		//else
		dat += "No-one escaped!<br>"

	//dat += SSticker.mode.declare_job_completion()

	dat += {"
	<hr><br>
	<b><u>FINAL SCORE: [GLOB.score_crewscore]</u></b><br>
	"}

	var/score_rating = "The Aristocrats!"
	switch(GLOB.score_crewscore)
		if(-99999 to SINGULARITY_DESERVES_BETTER) score_rating = 					"Even the Singularity Deserves Better"
		if(SINGULARITY_DESERVES_BETTER+1 to SINGULARITY_FODDER) score_rating = 		"Singularity Fodder"
		if(SINGULARITY_FODDER+1 to ALL_FIRED) score_rating = 						"You're All Fired"
		if(ALL_FIRED+1 to WASTE_OF_OXYGEN) score_rating = 							"A Waste of Perfectly Good Oxygen"
		if(WASTE_OF_OXYGEN+1 to HEAP_OF_SCUM) score_rating = 						"A Wretched Heap of Scum and Incompetence"
		if(HEAP_OF_SCUM+1 to LAB_MONKEYS) score_rating = 							"Outclassed by Lab Monkeys"
		if(LAB_MONKEYS+1 to UNDESIREABLES) score_rating = 							"The Undesirables"
		if(UNDESIREABLES+1 to SERVANTS_OF_SCIENCE-1) score_rating = 				"Ambivalently Average"
		if(SERVANTS_OF_SCIENCE to GOOD_BUNCH-1) score_rating = 						"Skillful Servants of Science"
		if(GOOD_BUNCH to MACHINE_THIRTEEN-1) score_rating = 						"Best of a Good Bunch"
		if(MACHINE_THIRTEEN to PROMOTIONS_FOR_EVERYONE-1) score_rating = 			"Lean Mean Machine Thirteen"
		if(PROMOTIONS_FOR_EVERYONE to AMBASSADORS_OF_DISCOVERY-1) score_rating = 	"Promotions for Everyone"
		if(AMBASSADORS_OF_DISCOVERY to PRIDE_OF_SCIENCE-1) score_rating = 			"Ambassadors of Discovery"
		if(PRIDE_OF_SCIENCE to NANOTRANSEN_FINEST-1) score_rating = 				"The Pride of Science Itself"
		if(NANOTRANSEN_FINEST to INFINITY) score_rating = 							"Nanotrasen's Finest"

	dat += "<b><u>RATING:</u></b> [score_rating]"
	src << browse(dat, "window=roundstats;size=500x600")

	#undef SINGULARITY_DESERVES_BETTER
	#undef SINGULARITY_FODDER
	#undef ALL_FIRED
	#undef WASTE_OF_OXYGEN
	#undef HEAP_OF_SCUM
	#undef LAB_MONKEYS
	#undef UNDESIREABLES
	#undef SERVANTS_OF_SCIENCE
	#undef GOOD_BUNCH
	#undef MACHINE_THIRTEEN
	#undef PROMOTIONS_FOR_EVERYONE
	#undef AMBASSADORS_OF_DISCOVERY
	#undef PRIDE_OF_SCIENCE
	#undef NANOTRANSEN_FINEST

