#define DEBU69
// Turf-only fla69s.
#define69OJAUNT 1 // This is used in literally one place, turf.dm, to block ethereal jaunt.
#define TURF_FLA69_NORUINS 2

#define TRANSITIONED69E 7 // Distance from ed69e to69ove to another z-level.
#define RUIN_MAP_ED69E_PAD 15

// Invisibility constants.
#define INVISIBILITY_LI69HTIN69             20
#define INVISIBILITY_AN69EL                30
#define INVISIBILITY_LEVEL_ONE            35
#define INVISIBILITY_LEVEL_TWO            45
#define INVISIBILITY_OBSERVER             60
#define INVISIBILITY_EYE		          61

#define SEE_INVISIBLE_NOLI69HTIN69          15
#define SEE_INVISIBLE_LIVIN69              25
#define SEE_INVISIBLE_AN69EL               30
#define SEE_INVISIBLE_LEVEL_ONE           35
#define SEE_INVISIBLE_LEVEL_TWO           45
#define SEE_INVISIBLE_CULT		          60
#define SEE_INVISIBLE_OBSERVER            61

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100

// Some arbitrary defines to be used by self-prunin69 69lobal lists.
#define PROCESS_KILL 26 // Used to tri6969er removal from a processin69 list.
#define69AX_69EAR_COST 5 // Used in char69en for accessory loadout limit.

// For secHUDs and69edHUDs and69ariants. The69umber is the location of the ima69e on the list hud_list of humans.
#define      HEALTH_HUD 1 // A simple line roundin69 the69ob's69umber health.
#define      STATUS_HUD 2 // Alive, dead, diseased, etc.
#define          ID_HUD 3 // The job asi69ned to your ID.
#define      WANTED_HUD 4 // Wanted, released, paroled, security status.
#define     IMPCHEM_HUD 5 // Chemical implant.
#define    IMPTRACK_HUD 6 // Trackin69 implant.
#define SPECIALROLE_HUD 7 // Anta69HUD ima69e.
#define  STATUS_HUD_OOC 8 // STATUS_HUD without69irus DB check for someone bein69 ill.
#define        LIFE_HUD 9 // STATUS_HUD that only reports dead or alive
#define   EXCELSIOR_HUD 10 // Used by excelsior to see who else is excel

// These define the time taken for the shuttle to 69et to the space station, and the time before it leaves a69ain.

#define PODS_PREPTIME 	600	//1069ins = 600 sec - hol lon69 pods will wait before launch
#define PODS_TRANSIT 	120 //269ins - how lon69 pods takes to 69et to the centcom
#define PODS_LOCKDOWN	90	//1.569ins - how lon69 pods stay opened, if evacuation will be cancelled

// Shuttle69ovin69 status.
#define SHUTTLE_IDLE      0
#define SHUTTLE_WARMUP    1
#define SHUTTLE_INTRANSIT 2

// Ferry shuttle processin69 status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

// Settin69 this69uch hi69her than 1024 could allow spammers to DOS the server easily.
#define69AX_MESSA69E_LEN       1024
#define69AX_PAPER_MESSA69E_LEN 3072
#define69AX_BOOK_MESSA69E_LEN  9216
#define69AX_LNAME_LEN         64
#define69AX_NAME_LEN          26
#define69AX_DESC_LEN          128
#define69AX_TEXTFILE_LEN69TH 128000		// 5126969 file


// Car69o-related stuff.
#define69ANIFEST_ERROR_CHANCE		5
#define69ANIFEST_ERROR_NAME			1
#define69ANIFEST_ERROR_CONTENTS		2
#define69ANIFEST_ERROR_ITEM			4

//69eneral-purpose life speed define for plants.
#define HYDRO_SPEED_MULTIPLIER 1

#define DEFAULT_JOB_TYPE /datum/job/assistant


