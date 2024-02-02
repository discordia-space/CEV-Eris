// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice
//Example #define COMSIG_GLOB_NEW_Z "!new_z"								//from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_FABRIC_NEW "!fabric_new"					//(image/fabric)

//////////////////////////////////////////////////////////////////
// world signals

#define COMSIG_WORLD_MAXZ_INCREMENTING "world_maxz_increase"
// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of ClearFromParent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
/// you should only be using this if you want to block deletion
/// that's the only functional difference between it and COMSIG_PARENT_QDELETING, outside setting QDELETING to detect
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
/// after a datum's Destroy() is called: (force, qdel_hint), at this point none of the other components chose to interrupt qdel and Destroy has been called
#define COMSIG_PARENT_QDELETED "parent_qdeleted"

#define COMSIG_SHUTTLE_SUPPLY "shuttle_supply"  //form sell()
#define COMSIG_TRADE_BEACON "trade_beacon"
#define COMSIG_RITUAL_REVELATION "revelation_ritual"
#define COMSIG_GROUP_RITUAL "grup_ritual"
#define COMSIG_TRANSATION "transation"          //from transfer_funds()

#define COMSIG_NULL_TARGET "null_target"		// Used to null references created by targeting logic (mob targeting)
#define COMSIG_NULL_SECONDARY_TARGET "null_secondary_target"

/// generic topic handler (usr, href_list)
#define COMSIG_TOPIC "handle_topic"
/// handler for vv_do_topic (usr, href_list)
#define COMSIG_VV_TOPIC "vv_topic"
	#define COMPONENT_VV_HANDLED (1<<0)
/// from datum ui_act (usr, action)
#define COMSIG_UI_ACT "COMSIG_UI_ACT"

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"

// /atom signals
#define COMSIG_EXAMINE "examine"								//from atom/examine(): (mob/user, distance)
#define COMSIG_ATOM_UPDATE_OVERLAYS "atom_update_overlays"  //update_overlays()
#define COMSIG_ATOM_UNFASTEN "atom_unfasten" // set_anchored()
// Whenever we are put into a container of any sort , storage , closets , pockets. (atom/true_parent)
#define COMSIG_ATOM_CONTAINERED "atom_containered"

// /area signals
#define COMSIG_AREA_SANCTIFY "sanctify_area"

// /turf signals
#define COMSIG_TURF_LEVELUPDATE "turf_levelupdate" //levelupdate()

// /atom/movable signals
// These 2 can be sent at the same time togheter, if you only care about the Z-level , only use the Z-changed , else only use the moved.
#define COMSIG_MOVABLE_MOVED "movable_moved"					//from atom/movable/Move and forceMove: (/atom, origin_loc, new_loc)
#define COMSIG_MOVABLE_Z_CHANGED "movable_z_moved"				//from atom/movable/Move and forceMove): (oldz, newz)
#define COMSIG_MOVABLE_PREMOVE "moveable_boutta_move"

#define COMSIG_ATTEMPT_PULLING "attempt_pulling"
	#define COMSIG_PULL_CANCEL (1<<0)

// /mob signals
#define COMSIG_MOB_LIFE  "mob_life"							 //from mob/Life()
#define COMSIG_MOB_LOGIN "mob_login"							//from mob/Login()
#define COMSIG_MOB_DEATH "mob_death"							//from mob/death()
#define COMSIG_MOB_INITIALIZED "mob_initialized"
#define COMSIG_SHIFTCLICK "shiftclick" // used for ai_like_control component
#define COMSIG_CTRLCLICK "ctrlclick" // used for ai_like_control component
#define COMSIG_ALTCLICK "altclick" // used for ai_like_control component

// /mob/living signals
#define COMSIG_LIVING_STUN_EFFECT "stun_effect_act"			 //mob/living/proc/stun_effect_act()
#define COMSIG_CARBON_HAPPY   "carbon_happy"				   //drugs o ethanol in blood

// /mob/living/carbon signals
#define COMSIG_CARBON_ELECTROCTE "carbon_electrocute act"	   //mob/living/carbon/electrocute_act()
#define COMSIG_NSA "current_nsa"							   //current nsa
#define COMSIG_CARBON_ADICTION "new_chem_adiction"			  //from check_reagent()

// /mob/living/carbon/human signals
#define COMSIG_HUMAN_ACTIONINTENT_CHANGE "action_intent_change"
#define COMSIG_HUMAN_WALKINTENT_CHANGE "walk_intent_change"
#define COMSIG_EMPTY_POCKETS "human_empty_pockets"
#define COMSIG_HUMAN_SAY "human_say"							//from mob/living/carbon/human/say(): (message)
#define COMSIG_HUMAN_ROBOTIC_MODIFICATION "human_robotic_modification"
#define COMSIG_STAT "current_stat"							   //current stat
#define COMSIG_HUMAN_BREAKDOWN "human_breakdown"
#define COMSING_AUTOPSY "human_autopsy"						  //from obj/item/autopsy_scanner/attack()
#define COMSIG_HUMAN_ODDITY_LEVEL_UP "human_oddity_level_up"
#define COMSING_HUMAN_EQUITP "human_equip_item"				   //from human/equip_to_slot()
#define COMSIG_HUMAN_HEALTH "human_health"					   //from human/updatehealth()
#define COMSIG_HUMAN_SANITY "human_sanity"						//from /datum/sanity/proc/onLife()
#define COMSIG_HUMAN_INSTALL_IMPLANT "human_install_implant"
// /datum/species signals

