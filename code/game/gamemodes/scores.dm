GLOBAL_VAR_INIT(score_crewscore, 1000)
#define MAX_FACTION_SCORE 1000

//moebius
GLOBAL_VAR_INIT(moebius_score, 0)
GLOBAL_VAR_INIT(initial_moebius_score, 0)

GLOBAL_VAR_INIT(moebius_objectives_completed, 0)
GLOBAL_VAR_INIT(moebius_objectives_score, 0)

GLOBAL_VAR_INIT(moebius_faction_item_loss, 0)
GLOBAL_VAR_INIT(score_moebius_faction_item_loss, 0)


GLOBAL_VAR_INIT(crew_dead, 0)
GLOBAL_VAR_INIT(score_crew_dead, 0)


GLOBAL_VAR_INIT(research_point_gained, 0)
GLOBAL_VAR_INIT(score_research_point_gained, 0)


GLOBAL_LIST_EMPTY(moebius_autopsies_mobs)
GLOBAL_VAR_INIT(score_moebius_autopsies_mobs, 0)

//ironhammer
GLOBAL_VAR_INIT(ironhammer_score, 0)
GLOBAL_VAR_INIT(initial_ironhammer_score, 750)

GLOBAL_VAR_INIT(ironhammer_objectives_completed, 0)
GLOBAL_VAR_INIT(ironhammer_objectives_score, 0)

GLOBAL_VAR_INIT(ironhammer_faction_item_loss, 0)
GLOBAL_VAR_INIT(score_ironhammer_faction_item_loss, 0)

GLOBAL_VAR_INIT(completed_antag_contracts, 0)
GLOBAL_VAR_INIT(score_antag_contracts, 0)

GLOBAL_VAR_INIT(captured_or_dead_antags, 0)
GLOBAL_VAR_INIT(captured_or_dead_antags_score, 0)

GLOBAL_VAR_INIT(ironhammer_operative_dead, 0)
GLOBAL_VAR_INIT(ironhammer_operative_dead_score, 0)

//Neotheology_score
GLOBAL_VAR_INIT(neotheology_score, 0)
GLOBAL_VAR_INIT(initial_neotheology_score, 250)

GLOBAL_VAR_INIT(neotheology_objectives_completed, 0)
GLOBAL_VAR_INIT(neotheology_objectives_score, 0)

GLOBAL_VAR_INIT(score_neotheology_faction_item_loss, 0)
GLOBAL_VAR_INIT(neotheology_faction_item_loss, 0)

GLOBAL_VAR_INIT(dirt_areas, 0) // dirt areas
GLOBAL_VAR_INIT(score_mess, 0)

GLOBAL_VAR_INIT(biomatter_neothecnology_amt, 0)
GLOBAL_VAR_INIT(biomatter_score, 0)

GLOBAL_VAR_INIT(grup_ritual_performed, 0)
GLOBAL_VAR_INIT(grup_ritual_score, 0)

GLOBAL_VAR_INIT(new_neothecnology_convert_score, 0)
GLOBAL_VAR_INIT(new_neothecnology_convert, 0)

//guild
GLOBAL_VAR_INIT(initial_guild_score, 0)
GLOBAL_VAR_INIT(guild_score, 0)

GLOBAL_VAR_INIT(guild_objectives_completed, 0)
GLOBAL_VAR_INIT(guild_objectives_score, 0)

GLOBAL_VAR_INIT(guild_faction_item_loss, 0)
GLOBAL_VAR_INIT(score_guild_faction_item_loss, 0)

GLOBAL_VAR_INIT(supply_profit, 0)
GLOBAL_VAR_INIT(guild_profit_score, 0)

