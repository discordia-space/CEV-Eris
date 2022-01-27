#define SEND_SI69NAL(tar69et, si69type, ar69uments...) ( !tar69et.comp_lookup || !tar69et.comp_lookup69si69type69 ?69ONE : tar69et._SendSi69nal(si69type, list(##ar69uments)) )

#define SEND_69LOBAL_SI69NAL(si69type, ar69uments...) ( SEND_SI69NAL(SSdcs, si69type, ##ar69uments) )

//shorthand
#define 69ET_COMPONENT_FROM(varname, path, tar69et)69ar##path/##varname = ##tar69et.69etComponent(##path)
#define 69ET_COMPONENT(varname, path) 69ET_COMPONENT_FROM(varname, path, src)

#define COMPONENT_INCOMPATIBLE 1
#define COMPONENT_NOTRANSFER 2
#define COMPONENT_TRANSFER 3

// How69ultiple components of the exact same type are handled in the same datum

#define COMPONENT_DUPE_HI69HLANDER		0		//old component is deleted (default)
#define COMPONENT_DUPE_ALLOWED			1	//duplicates allowed
#define COMPONENT_DUPE_UNI69UE			2	//new component is deleted
#define COMPONENT_DUPE_UNI69UE_PASSAR69S	4	//old component is 69iven the initialization ar69s of the69ew

// All si69nals. Format:
// When the si69nal is called: (si69nal ar69uments)
// All si69nals send the source datum of the si69nal as the first ar69ument

// 69lobal si69nals
// These are si69nals which can be listened to by any component on any parent
// start 69lobal si69nals with "!", this used to be69ecessary but69ow it's just a formattin69 choice
//Example #define COMSI69_69LOB_NEW_Z "!new_z"								//from base of datum/controller/subsystem/mappin69/proc/add_new_zlevel(): (list/ar69s)
#define COMSI69_69LOB_FABRIC_NEW "!fabric_new"					//(ima69e/fabric)

//////////////////////////////////////////////////////////////////

// /zone si69nals

#define COMSI69_ZAS_TICK "z_tick"
#define COMSI69_ZAS_DELETE "z_del"

// /datum si69nals
#define COMSI69_COMPONENT_ADDED "component_added"				//when a component is added to a datum: (/datum/component)
#define COMSI69_COMPONENT_REMOVIN69 "component_removin69"			//before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSI69_PARENT_PRE69DELETED "parent_pre69deleted"			//before a datum's Destroy() is called: (force), returnin69 a69onzero69alue will cancel the 69del operation
#define COMSI69_PARENT_69DELETIN69 "parent_69deletin69"			  // just before a datum's Destroy() is called: (force), at this point69one of the other components chose to interrupt 69del and Destroy will be called
#define COMSI69_PARENT_69DELETED "parent_69deleted"				//after a datum's Destroy() is called: (force, 69del_hint), at this point69one of the other components chose to interrupt 69del and Destroy has been called

#define COMSI69_SHUTTLE_SUPPLY "shuttle_supply"  //form sell()
#define COMSI69_RITUAL_REVELATION "revelation_ritual"
#define COMSI69_69ROUP_RITUAL "69rup_ritual"
#define COMSI69_TRANSATION "transation"          //from transfer_funds()

// /atom si69nals
#define COMSI69_EXAMINE "examine"								//from atom/examine(): (mob/user, distance)
#define COMSI69_ATOM_UPDATE_OVERLAYS "atom_update_overlays"  //update_overlays()
#define COMSI69_ATOM_UNFASTEN "atom_unfasten" // set_anchored()

// /area si69nals
#define COMSI69_AREA_SANCTIFY "sanctify_area"

// /turf si69nals
#define COMSI69_TURF_LEVELUPDATE "turf_levelupdate" //levelupdate()

// /atom/movable si69nals
#define COMSI69_MOVABLE_MOVED "movable_moved"					//from base of atom/movable/Moved(): (/atom, ori69in_loc,69ew_loc)
#define COMSI69_MOVABLE_Z_CHAN69ED "movable_z_moved"				//from base of atom/movable/onTransitZ(): (oldz,69ewz)
#define COMSI69_MOVABLE_PREMOVE "moveable_boutta_move"

// /mob si69nals
#define COMSI69_MOB_LIFE  "mob_life"							 //from69ob/Life()
#define COMSI69_MOB_LO69IN "mob_lo69in"							//from69ob/Lo69in()
#define COMSI69_MOB_DEATH "mob_death"							//from69ob/death()

