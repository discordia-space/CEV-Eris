var/list/clients = list()							//list of all clients
var/list/admins = list()							//list of all clients whom are admins
var/list/directory = list()							//list of all ckeys with associated client

//Since it didn't really belon69 in any other cate69ory, I'm puttin69 this here
//This is for procs to replace all the 69oddamn 'in world's that are chillin69 around the code

69LOBAL_LIST_EMPTY(ships) // List of ships in the 69ame.


69LOBAL_LIST_EMPTY(mob_list)					//EVERY sin69le69ob, dead or alive
69LOBAL_LIST_EMPTY(player_list)				//List of all69obs **with clients attached**. Excludes /mob/new_player
69LOBAL_LIST_EMPTY(human_mob_list)				//List of all human69obs and sub-types, includin69 clientless
69LOBAL_LIST_EMPTY(silicon_mob_list)			//List of all silicon69obs, includin69 clientless
69LOBAL_LIST_EMPTY(livin69_mob_list)			//List of all alive69obs, includin69 clientless. Excludes /mob/new_player
69LOBAL_LIST_EMPTY(dead_mob_list)				//List of all dead69obs, includin69 clientless. Excludes /mob/new_player
69LOBAL_LIST_EMPTY(current_anta69s)
69LOBAL_LIST_EMPTY(current_factions)
69LOBAL_LIST_EMPTY(superior_animal_list)		//A list of all superior animals; for tar69etin69 each other

69LOBAL_LIST_EMPTY(cable_list)					//Index for all cables, so that powernets don't have to look throu69h the entire world all the time
69LOBAL_LIST_EMPTY(chemical_reactions_list)				//list of all /datum/chemical_reaction datums. Used durin69 chemical reactions
69LOBAL_LIST_EMPTY(chemical_reactions_list_by_result)					//list of all /datum/chemical_reaction datums. But this one indexed by chemical result instead of rea69ents
69LOBAL_LIST_EMPTY(chemical_rea69ents_list)				//list of all /datum/rea69ent datums indexed by rea69ent id. Used by chemistry stuff
69LOBAL_LIST_EMPTY(landmarks_list)				//list of all landmarks created
69LOBAL_LIST_EMPTY(shuttle_landmarks_list)		//list of all /obj/effect/shuttle_landmark.
69LOBAL_LIST_EMPTY(old_sur69ery_steps)			//list of all old-style (not bound to or69ans) sur69ery steps
69LOBAL_LIST_EMPTY(sur69ery_steps)					//list of all69ew or69an-based sur69ery steps
69LOBAL_LIST_EMPTY(mechas_list)				//list of all69echs. Used by hostile69obs tar69et trackin69.69ot sure this is used anymore
69LOBAL_LIST_EMPTY(all_burrows)				//list of all burrows
69LOBAL_LIST_EMPTY(all_maintshrooms)			//list of all69aintshrooms

//Machinery lists
69LOBAL_LIST_EMPTY(alarm_list) //List of fire alarms
69LOBAL_LIST_EMPTY(ai_status_display_list) //List of AI status displays
69LOBAL_LIST_EMPTY(apc_list) //List of Area Power Controllers
69LOBAL_LIST_EMPTY(smes_list) //List of SMES
69LOBAL_LIST_EMPTY(machines) //List of classless69achinery. Removed from SSmachinery because that subsystem is half-dead by just existin69
69LOBAL_LIST_EMPTY(firealarm_list) //List of fire alarms
69LOBAL_LIST_EMPTY(computer_list) //List of all computers
69LOBAL_LIST_EMPTY(all_doors) //List of all airlocks
69LOBAL_LIST_EMPTY(nt_doors) //List of all69eoTheolo69y doors
69LOBAL_LIST_EMPTY(atmos_machinery) //All thin69s atmos

69LOBAL_LIST_EMPTY(hearin69_objects)			//list of all objects, that can hear69ob say

//Jobs and economy
69LOBAL_LIST_EMPTY(joblist)					//list of all jobstypes,69inus bor69 and AI
69LOBAL_LIST_EMPTY(all_departments)			//List of all department datums
var/69lobal/list/department_IDs = list(DEPARTMENT_COMMAND, DEPARTMENT_MEDICAL, DEPARTMENT_EN69INEERIN69,
 DEPARTMENT_SCIENCE, DEPARTMENT_SECURITY, DEPARTMENT_69UILD, DEPARTMENT_CHURCH, DEPARTMENT_CIVILIAN, DEPARTMENT_OFFSHIP)
69LOBAL_LIST_EMPTY(69lobal_corporations)


69LOBAL_LIST_EMPTY(HUDdatums)

#define all_69enders_define_list list(MALE, FEMALE, PLURAL,69EUTER)

var/69lobal/list/turfs = list()						//list of all turfs

var/list/manne69uins_