GLOBAL_VAR_INIT(guild_shared_gears_score, 0)
GLOBAL_VAR_INIT(guild_shared_gears, 0)

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
	var/list/guild_fingerprints = new
	for(var/datum/mind/M in SSticker.minds)
		if(!M.current)
			continue
		if(M.current.stat == DEAD)
			if(M.assigned_job && M.assigned_job.faction == "CEV Eris")
				if(M.assigned_job.department == DEPARTMENT_SECURITY)
					GLOB.ironhammer_operative_dead++
				if(!M.antagonist.len)
					GLOB.crew_dead++
			if(M.antagonist.len)
				GLOB.captured_or_dead_antags++
		else
			if(M.antagonist.len)
				var/area/A = get_area(M.current)
				if(istype(A, /area/eris/security/prison) || istype(A, /area/eris/security/brig) || M.current.restrained())
					GLOB.captured_or_dead_antags++
			else if(M.assigned_job && M.assigned_job.department == DEPARTMENT_GUILD && ishuman(M.current))
				var/mob/living/carbon/human/H = M.current
				guild_fingerprints += H.get_full_print()

	for(var/mob/living/carbon/human/H in (GLOB.player_list & GLOB.human_mob_list  & GLOB.living_mob_list))
		if(H.mind && H.mind.assigned_job && H.mind.assigned_job.faction == "CEV Eris" && H.mind.assigned_job.department != DEPARTMENT_GUILD && !H.mind.antagonist.len)
			for(var/obj/item/I in H.GetAllContents())
				var/full_print = H.get_full_print()
				if(full_print in guild_fingerprints)
					GLOB.guild_shared_gears++
					break

	//init technomancer score
	var/obj/item/weapon/cell/large/high/HC = /obj/item/weapon/cell/large/high
	var/min_chage = initial(HC.maxcharge) * 0.6
	// Check station's power levels
	for(var/area/A in ship_areas)
		if(A.fire || A.atmosalm)
			GLOB.area_fireloss++
		if(!A.apc)
			GLOB.area_powerloss++ 
			continue
		for(var/obj/item/weapon/cell/C in A.apc.contents)
			if(C.charge < min_chage)
				GLOB.area_powerloss++

	var/smes_count = 0
	for(var/obj/machinery/power/smes/S in SSmachines.machinery)
		if(!isStationLevel(S.z)) continue
		smes_count++
		if(S.charge < S.capacity*0.7)
			GLOB.all_smes_powered = FALSE
			break
	if(smes_count == 0)
		GLOB.all_smes_powered = FALSE

	for(var/obj/machinery/power/shield_generator/S in SSmachines.machinery)
		if(!isStationLevel(S.z)) continue
		smes_count++
		if(!S.running) continue
		GLOB.field_radius += S.field_radius
	GLOB.field_radius = CLAMP(GLOB.field_radius, 0, world.maxx)

	// technomancer Modifiers
	if(GLOB.all_smes_powered)
		GLOB.score_smes_powered = 350 //max = 350
	GLOB.score_technomancer_objectives = GLOB.technomancer_objectives_completed * 25 //max: ~= 100
	GLOB.score_ship_shield = 2 * GLOB.field_radius //max ~= 500
	GLOB.score_fireloss -= GLOB.area_fireloss * 25
	GLOB.score_powerloss -= GLOB.area_powerloss * 25
	GLOB.score_technomancer_faction_item_loss -= 150 * GLOB.technomancer_faction_item_loss

	GLOB.technomancer_score = GLOB.initial_technomancer_score + GLOB.score_smes_powered + GLOB.score_technomancer_objectives + GLOB.score_ship_shield + GLOB.score_fireloss + GLOB.score_powerloss + GLOB.score_technomancer_faction_item_loss

	// NeoTheology score
	var/list/dirt_areas = list()
	// Check how much uncleaned mess is on the station
	for(var/obj/effect/decal/cleanable/M in world)
		if(!isStationLevel(M.z)) continue
		var/area/A = get_area(M)
		if(A in dirt_areas) continue
		if(!(A in ship_areas)) continue
		if(A.is_maintenance) continue
		dirt_areas += A
	GLOB.dirt_areas = dirt_areas.len


	// NeoTheology Modifiers
	GLOB.score_neotheology_faction_item_loss -= GLOB.neotheology_faction_item_loss * 150 //300
	GLOB.neotheology_objectives_score = GLOB.neotheology_objectives_completed * 25 // ~100
	GLOB.score_mess -= GLOB.dirt_areas * 25 //~250
	GLOB.biomatter_score = round(min(GLOB.biomatter_neothecnology_amt/10, 350)) //350
	GLOB.grup_ritual_score += GLOB.grup_ritual_performed * 5
	GLOB.new_neothecnology_convert_score = GLOB.new_neothecnology_convert * 50 // ~150-300

	GLOB.neotheology_score = GLOB.initial_neotheology_score + GLOB.score_neotheology_faction_item_loss + GLOB.neotheology_objectives_score + GLOB.score_mess + GLOB.grup_ritual_score + GLOB.biomatter_score + GLOB.new_neothecnology_convert_score


	//Moebius score 
	GLOB.score_moebius_faction_item_loss -= GLOB.moebius_faction_item_loss * 150 //300
	GLOB.moebius_objectives_score = GLOB.moebius_objectives_completed * 25 // ~100
	GLOB.score_crew_dead -=	GLOB.crew_dead++ * 200 // ~200
	GLOB.score_research_point_gained = round(GLOB.research_point_gained / 20) // or /100? review it
	GLOB.score_moebius_autopsies_mobs = GLOB.moebius_autopsies_mobs.len * 15 // ~75

	GLOB.moebius_score = GLOB.initial_moebius_score + GLOB.score_moebius_faction_item_loss + GLOB.moebius_objectives_score + GLOB.score_crew_dead + GLOB.score_research_point_gained + GLOB.score_moebius_autopsies_mobs

	//ironhammer score
	GLOB.score_ironhammer_faction_item_loss -= 150 * GLOB.ironhammer_faction_item_loss
	GLOB.ironhammer_objectives_score = GLOB.ironhammer_objectives_completed * 25
	GLOB.score_antag_contracts -= GLOB.completed_antag_contracts * 30
	GLOB.ironhammer_operative_dead_score -= GLOB.ironhammer_operative_dead * 50
	GLOB.captured_or_dead_antags_score = 100 * GLOB.captured_or_dead_antags

	GLOB.ironhammer_score = GLOB.initial_ironhammer_score + GLOB.ironhammer_objectives_score + GLOB.score_antag_contracts + GLOB.ironhammer_operative_dead_score + GLOB.captured_or_dead_antags_score

	//guild score
	GLOB.score_guild_faction_item_loss -= 150 * GLOB.guild_faction_item_loss // ~-300
	GLOB.guild_objectives_score = GLOB.guild_objectives_completed * 25 // ~100
	GLOB.guild_profit_score	= min(round(GLOB.supply_profit/50), 0) // ? review it
	GLOB.guild_shared_gears_score = GLOB.guild_shared_gears * 30 // ~150-300

	GLOB.guild_score = GLOB.initial_guild_score + GLOB.guild_objectives_score + GLOB.guild_profit_score


	// Show the score - might add "ranks" later
	//to_chat(world, "<b>The crew's final score is:</b>")
	//to_chat(world, "<b><font size='4'>[GLOB.score_crewscore]</font></b>")
	for(var/mob/E in GLOB.player_list)
		//if(E.client && !E.get_preference(PREFTOGGLE_DISABLE_SCOREBOARD))
		E.scorestats()


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
//ironhammer

	dat += {"
	<b><u>Faction Scores</u></b><br>
	<u>Ironhammer scores</u><br>
	<b>Base score:</b> [green_text(GLOB.initial_ironhammer_score)]<br>
	<b>Faction item perdidos:</b> [GLOB.ironhammer_faction_item_loss] ([to_score_color(GLOB.score_ironhammer_faction_item_loss)] Points)<br>
	<b>Faction Objectives:</b> [GLOB.ironhammer_objectives_completed] ([to_score_color(GLOB.ironhammer_objectives_score)] Points)<br>
	<b>contratos completados:</b> [GLOB.completed_antag_contracts] ([to_score_color(GLOB.score_antag_contracts)] Points)<br>
	<b>antags capturados o asesinados:</b> [GLOB.captured_or_dead_antags] ([to_score_color(GLOB.captured_or_dead_antags_score)] Points)<br>
	<b>operativos muertos:</b> [GLOB.ironhammer_operative_dead] ([to_score_color(GLOB.ironhammer_operative_dead_score)] Points)<br>
	<b>Final score:</b> [get_color_score(GLOB.ironhammer_score, MAX_FACTION_SCORE)] Points<br>
	"}

	dat += {"
	<b><u>Faction Scores</u></b><br>
	<u>moebius scores</u><br>
	<b>Base score:</b> [green_text(GLOB.initial_moebius_score)]<br>
	<b>Faction item perdidos:</b> [GLOB.moebius_faction_item_loss] ([to_score_color(GLOB.score_moebius_faction_item_loss)] Points)<br>
	<b>Faction Objectives:</b> [GLOB.moebius_objectives_completed] ([to_score_color(GLOB.moebius_objectives_score)] Points)<br>
	<b>tripulacion muerta:</b> [GLOB.completed_antag_contracts] ([to_score_color(GLOB.score_antag_contracts)] Points)<br>
	<b>research poitns ganados:</b> [GLOB.research_point_gained] ([to_score_color(GLOB.score_research_point_gained)] Points)<br>
	<b>autopsias realizadas:</b> [GLOB.moebius_autopsies_mobs] ([to_score_color(GLOB.score_moebius_autopsies_mobs)] Points)<br>
	<b>Final score:</b> [get_color_score(GLOB.moebius_score, MAX_FACTION_SCORE)] Points<br>
	"}

GLOBAL_VAR_INIT(neotheology_score, 0)
GLOBAL_VAR_INIT(initial_neotheology_score, 250)

GLOBAL_VAR_INIT(neotheology_objectives_completed, 0)
GLOBAL_VAR_INIT(neotheology_objectives_score, 0)

GLOBAL_VAR_INIT(score_neotheology_faction_item_loss, 0)
GLOBAL_VAR_INIT(neotheology_faction_item_loss, 0)

GLOBAL_VAR_INIT(dirt_areas, 0) // dirt areas
GLOBAL_VAR_INIT(score_mess, 0)

GLOBAL_VAR_INIT(biomatter_neothecnology_amt, 0)
GLOBAL_VAR_INIT(biomatter_score, 0)

GLOBAL_VAR_INIT(grup_ritual_performed, 0)
GLOBAL_VAR_INIT(grup_ritual_score, 0)

GLOBAL_VAR_INIT(new_neothecnology_convert_score, 0)
GLOBAL_VAR_INIT(new_neothecnology_convert, 0)

	dat += {"
	<b><u>Faction Scores</u></b><br>
	<u>neotechnology scores</u><br>
	<b>Base score:</b> [green_text(GLOB.initial_neotheology_score)]<br>
	<b>Faction item perdidos:</b> [GLOB.neotheology_faction_item_loss] ([to_score_color(GLOB.score_neotheology_faction_item_loss)] Points)<br>
	<b>Faction Objectives:</b> [GLOB.neotheology_objectives_completed] ([to_score_color(GLOB.neotheology_objectives_score)] Points)<br>
	<b>tripulacion muerta:</b> [GLOB.completed_antag_contracts] ([to_score_color(GLOB.score_antag_contracts)] Points)<br>
	<b>research poitns ganados:</b> [GLOB.research_point_gained] ([to_score_color(GLOB.score_research_point_gained)] Points)<br>
	<b>autopsias realizadas:</b> [GLOB.moebius_autopsies_mobs] ([to_score_color(GLOB.score_moebius_autopsies_mobs)] Points)<br>
	<b>Final score:</b> [get_color_score(GLOB.moebius_score, MAX_FACTION_SCORE)] Points<br>
	"}

	dat += {"
	<u>Technomancers scores</u><br>
	<b>Base score:</b> [green_text(GLOB.initial_technomancer_score)]<br>
	<b>Faction Objectives:</b> [GLOB.technomancer_objectives_completed] ([to_score_color(GLOB.score_technomancer_objectives)] Points)<br>
	<b>All smes chargered:</b> [GLOB.all_smes_powered ? "Yes" : "No"] ([to_score_color(GLOB.score_smes_powered)] Points)<br>
	<b>Alcance del escudo:</b> [GLOB.field_radius] ([to_score_color(GLOB.score_ship_shield)] Points)<br>
	<b>Faction item perdidos:</b> [GLOB.technomancer_faction_item_loss] ([to_score_color(GLOB.score_technomancer_faction_item_loss)] Points)<br>
	<b>Areas sin energia:</b> [GLOB.area_powerloss] ([to_score_color(GLOB.score_powerloss)] Points)<br>
	<b>Areas con problemas atmosfericos:</b> [GLOB.area_fireloss] ([to_score_color(GLOB.score_fireloss)] Points)<br>
	<b>Final score:</b> [get_color_score(GLOB.technomancer_score, MAX_FACTION_SCORE)] Points<br>
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
	//if(GLOB.score_escapees)
	//	dat += {"<b>Richest Escapee:</b> [GLOB.score_richestname], [GLOB.score_richestjob]: $[num2text(GLOB.score_richestcash,50)] ([GLOB.score_richestkey])<br>
	//	<b>Most Battered Escapee:</b> [GLOB.score_dmgestname], [GLOB.score_dmgestjob]: [GLOB.score_dmgestdamage] damage ([GLOB.score_dmgestkey])<br>"}
	//else
		//if(SSshuttle.emergency.mode <= SHUTTLE_STRANDED)
		//	dat += "The station wasn't evacuated!<br>"
		//else
	//	dat += "No-one escaped!<br>"

	//dat += SSticker.mode.declare_job_completion()

	//dat += {"
	//<hr><br>
	//<b><u>FINAL SCORE: [GLOB.score_crewscore]</u></b><br>
	//"}

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