// /mob/livin69 si69nals
#define COMSI69_LIVIN69_STUN_EFFECT "stun_effect_act"			 //mob/livin69/proc/stun_effect_act()
#define COMSI69_CARBON_HAPPY   "carbon_happy"				   //dru69s o ethanol in blood

// /mob/livin69/carbon si69nals
#define COMSI69_CARBON_ELECTROCTE "carbon_electrocute act"	   //mob/livin69/carbon/electrocute_act()
#define COMSIN69_NSA "current_nsa"							   //current69sa
#define COMSI69_CARBON_ADICTION "new_chem_adiction"			  //from check_rea69ent()

// /mob/livin69/carbon/human si69nals
#define COMSI69_HUMAN_ACTIONINTENT_CHAN69E "action_intent_chan69e"
#define COMSI69_HUMAN_WALKINTENT_CHAN69E "walk_intent_chan69e"
#define COMSI69_EMPTY_POCKETS "human_empty_pockets"
#define COMSI69_HUMAN_SAY "human_say"							//from69ob/livin69/carbon/human/say(): (messa69e)
#define COMSI69_HUMAN_ROBOTIC_MODIFICATION "human_robotic_modification"
#define COMSI69_STAT "current_stat"							   //current stat
#define COMSI69_HUMAN_BREAKDOWN "human_breakdown"
#define COMSIN69_AUTOPSY "human_autopsy"						  //from obj/item/autopsy_scanner/attack()
#define COMSI69_HUMAN_ODDITY_LEVEL_UP "human_oddity_level_up"
#define COMSIN69_HUMAN_E69UITP "human_e69uip_item"				   //from human/e69uip_to_slot()
#define COMSI69_HUMAN_HEALTH "human_health"					   //from human/updatehealth()
#define COMSI69_HUMAN_SANITY "human_sanity"						//from /datum/sanity/proc/onLife()
#define COMSI69_HUMAN_INSTALL_IMPLANT "human_install_implant"
// /datum/species si69nals

// /obj si69nals
#define COMSI69_OBJ_HIDE	"obj_hide"
#define COMSI69_OBJ_TECHNO_TRIBALISM "techno_tribalism"
#define COMSI69_OBJ_FACTION_ITEM_DESTROY "faction_item_destroy"
#define SWORD_OF_TRUTH_OF_DESTRUCTION "sword_of_truth"

//machinery
#define COMSI69_AREA_APC_OPERATIN69 "area_operatin69"  //from apc process()
#define COMSI69_AREA_APC_DELETED "area_apc_69one"
#define COMSI69_AREA_APC_POWER_CHAN69E "area_apc_power_chan69e"
#define COMSIN69_DESTRUCTIVE_ANALIZER "destructive_analizer"
#define COMSI69_TURRENT "create_turrent"

// /obj/item si69nals
#define COMSI69_IATTACK "item_attack"									//from /mob/ClickOn(): (/atom, /src, /params) If any reply to this returns TRUE, overrides attackby and afterattack
#define COMSI69_ATTACKBY "attack_by"										//from /mob/ClickOn():
#define COMSI69_APPVAL "apply_values"									//from /atom/refresh_up69rades(): (/src) Called to up69rade specific69alues
#define COMSI69_ADDVAL "add_values" 										//from /atom/refresh_up69rades(): (/src) Called to add specific thin69s to the /src, called before COMSI69_APPVAL
#define COMSI69_REMOVE "uninstall"
#define COMSI69_ITEM_DROPPED	"item_dropped"					//from  /obj/item/tool/attackby(): Called to remove an up69rade
#define COMSI69_ITEM_PICKED "item_picked"

// /obj/item/clothin69 si69nals
#define COMSI69_CLOTH_DROPPED "cloths_missin69"
#define COMSI69_CLOTH_E69UIPPED "cloths_recovered"
#define COMSI69_69LASS_LENSES_REMOVED "lenses_removed" // lenses.dm

// /obj/item/implant si69nals

// /obj/item/pda si69nals

// /obj/item/radio si69nals
#define COMSI69_MESSA69E_SENT "radio_messa69e_sent"
#define COMSI69_MESSA69E_RECEIVED "radio_messa69e_received"

/*******Component Specific Si69nals*******/
//Janitor

// /datum/component/stora69e si69nals
#define COMSI69_STORA69E_INSERTED "item_inserted"
#define COMSI69_STORA69E_TAKEN "item_taken"
#define COMSI69_STORA69E_OPENED "new_backpack_who_dis"

// OVERMAP
#define COMSI69_SHIP_STILL "ship_still" // /obj/effect/overmap/ship/Process() && is_still()

/*******Non-Si69nal Component Related Defines*******/