//Area fla69s, possibly69ore to come
#define AREA_FLA69_RAD_SHIELDED 1 // shielded from radiation, clearly
#define AREA_FLA69_EXTERNAL     2 // External as in exposed to space,69ot outside in a69ice, 69reen, forest
#define AREA_FLA69_ION_SHIELDED 4 // shielded from ionospheric anomalies as an FBP / IPC
#define AREA_FLA69_CRITICAL		8 //Area should69ot be tar69eted by69ery destructive events

// Convoluted setup so defines can be supplied by Bay1269ain server compile script.
// Should still work fine for people jammin69 the icons into their repo.
#ifndef CUSTOM_ITEM_OBJ
#define CUSTOM_ITEM_OBJ 'icons/obj/custom_items_obj.dmi'
#endif
#ifndef CUSTOM_ITEM_MOB
#define CUSTOM_ITEM_MOB 'icons/mob/custom_items_mob.dmi'
#endif
#ifndef CUSTOM_ITEM_SYNTH
#define CUSTOM_ITEM_SYNTH 'icons/mob/custom_synthetic.dmi'
#endif

#define WALL_CAN_OPEN 1
#define WALL_OPENIN69 2

#define COIN_STANDARD "Coin"
#define COIN_69OLD "69old coin"
#define COIN_SILVER "Silver coin"
#define COIN_DIAMOND "Diamond coin"
#define COIN_IRON "Iron coin"
#define COIN_PLASMA "Solid plasma coin"
#define COIN_URANIUM "Uranium coin"
#define COIN_PLATINUM "Platunum coin"

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define69ATERIAL_UNMELTABLE 0x1
#define69ATERIAL_BRITTLE    0x2
#define69ATERIAL_PADDIN69    0x4

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table dama69e is69ultiplied by if it is69ade of a brittle69aterial (e.69. 69lass)

#define BOMBCAP_DVSTN_RADIUS (max_explosion_ran69e/4)
#define BOMBCAP_HEAVY_RADIUS (max_explosion_ran69e/2)
#define BOMBCAP_LI69HT_RADIUS69ax_explosion_ran69e
#define BOMBCAP_FLASH_RADIUS (max_explosion_ran69e*1.5)
									//69TNet69odule-confi69uration69alues. Do69ot chan69e these. If you69eed to add another use lar69er69umber (5..6..7 etc)
#define69TNET_SOFTWAREDOWNLOAD 1 	// Downloads of software from69TNet
#define69TNET_PEERTOPEER 2			// P2P transfers of files between devices
#define69TNET_COMMUNICATION 3		// Communication (messa69in69)
#define69TNET_SYSTEMCONTROL 4		// Control of69arious systems, RCon, air alarm control, etc.

//69TNet transfer speeds, used when downloadin69/uploadin69 a file/pro69ram.
#define69TNETSPEED_LOWSI69NAL 0.05	// 6969/s transfer speed when the device is wirelessly connected and on Low si69nal
#define69TNETSPEED_HI69HSI69NAL 0.15	// 6969/s transfer speed when the device is wirelessly connected and on Hi69h si69nal
#define69TNETSPEED_ETHERNET 0.40		// 6969/s transfer speed when the device is usin69 wired connection
#define69TNETSPEED_DOS_AMPLIFICATION 2	//69ultiplier for Denial of Service pro69ram. Resultin69 load on69TNet relay is this69ultiplied by69TNETSPEED of the device

// Pro69ram bitfla69s
#define PRO69RAM_ALL 		0x1F
#define PRO69RAM_CONSOLE 	0x1
#define PRO69RAM_LAPTOP 		0x2
#define PRO69RAM_TABLET 		0x4
#define PRO69RAM_TELESCREEN 	0x8
#define PRO69RAM_PDA 		0x10

#define PRO69RAM_STATE_KILLED 0
#define PRO69RAM_STATE_BACK69ROUND 1
#define PRO69RAM_STATE_ACTIVE 2

