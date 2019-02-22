GLOBAL_LIST_EMPTY(clients)							//list of all GLOB.clients
GLOBAL_LIST_EMPTY(admins)							//list of all GLOB.clients whom are GLOB.admins
GLOBAL_LIST_EMPTY(directory)							//list of all ckeys with associated client

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(player_list)				//List of all mobs **with GLOB.clients attached**. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(human_mob_list)				//List of all human mobs and sub-types, including clientless
GLOBAL_LIST_EMPTY(silicon_mob_list)			//List of all silicon mobs, including clientless
GLOBAL_LIST_EMPTY(living_mob_list)			//List of all alive mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(dead_mob_list)				//List of all dead mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(current_antags)
GLOBAL_LIST_EMPTY(current_factions)
GLOBAL_LIST_EMPTY(antag_team_objectives)		//List of shared sets of objectives for antag teams - Comment to remind myself that this is unused.
GLOBAL_LIST_EMPTY(antag_team_members)			//List of the people who are in antag teams - Also unused.

GLOBAL_LIST_EMPTY(cable_list)					//Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_LIST_EMPTY(chemical_reactions_list)				//list of all /datum/chemical_reaction datums. Used during chemical reactions
GLOBAL_LIST_EMPTY(chemical_reagents_list)				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST_EMPTY(landmarks_list)				//list of all landmarks created
GLOBAL_LIST_EMPTY(shuttle_landmarks_list)		//list of all /obj/effect/shuttle_landmark.
GLOBAL_LIST_EMPTY(surgery_steps)				//list of all surgery steps  |BS12
GLOBAL_LIST_EMPTY(mechas_list)				//list of all mechs. Used by hostile mobs target tracking.



GLOBAL_LIST_EMPTY(hearing_objects)			//list of all objects, that can hear mob say

//Jobs and economy
GLOBAL_LIST_EMPTY(joblist)					//list of all jobstypes, minus borg and AI
GLOBAL_LIST_EMPTY(all_departments)			//List of all department datums
GLOBAL_LIST_INIT(department_IDs, list(DEPARTMENT_COMMAND, DEPARTMENT_MEDICAL, DEPARTMENT_ENGINEERING, //Comment to remind me that this isn't used anywhere.
 DEPARTMENT_SCIENCE, DEPARTMENT_SECURITY, DEPARTMENT_GUILD, DEPARTMENT_CHURCH, DEPARTMENT_CIVILIAN))
GLOBAL_LIST_EMPTY(global_corporations)


GLOBAL_LIST_EMPTY(HUDdatums)

#define all_genders_define_list list(MALE, FEMALE, PLURAL, NEUTER)

GLOBAL_LIST_EMPTY(turfs)						//list of all GLOB.turfs

GLOBAL_LIST_EMPTY(mannequins_)

//Languages/species/whitelist.
GLOBAL_LIST_EMPTY(all_species)
GLOBAL_LIST_EMPTY(all_languages)
GLOBAL_LIST_EMPTY(language_keys)					// Table of say codes for all languages
GLOBAL_LIST_INIT(whitelisted_species, list("Human")) // Species that require a whitelist check.
GLOBAL_LIST_INIT(playable_species, list("Human"))    // A list of ALL playable species, whitelisted, latejoin or otherwise.

// Posters
GLOBAL_LIST_EMPTY(poster_designs)

// Uplinks
GLOBAL_LIST_EMPTY(world_uplinks)


//Neotheology
GLOBAL_LIST_EMPTY(all_rituals)//List of all rituals
GLOBAL_LIST_EMPTY(global_ritual_cooldowns) // internal lists. Use ritual's cooldown_category

//Preferences stuff
	//Bodybuilds
GLOBAL_LIST_EMPTY(male_body_builds)
GLOBAL_LIST_EMPTY(female_body_builds)
	//Hairstyles
GLOBAL_LIST_EMPTY(hair_styles_list)        //stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(facial_hair_styles_list) //stores /datum/sprite_accessory/facial_hair indexed by name

GLOBAL_DATUM_INIT(underwear, /datum/category_collection/underwear, new())

GLOBAL_LIST_INIT(backbaglist, list("Nothing", "Backpack", "Satchel", "Satchel Alt"))
GLOBAL_LIST_INIT(exclude_jobs, list(/datum/job/ai,/datum/job/cyborg))

GLOBAL_LIST_INIT(organ_structure, list(
	chest = list(name= "Chest", children=list()),
	groin = list(name= "Groin",     parent=BP_CHEST, children=list()),
	head  = list(name= "Head",      parent=BP_CHEST, children=list()),
	r_arm = list(name= "Right arm", parent=BP_CHEST, children=list()),
	l_arm = list(name= "Left arm",  parent=BP_CHEST, children=list()),
	r_leg = list(name= "Right leg", parent=BP_GROIN, children=list()),
	l_leg = list(name= "Left leg",  parent=BP_GROIN, children=list()),
	))

GLOBAL_LIST_INIT(organ_tag_to_name, list(
	head  = "Head", r_arm = "Right arm",
	chest = "Body", r_leg = "Right Leg",
	eyes  = "Eyes", l_arm = "Left arm",
	groin = "Groin",l_leg = "Left Leg",
	chest2= "Back", heart = "Heart",
	lungs  = "Lungs", liver = "Liver"
	))


// Visual nets
GLOBAL_LIST_EMPTY(visual_nets)
GLOBAL_DATUM_INIT(cameranet, /datum/visualnet/camera, new)