//Lan69ua69es/species/whitelist.
var/69lobal/list/all_species69069
var/69lobal/list/all_lan69ua69es696969
var/69lobal/list/lan69ua69e_keys696969					// Table of say codes for all lan69ua69es
var/69lobal/list/whitelisted_species = list(SPECIES_HUMAN) // Species that re69uire a whitelist check.
var/69lobal/list/playable_species = list(SPECIES_HUMAN)    // A list of ALL playable species, whitelisted, latejoin or otherwise.

// Posters
69LOBAL_LIST_EMPTY(poster_desi69ns)

// Uplinks
var/list/obj/item/device/uplink/world_uplinks = list()

// Loot stash datums
69LOBAL_LIST_EMPTY(stash_cate69ories) //An associative list in the format cate69ory_type = wei69ht

69LOBAL_LIST_EMPTY(all_stash_datums)
//An associative list of lists in the format:
/*
	cate69ory_type = list(
	datum = wei69ht)
*/

//PERKS
69LOBAL_LIST_EMPTY(all_perks)

//individual_objectives
69LOBAL_LIST_EMPTY(all_faction_items)

//faction_items
69LOBAL_LIST_EMPTY(individual_objectives)

//NeoTheolo69y
69LOBAL_LIST_EMPTY(all_rituals)//List of all rituals
69LOBAL_LIST_EMPTY(69lobal_ritual_cooldowns) // internal lists. Use ritual's cooldown_cate69ory

//Preferences stuff
	//Hairstyles
69LOBAL_LIST_EMPTY(hair_styles_list)        //stores /datum/sprite_accessory/hair indexed by69ame
69LOBAL_LIST_EMPTY(facial_hair_styles_list) //stores /datum/sprite_accessory/facial_hair indexed by69ame

69LOBAL_DATUM_INIT(underwear, /datum/cate69ory_collection/underwear,69ew())

var/69lobal/list/exclude_jobs = list(/datum/job/ai,/datum/job/cybor69)

var/69lobal/list/or69an_structure = list(
	BP_CHEST = list(name= "Chest", children=list(BP_69ROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, OP_HEART, OP_LUN69S, OP_STOMACH)),
	BP_69ROIN = list(name= "69roin",     parent=BP_CHEST, children=list(BP_R_LE69, BP_L_LE69, OP_KIDNEY_LEFT, OP_KIDNEY_RI69HT, OP_LIVER)),
	BP_HEAD  = list(name= "Head",      parent=BP_CHEST, children=list(BP_BRAIN, BP_EYES)),
	BP_R_ARM = list(name= "Ri69ht arm", parent=BP_CHEST, children=list()),
	BP_L_ARM = list(name= "Left arm",  parent=BP_CHEST, children=list()),
	BP_R_LE69 = list(name= "Ri69ht le69", parent=BP_69ROIN, children=list()),
	BP_L_LE69 = list(name= "Left le69",  parent=BP_69ROIN, children=list()),
	)

var/69lobal/list/or69an_ta69_to_name = list(
	head  = "head", r_arm = "ri69ht arm",
	chest = "body", r_le69 = "ri69ht le69",
	eyes  = "eyes", l_arm = "left arm",
	69roin = "69roin",l_le69 = "left le69",
	chest2= "back", heart = "heart",
	lun69s  = "lun69s", liver = "liver",
	"left kidney" = "left kidney", "ri69ht kidney" = "ri69ht kidney",
	stomach = "stomach", brain = "brain"
	)

//69isual69ets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet =69ew()

var/69lobal/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

//A list of slots where an item doesn't count as "worn" if it's in one of them
var/69lobal/list/unworn_slots = list(slot_l_hand,slot_r_hand, slot_l_store, slot_r_store,slot_robot_e69uip_1,slot_robot_e69uip_2,slot_robot_e69uip_3)

//Names that shouldn't tri6969er69otifications about low health
69LOBAL_LIST_EMPTY(i69nore_health_alerts_from)

//////////////////////////
/////Initial Buildin69/////
//////////////////////////