// Caps for69TNet lo6969in69. Less than 10 would69ake lo6969in69 useless anyway,69ore than 50069ay69ake the lo69 browser too la6969y. Defaults to 100 unless user chan69es it.
#define69AX_NTNET_LO69S 500
#define69IN_NTNET_LO69S 10


// Special return69alues from bullet_act(). Positive return69alues are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flyin69 after callin69 bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a69iss (suppresses attack and admin lo69s) - only applies to69obs.

//Camera capture69odes
#define CAPTURE_MODE_RE69ULAR 0 //Re69ular polaroid camera69ode
#define CAPTURE_MODE_ALL 1 //Admin camera69ode
#define CAPTURE_MODE_PARTIAL 3 //Simular to re69ular69ode, but does69ot do dummy check
#define CAPTURE_MODE_HISTORICAL 4 //Only turfs and anchored atoms. Attempts to simulate a historical photo

//HUD element hidin69s fla69s
#define F12_FLA69 1 // 0001
#define TO6969LE_INVENTORY_FLA69 2 //0010
#define TO6969LE_BOTTOM_FLA69 4 //0100

// Default69ame for announcement system
#define ANNOUNCER_NAME "CEV Eris System Announcer"


#define LIST_OF_CONSONANT list("a", "b", "c", "d", "f", "69", "h", "j", "k", "l", "m", "n", "p", "69", "r", "s", "t", "v", "w", "x", "y", "z", "á", "â", "ã", "ä", "æ", "ç", "é", "ê", "ë", "ì", "í", "ï", "ð", "ñ", "ò", "ô", "õ", "ö", "÷", "ø", "ù")
#define EN_ALPHABET list("a", "b", "c", "d", "f", "69", "h", "j", "k", "l", "m", "n", "p", "69", "r", "s", "t", "v", "w", "x", "y", "z")
//Multi-z
#define FALL_69IB_DAMA69E 999

//distance
#define RAN69E_ADJACENT -1

//Core implants
#define CORE_ACTIVATED /datum/core_module/activatable

//Cruciform
#define CRUCIFORM_COMMON /datum/core_module/rituals/cruciform/base
#define CRUCIFORM_A69ROLYTE /datum/core_module/rituals/cruciform/a69rolyte
#define CRUCIFORM_CUSTODIAN /datum/core_module/rituals/cruciform/custodian
#define CRUCIFORM_PRIEST /datum/core_module/rituals/cruciform/priest
#define CRUCIFORM_ACOLYTE /datum/core_module/rituals/cruciform/priest/acolyte
#define CRUCIFORM_IN69UISITOR /datum/core_module/rituals/cruciform/in69uisitor
#define CRUCIFORM_CRUSADER /datum/core_module/rituals/cruciform/crusader
#define CRUCIFORM_UPLINK /datum/core_module/cruciform/uplink
#define CRUCIFORM_REDLI69HT /datum/core_module/cruciform/red_li69ht
#define CRUCIFORM_CLONIN69 /datum/core_module/cruciform/clonin69

#define CRUCIFORM_OBEY /datum/core_module/cruciform/obey
#define CRUCIFORM_PRIEST_CONVERT /datum/core_module/activatable/cruciform/priest_convert
#define CRUCIFORM_OBEY_ACTIVATOR /datum/core_module/activatable/cruciform/obey_activator

#define CUP69RADE_NATURES_BLESSIN69 /obj/item/cruciform_up69rade/natures_blessin69
#define CUP69RADE_FAITHS_SHIELD /obj/item/cruciform_up69rade/faiths_shield
#define CUP69RADE_CLEANSIN69_PSESENCE /obj/item/cruciform_up69rade/cleansin69_presence
#define CUP69RADE_MARTYR_69IFT /obj/item/cruciform_up69rade/martyr_69ift
#define CUP69RADE_WRATH_OF_69OD /obj/item/cruciform_up69rade/wrath_of_69od
#define CUP69RADE_SPEED_OF_THE_CHOSEN /obj/item/cruciform_up69rade/speed_of_the_chosen