GLOBAL_LIST_INIT(syndicate_access, list(access_maint_tunnels, access_syndicate, access_external_airlocks))

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
GLOBAL_LIST_INIT(string_part_flags, list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"arms" = ARMS
))

// Strings which corraspond to slot flags, useful for outputting what slot something is.
GLOBAL_LIST_INIT(string_slot_flags, list(
	"back" = SLOT_BACK,
	"face" = SLOT_MASK,
	"waist" = SLOT_BELT,
	"ID slot" = SLOT_ID,
	"ears" = SLOT_EARS,
	"eyes" = SLOT_EYES,
	"hands" = SLOT_GLOVES,
	"head" = SLOT_HEAD,
	"feet" = SLOT_FEET,
	"exo slot" = SLOT_OCLOTHING,
	"body" = SLOT_ICLOTHING,
	"uniform" = SLOT_ACCESSORY_BUFFER,
	"holster" = SLOT_HOLSTER
))

//A list of slots where an item doesn't count as "worn" if it's in one of them
var/global/list/unworn_slots = list(slot_l_hand,slot_r_hand, slot_l_store, slot_r_store,slot_robot_equip_1,slot_robot_equip_2,slot_robot_equip_3)


//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()

	var/list/paths

	//Bodybuilds
	paths = typesof(/datum/body_build)
	for(var/path in paths)
		var/datum/body_build/B = new path()
		if (B.gender == FEMALE)
			GLOB.female_body_builds[B.name] = B
		else
			GLOB.male_body_builds[B.name] = B

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		GLOB.hair_styles_list[H.name] = H

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOB.facial_hair_styles_list[H.name] = H


	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = typesof(/datum/surgery_step)-/datum/surgery_step
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		GLOB.surgery_steps += S
	sort_surgeries()

	//List of job department datums
	paths = subtypesof(/datum/department)
	for(var/T in paths)
		var/datum/department/D = new T
		GLOB.all_departments[D.id] = D

	//List of job datums
	paths = typesof(/datum/job)-/datum/job
	paths -= GLOB.exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		GLOB.joblist[J.title] = J



	//Languages and species.
	paths = typesof(/datum/language)-/datum/language
	for(var/T in paths)
		var/datum/language/L = new T
		GLOB.all_languages[L.name] = L

	for (var/language_name in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			GLOB.language_keys[lowertext(L.key)] = L

	var/rkey = 0
	paths = typesof(/datum/species)-/datum/species
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		GLOB.all_species[S.name] = S

		if(!(S.spawn_flags & IS_RESTRICTED))
			GLOB.playable_species += S.name
		if(S.spawn_flags & IS_WHITELISTED)
			GLOB.whitelisted_species += S.name

	//Posters
	paths = typesof(/datum/poster) - /datum/poster - /datum/poster/wanted
	for(var/T in paths)
		var/datum/poster/P = new T
		GLOB.poster_designs += P

	//Corporations
	paths = typesof(/datum/corporation) - /datum/corporation
	for(var/T in paths)
		var/datum/corporation/C = new T
		GLOB.global_corporations[C.name] = C

	paths = typesof(/datum/hud) - /datum/hud
	for(var/T in paths)
		var/datum/hud/C = new T
		GLOB.HUDdatums[C.name] = C

	//Rituals
	paths = typesof(/datum/ritual)
	for(var/T in paths)
		var/datum/ritual/R = new T

		//Rituals which are just categories for subclasses will have a null phrase
		if (R.phrase)
			GLOB.all_rituals[R.name] = R


	return 1


var/global/list/admin_permissions = list(
	"fun" = 0x1,
	"server" = 0x2,
	"debug" = 0x4,
	"permissions" = 0x8,
	"mentor" = 0x10,
	"moderator" = 0x20,
	"admin" = 0x40,
	"host" = 0x80
	)

/proc/get_mannequin(var/ckey)
	if(!GLOB.mannequins_)
		GLOB.mannequins_ = new()
	. = GLOB.mannequins_[ckey]
	if(!.)
		. = new/mob/living/carbon/human/dummy/mannequin()
		GLOB.mannequins_[ckey] = .

var/global/list/severity_to_string = list("[EVENT_LEVEL_MUNDANE]" = "Mundane", "[EVENT_LEVEL_MODERATE]" = "Moderate", "[EVENT_LEVEL_MAJOR]" = "Major", "[EVENT_LEVEL_ROLESET]" = "Roleset","[EVENT_LEVEL_ECONOMY]" = "Economy")



//*** params cache
/*
	Ported from bay12, this seems to be used to store and retrieve 2D vectors as strings, as well as
	decoding them into a number
*/
var/global/list/paramslist_cache = list()

#define cached_key_number_decode(key_number_data) cached_params_decode(key_number_data, /proc/key_number_decode)
#define cached_number_list_decode(number_list_data) cached_params_decode(number_list_data, /proc/number_list_decode)

/proc/cached_params_decode(var/params_data, var/decode_proc)
	. = paramslist_cache[params_data]
	if(!.)
		. = call(decode_proc)(params_data)
		paramslist_cache[params_data] = .

/proc/key_number_decode(var/key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L[key] = text2num(L[key])
	return L

/proc/number_list_decode(var/number_list_data)
	var/list/L = params2list(number_list_data)
	for(var/i in 1 to L.len)
		L[i] = text2num(L[i])
	return L