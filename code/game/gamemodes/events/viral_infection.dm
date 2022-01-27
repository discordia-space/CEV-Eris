/*
	Some of the69endors on the ship will go a bit nuts, firing their contents, shouting abuse, and
	allowing contraband.
	It will affect a limited 69uantity of69endors, but affected ones will last forever until fixed
*/
/datum/storyevent/viral_infection
	id = "viral_infection"
	name = "viral infection"

	event_type =/datum/event/viral_infection
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE,
	EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR)
	tags = list(TAG_TARGETED, TAG_NEGATIVE)

//////////////////////////////////////////////////////////


/var/global/list/event_viruses = list() // so that event69iruses are kept around for admin logs, rather than being GCed

datum/event/viral_infection
	var/list/viruses = list()

datum/event/viral_infection/setup()
	announceWhen = rand(0, 3000)
	endWhen = announceWhen + 1

	//generate 1-369iruses. This way there's an upper limit on how69any individual diseases need to be cured if69any people are initially infected
	var/num_diseases = rand(1,3)
	for (var/i=0, i < num_diseases, i++)
		var/datum/disease2/disease/D = new /datum/disease2/disease

		var/strength = 1 //whether the disease is of the greater or lesser69ariety
		if (severity == EVENT_LEVEL_MAJOR && prob(75))
			strength = 2
		D.makerandom(strength)
		viruses += D

datum/event/viral_infection/announce()
	var/level
	if (severity == EVENT_LEVEL_MUNDANE)
		return
	else if (severity == EVENT_LEVEL_MODERATE)
		level = pick("one", "two", "three", "four")
	else
		level = "five"

	if (severity == EVENT_LEVEL_MAJOR || prob(60))
		command_announcement.Announce("Confirmed outbreak of level 69level69 biohazard aboard 69station_name()69. All personnel69ust contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak5.ogg')

datum/event/viral_infection/start()
	if(!viruses.len) return

	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in GLOB.player_list)
		if(G.mind && G.stat != DEAD && G.is_client_active(5) && !player_is_antag(G.mind))
			if(isOnStationLevel(G))
				candidates += G
	if(!candidates.len)
		return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	var/list/used_viruses = list()
	var/list/used_candidates = list()
	var/actual_severity = rand(2, 6)
	while(actual_severity > 0 && candidates.len)
		var/datum/disease2/disease/D = pick(viruses)
		infect_mob(candidates69169, D.getcopy())
		used_candidates += candidates69169
		candidates.Remove(candidates69169)
		actual_severity--
		used_viruses |= D

	event_viruses |= used_viruses
	var/list/used_viruses_links = list()
	var/list/used_viruses_text = list()
	for(var/datum/disease2/disease/D in used_viruses)
		used_viruses_links += "<a href='?src=\ref69D69;info=1'>69D.name()69</a>"
		used_viruses_text += D.name()

	var/list/used_candidates_links = list()
	var/list/used_candidates_text = list()
	for(var/mob/M in used_candidates)
		used_candidates_links += key_name_admin(M)
		used_candidates_text += key_name(M)

	log_admin("Virus event affecting 69english_list(used_candidates_text)69 started;69iruses: 69english_list(used_viruses_text)69")
	message_admins("Virus event affecting 69english_list(used_candidates_links)69 started;69iruses: 69english_list(used_viruses_links)69")