//https://secure.byond.com/docs/ref/info.html#/atom/var/mouse_opacity
#define69OUSE_OPACITY_TRANSPARENT 0
#define69OUSE_OPACITY_ICON 1
#define69OUSE_OPACITY_OPA69UE 2

//Filters
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, color="#04080FAA")

//Built-in email accounts
#define EMAIL_DOCUMENTS "document.server@internal-services.net"
#define EMAIL_SYSADMIN  "admin@internal-services.net"
#define EMAIL_BROADCAST "broadcast@internal-services.net"
#define EMAIL_PAYROLL "payroll@internal-services.net"

#define LE69ACY_RECORD_STRUCTURE(X, Y) 69LOBAL_LIST_EMPTY(##X);/datum/computer_file/data/##Y/var/list/fields69069;/datum/computer_file/data/##Y/New(){..();69LOB.##X.Add(src);}/datum/computer_file/data/##Y/Destroy(){. = ..();69LOB.##X.Remove(src);}

//Number of slots a69odular computer has which can be tweaked69ia 69ear tweaks.
#define TWEAKABLE_COMPUTER_PART_SLOTS 8

 //Preference save/load cooldown. This is in deciseconds.
#define PREF_SAVELOAD_COOLDOWN 4 //Should be sufficiently hard to achieve without a broken69ouse or autoclicker while still fulfillin69 its intended 69oal.

#define JOINTEXT(X) jointext(X,69ull)

//lazy text span classes defines.
#define SPAN_NOTICE(text)  "<span class='notice'>69tex6969</span>"
#define SPAN_WARNIN69(text) "<span class='warnin69'>69tex6969</span>"
#define SPAN_DAN69ER(text)  "<span class='dan69er'>69tex6969</span>"
#define span(class, text) ("<span class='69clas6969'>69te69t69</span>")
// the thin69 below allow usin69 SPANnin69 in datum definition, the above can't.
#define SPAN(class, X) "<span class='" + ##class + "'>" + ##X + "</span>"

#define text_starts_with(text, start) (copytext(text, 1, len69th(start) + 1) == start)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

// Overlays
// (placeholders for if/when T69 overlays system is ported)
#define cut_overlays(...)			overlays.Cut()

#define se69uential_id(key) uni69ueness_repository.69enerate(/datum/uni69ueness_69enerator/id_se69uential, key)

#define random_id(key,min_id,max_id) uni69ueness_repository.69enerate(/datum/uni69ueness_69enerator/id_random, key,69in_id,69ax_id)

#define sound_to(tar69et, sound)                             tar69et << sound
//#define to_chat(tar69et,69essa69e)                          tar69et <<69essa69e
#define to_world(messa69e)                                   to_chat(world,69essa69e)
#define to_world_lo69(messa69e)                               lo69_world(messa69e)
#define show_browser(tar69et, browser_content, browser_name) tar69et << browse(browser_content, browser_name)
#define to_file(file_entry, source_var)                     file_entry << source_var
#define from_file(file_entry, tar69et_var)                   file_entry >> tar69et_var
#define send_rsc(tar69et, rsc_content, rsc_name)             tar69et << browse_rsc(rsc_content, rsc_name)
#define open_link(tar69et, url)             					tar69et << link(url)

#define send_output(tar69et,69s69, control) tar69et << output(ms69, control)
#define send_link(tar69et, url) tar69et << link(url)

#define any2ref(x) "\ref696969"

#define69AP_IMA69E_PATH "nano/ima69es/6969LOB.maps_data.pat6969/"

#define69ap_ima69e_file_name(z_level) "6969LOB.maps_data.pat6969-69z_lev69l69.pn69"

// Spawns69ultiple objects of the same type
#define cast_new(type,69um, ar69s...) if((num) == 1) {69ew type(ar69s) } else { for(var/i in 1 to69um) {69ew type(ar69s) } }

#define CLIENT_FROM_VAR(I) (ismob(I) ? I:client : (istype(I, /client) ? I : (istype(I, /datum/mind) ? I:current?:client :69ull)))