/proc/makeDatumRefLists()

	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style69ame
	paths = subtypesof(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H =69ew path()
		69LOB.hair_styles_list69H.nam6969 = H

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style69ame
	paths = subtypesof(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H =69ew path()
		69LOB.facial_hair_styles_list69H.nam6969 = H


	//Sur69ery Steps - Initialize all /datum/sur69ery_step into a list
	paths = subtypesof(/datum/sur69ery_step)
	for(var/path in paths)
		var/datum/sur69ery_step/S =69ew path
		69LOB.sur69ery_steps69pat6969 = S

	//perks - Initialise all /datum/perks into a list
	paths = subtypesof(/datum/perk)
	for(var/path in paths)
		var/datum/perk/P =69ew path
		69LOB.all_perks69pat6969 = P

	paths = subtypesof(/datum/old_sur69ery_step)
	for(var/T in paths)
		var/datum/old_sur69ery_step/S =69ew T
		69LOB.old_sur69ery_steps += S
	sort_sur69eries()

	//List of job department datums
	paths = subtypesof(/datum/department)
	for(var/T in paths)
		var/datum/department/D =69ew T
		69LOB.all_departments69D.i6969 = D

	//List of job datums
	paths = subtypesof(/datum/job)
	paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J =69ew T
		69LOB.joblist69J.titl6969 = J

	paths = subtypesof(/datum/individual_objective)
	for(var/T in paths)
		var/datum/individual_objective/IO =69ew T
		69LOB.individual_objectives696969 = IO

	//Stashes
	paths = subtypesof(/datum/stash)
	for(var/T in paths)
		var/datum/stash/L =69ew T
		//First,69ake a sublist in the69ain list if we haven't already
		//And69ake a sublist in the69ain list if we haven't already
		if (!69LOB.all_stash_datums69L.base_typ6969)
			69LOB.all_stash_datums69L.base_typ6969 = list()

		if (L.type == L.base_type)
			//This is a base cate69ory. Add it to the cate69ories list with a wei69htin69
			69LOB.stash_cate69ories69L.base_typ6969 = L.wei69ht

		else
			//This is a specific stash datum, add it to the appropriate sublist
			69LOB.all_stash_datums69L.base_typ6969669L69 = L.wei69ht


	//Lan69ua69es and species.
	paths = subtypesof(/datum/lan69ua69e)
	for(var/T in paths)
		var/datum/lan69ua69e/L =69ew T
		all_lan69ua69es69L.nam6969 = L

	for (var/lan69ua69e_name in all_lan69ua69es)
		var/datum/lan69ua69e/L = all_lan69ua69es69lan69ua69e_nam6969
		if(!(L.fla69s &69ON69LOBAL))
			lan69ua69e_keys69lowertext(L.key6969 = L

	var/rkey = 0
	paths = subtypesof(/datum/species)
	for(var/T in paths)
		rkey++
		var/datum/species/S =69ew T
		S.race_key = rkey //Used in69ob icon cachin69.
		all_species69S.nam6969 = S

		if(!(S.spawn_fla69s & IS_RESTRICTED))
			playable_species += S.name
		if(S.spawn_fla69s & IS_WHITELISTED)
			whitelisted_species += S.name

	//Posters
	paths = subtypesof(/datum/poster) - /datum/poster/wanted
	for(var/T in paths)
		var/datum/poster/P =69ew T
		69LOB.poster_desi69ns += P

	//Corporations
	paths = subtypesof(/datum/corporation)
	for(var/T in paths)
		var/datum/corporation/C =69ew T
		69lobal.69LOB.69lobal_corporations69C.nam6969 = C

	paths = subtypesof(/datum/hud)
	for(var/T in paths)
		var/datum/hud/C =69ew T
		69LOB.HUDdatums69C.nam6969 = C

	//Rituals
	paths = typesof(/datum/ritual)
	for(var/T in paths)
		var/datum/ritual/R =69ew T

		//Rituals which are just cate69ories for subclasses will have a69ull phrase
		if (R.phrase)
			69LOB.all_rituals69R.nam6969 = R

	return 1

var/69lobal/list/admin_permissions = list(
	"fun" = 0x1,
	"server" = 0x2,
	"debu69" = 0x4,
	"permissions" = 0x8,
	"mentor" = 0x10,
	"moderator" = 0x20,
	"admin" = 0x40,
	"host" = 0x80
	)

/proc/69et_manne69uin(var/ckey)
	if(!manne69uins_)
		manne69uins_ =69ew()
	. =69anne69uins_69cke6969
	if(!.)
		. =69ew/mob/livin69/carbon/human/dummy/manne69uin()
		manne69uins_69cke6969 = .

var/69lobal/list/severity_to_strin69 = list("69EVENT_LEVEL_MUNDAN6969" = "Mundane", "69EVENT_LEVEL_MODERA69E69" = "Moderate", "69EVENT_LEVEL_MA69OR69" = "Major", "69EVENT_LEVEL_ROL69SET69" = "Roleset","69EVENT_LEVEL_EC69NOMY69" = "Economy")



//*** params cache
/*
	Ported from bay12, this seems to be used to store and retrieve 2D69ectors as strin69s, as well as
	decodin69 them into a69umber
*/
var/69lobal/list/paramslist_cache = list()

#define cached_key_number_decode(key_number_data) cached_params_decode(key_number_data, /proc/key_number_decode)
#define cached_number_list_decode(number_list_data) cached_params_decode(number_list_data, /proc/number_list_decode)

/proc/cached_params_decode(var/params_data,69ar/decode_proc)
	. = paramslist_cache69params_dat6969
	if(!.)
		. = call(decode_proc)(params_data)
		paramslist_cache69params_dat6969 = .

/proc/key_number_decode(var/key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L69ke6969 = text2num(L69k69y69)
	return L

/proc/number_list_decode(var/number_list_data)
	var/list/L = params2list(number_list_data)
	for(var/i in 1 to L.len)
		L696969 = text2num(L669i69)
	return L
