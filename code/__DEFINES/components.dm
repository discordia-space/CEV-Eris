#define SEND_SIGNAL(target, sigtype, arguments...) ( !target.comp_lookup || !target.comp_lookup[sigtype] ? NONE : target._SendSignal(sigtype, list(##arguments)) )

#define SEND_GLOBAL_SIGNAL(sigtype, arguments...) ( SEND_SIGNAL(SSdcs, sigtype, ##arguments) )

//shorthand
#define GET_COMPONENT_FROM(varname, path, target) var##path/##varname = ##target.GetComponent(##path)
#define GET_COMPONENT(varname, path) GET_COMPONENT_FROM(varname, path, src)

#define COMPONENT_INCOMPATIBLE 1
#define COMPONENT_NOTRANSFER 2

// How multiple components of the exact same type are handled in the same datum

#define COMPONENT_DUPE_HIGHLANDER		0		//old component is deleted (default)
#define COMPONENT_DUPE_ALLOWED			1	//duplicates allowed
#define COMPONENT_DUPE_UNIQUE			2	//new component is deleted
#define COMPONENT_DUPE_UNIQUE_PASSARGS	4	//old component is given the initialization args of the new

// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice
//Example #define COMSIG_GLOB_NEW_Z "!new_z"								//from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_FABRIC_NEW "!fabric_new"                    //(image/fabric)

//////////////////////////////////////////////////////////////////

// /datum signals
#define COMSIG_COMPONENT_ADDED "component_added"				//when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"			//before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"			//before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_QDELETING "parent_qdeleting"              // just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETED "parent_qdeleted"				//after a datum's Destroy() is called: (force, qdel_hint), at this point none of the other components chose to interrupt qdel and Destroy has been called


// /atom signals
#define COMSIG_EXAMINE "examine"								//from atom/examine(): (mob/user, distance)

// /area signals

// /turf signals

// /atom/movable signals
#define COMSIG_MOVABLE_MOVED "movable_moved"					//from base of atom/movable/Moved(): (/atom, origin_loc, new_loc)

// /mob signals
#define COMSIG_MOB_LIFE  "mob_life"                             //from mob/Life()
#define COMSIG_MOB_LOGIN "mob_login"                            //from mob/Login()

// /mob/living signals
#define COMSIG_LIVING_STUN_EFFECT "stun_effect_act"             //mob/living/proc/stun_effect_act

// /mob/living/carbon signals
#define COMSIG_CARBON_ELECTROCTE "carbon_electrocute act"       //mob/living/carbon/electrocute_act

// /mob/living/carbon/human signals
#define COMSIG_HUMAN_SAY "human_say"                            //from mob/living/carbon/human/say(): (message)
#define COMSIG_HUMAN_ROBOTIC_MODIFICATION "human_robotic_modification"

// /datum/species signals

// /obj signals

// /obj/item signals
#define COMSIG_IATTACK "item_attack"									//from /mob/ClickOn(): (/atom, /src, /params) If any reply to this returns TRUE, overrides attackby and afterattack
#define COMSIG_ATTACKBY "attack_by"										//from /mob/ClickOn():
#define COMSIG_APPVAL "apply_values"									//from /atom/refresh_upgrades(): (/src) Called to upgrade specific values
#define COMSIG_ADDVAL "add_values" 										//from /atom/refresh_upgrades(): (/src) Called to add specific things to the /src, called before COMSIG_APPVAL
#define COMSIG_REMOVE "uninstall"										//from  /obj/item/weapon/tool/attackby(): Called to remove an upgrade
// /obj/item/clothing signals

// /obj/item/implant signals

// /obj/item/pda signals

// /obj/item/radio signals

/*******Component Specific Signals*******/
//Janitor

// /datum/component/storage signals

/*******Non-Signal Component Related Defines*******/