//69aploader bounds indices
#define69AP_MINX 1
#define69AP_MINY 2
#define69AP_MINZ 3
#define69AP_MAXX 4
#define69AP_MAXY 5
#define69AP_MAXZ 6

// a place where atoms can be created instead of69ullspace
// dont store anythin69 there, only create temporary
#define PUR69ATORY (69LOB.pur69atory_loc ? 69LOB.pur69atory_loc : error("Pur69atory was69ot created."))
// You can store items in69ullspace but dont crete items there
#define69ULLSPACE (null)

#define CATALO69_REA69ENTS "rea69ents"
#define CATALO69_CHEMISTRY "chemistry"
#define CATALO69_DRINKS "drinks"
#define CATALO69_ALL "all"

#define 69et_area(A) (69et_step(A, 0)?.loc)


//Misc text define. Does 4 spaces. Used as a69akeshift tabulator.
#define FOURSPACES "&nbsp;&nbsp;&nbsp;&nbsp;"



//Planet habitability class
#define HABITABILITY_IDEAL  1
#define HABITABILITY_OKAY  2
#define HABITABILITY_BAD  3


//Map template fla69s
#define TEMPLATE_FLA69_ALLOW_DUPLICATES 1 // Lets69ultiple copies of the template to be spawned
#define TEMPLATE_FLA69_SPAWN_69UARANTEED 2 //69akes it i69nore away site bud69et and just spawn (only for away sites)
#define TEMPLATE_FLA69_CLEAR_CONTENTS   4 // if it should destroy objects it spawns on top of
#define TEMPLATE_FLA69_NO_RUINS         8 // if it should forbid ruins from spawnin69 on top of it
#define TEMPLATE_FLA69_NO_RADS          16// Removes all radiation from the template after spawnin69.


//Fla69s for exoplanet ruin pickin69

#define RUIN_HABITAT 	1		//lon69 term habitat
#define RUIN_HUMAN 		2		//human-made structure
#define RUIN_ALIEN 		4		//artificial structure of an unknown ori69in
#define RUIN_WRECK 		8		//crashed69essel
#define RUIN_NATURAL	16		//naturally occurin69 structure
#define RUIN_WATER 		32		//ruin dependin69 on planet havin69 water accessible

#define69EWorINITIAL(variable,69ewvalue)69ariable =69ewvalue ?69ewvalue : initial(variable)

//Matricies
#define69ATRIX_69REYSCALE list(0.33, 0.33, 0.33,\
                              0.33, 0.33, 0.33,\
                              0.33, 0.33, 0.33)

//different types of atom colorations
#define ADMIN_COLOUR_PRIORITY 		1 //only used by rare effects like 69reentext colorin6969obs and when admins69aredit color
#define TEMPORARY_COLOUR_PRIORITY 	2 //e.69. purple effect of the revenant on a69ob, black effect when69ob electrocuted
#define WASHABLE_COLOUR_PRIORITY 	3 //color splashed onto an atom (e.69. paint on turf)
#define FIXED_COLOUR_PRIORITY 		4 //color inherent to the atom (e.69. blob color)
#define COLOUR_PRIORITY_AMOUNT      4 //how69any priority levels there are.

//Sounds list
#define WALLHIT_SOUNDS list('sound/effects/wallhit.o6969', 'sound/effects/wallhit2.o6969', 'sound/effects/wallhit3.o6969')

//Prevent the69aster controller from startin69 automatically
#define69O_INIT_PARAMETER "no-init"

/// Re69uired69inimum69alues to see rea69ents in a beaker
#define HUMAN_RE69_CO69_FOR_RE69 35
#define HUMAN_RE69_BIO_FOR_RE69 50

///69isc atmos e69uations

#define FIRESTACKS_TEMP_CONV(firestacks)69in(5200,max(2.25*round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE*(fire_stacks/FIRE_MAX_FIRESUIT_STACKS)**2), 700))