// /obj signals
#define COMSIG_OBJ_HIDE	"obj_hide"
#define COMSIG_OBJ_TECHNO_TRIBALISM "techno_tribalism"
#define COMSIG_OBJ_FACTION_ITEM_DESTROY "faction_item_destroy"
#define SWORD_OF_TRUTH_OF_DESTRUCTION "sword_of_truth"

//machinery
#define COMSIG_AREA_APC_OPERATING "area_operating"  //from apc process()
#define COMSIG_AREA_APC_DELETED "area_apc_gone"
#define COMSIG_AREA_APC_POWER_CHANGE "area_apc_power_change"
#define COMSING_DESTRUCTIVE_ANALIZER "destructive_analizer"
#define COMSIG_TURRENT "create_turrent"
#define COMSIG_DOOR_OPENED "door_opened"
#define COMSIG_DOOR_CLOSED "door_closed"

// /obj/item signals
#define COMSIG_IATTACK "item_attack"									//from /mob/ClickOn(): (/atom, /src, /params) If any reply to this returns TRUE, overrides attackby and afterattack
#define COMSIG_ATTACKBY "attack_by"										//from /mob/ClickOn():
#define COMSIG_APPVAL "apply_values"									//from /atom/refresh_upgrades(): (/src) Called to upgrade specific values
#define COMSIG_ADDVAL "add_values" 										//from /atom/refresh_upgrades(): (/src) Called to add specific things to the /src, called before COMSIG_APPVAL
#define COMSIG_REMOVE "uninstall"
#define COMSIG_ITEM_DROPPED	"item_dropped"					//from  /obj/item/tool/attackby(): Called to remove an upgrade
#define COMSIG_ITEM_PICKED "item_picked"
#define COMSIG_ODDITY_USED "used_oddity"                    //from /datum/sanity/proc/oddity_stat_up(): called to notify the used oddity it was used.

// /obj/item/clothing signals
#define COMSIG_CLOTH_DROPPED "cloths_missing"
#define COMSIG_CLOTH_EQUIPPED "cloths_recovered"
#define COMSIG_GLASS_LENSES_REMOVED "lenses_removed" // lenses.dm

// /obj/item/implant signals

// /obj/item/pda signals

// /obj/item/radio signals
#define COMSIG_MESSAGE_SENT "radio_message_sent"
#define COMSIG_MESSAGE_RECEIVED "radio_message_received"

// Internal organ signals
#define COMSIG_IORGAN_REFRESH_SELF "internal_organ_self_refresh"
#define COMSIG_IORGAN_REFRESH_PARENT "internal_organ_parent_refresh"
#define COMSIG_IORGAN_APPLY "internal_organ_apply_modifiers"
#define COMSIG_IORGAN_ADD_WOUND "add_internal_wound"
#define COMSIG_IORGAN_REMOVE_WOUND "remove_internal_wound"
#define COMSIG_IORGAN_WOUND_COUNT "count_internal_wounds"

// Internal wound signals
#define COMSIG_IWOUND_EFFECTS "internal_wound_effects"
#define COMSIG_IWOUND_LIMB_EFFECTS "internal_wound_limb_effects"
#define COMSIG_IWOUND_FLAGS_ADD "internal_wound_flags_add"
#define COMSIG_IWOUND_FLAGS_REMOVE "internal_wound_flags_remove"
#define COMSIG_IWOUND_DAMAGE "internal_wound_damage"
#define COMSIG_IWOUND_TREAT "internal_wound_autodoc"

// Aberrant signals
#define COMSIG_ABERRANT_INPUT "aberrant_input"
#define COMSIG_ABERRANT_PROCESS "aberrant_process"
#define COMSIG_ABERRANT_OUTPUT "aberrant_output"
#define COMSIG_ABERRANT_SECONDARY "aberrant_secondary"
#define COMSIG_ABERRANT_COOLDOWN "aberrant_cooldown"

// Overmap and expeditions signals
#define COMSIG_GENERATE_DUNGEON "generate_dungeon"
#define COMSIG_DUNGEON_GENERATED "dungeon_generated"

/*******Component Specific Signals*******/
//Janitor

// /datum/component/storage signals
#define COMSIG_STORAGE_INSERTED "item_inserted"
#define COMSIG_STORAGE_TAKEN "item_taken"
#define COMSIG_STORAGE_OPENED "new_backpack_who_dis"

// OVERMAP
#define COMSIG_SHIP_STILL "ship_still" // /obj/effect/overmap/ship/Process() && is_still()

/*******Non-Signal Component Related Defines*******/
