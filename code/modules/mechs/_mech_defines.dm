#define MECH_WEAPON_OVERLAYS_ICON			'icons/mechs/mech_weapon_overlays.dmi'
#define MECH_DECALS_ICON					'icons/mechs/mech_decals.dmi'
#define MECH_PARTS_HELD_ICON				'icons/mechs/mech_parts_held.dmi'
#define MECH_PARTS_ICON						'icons/mechs/mech_parts.dmi'
#define MECH_WRECKAGE_ICON					'icons/mechs/mech_wreckage.dmi'
#define MECH_EQUIPMENT_ICON					'icons/mechs/mech_equipment.dmi'
#define MECH_HUD_ICON						'icons/mechs/mech_hud.dmi'

#define HARDPOINT_BACK						"back"
#define HARDPOINT_FRONT						"front"
#define HARDPOINT_LEFT_HAND					"left hand"
#define HARDPOINT_RIGHT_HAND				"right hand"
#define HARDPOINT_LEFT_SHOULDER				"left shoulder"
#define HARDPOINT_RIGHT_SHOULDER			"right shoulder"
#define HARDPOINT_HEAD						"head"

// No software required: taser, light.
#define MECH_SOFTWARE_UTILITY				"utility equipment"				// Plasma torch, clamp, drill.
#define MECH_SOFTWARE_MEDICAL				"medical support systems"		// Sleeper.
#define MECH_SOFTWARE_WEAPONS				"standard weapon systems"		// Ballistics and energy weapons.
#define MECH_SOFTWARE_ADVWEAPONS			"advanced weapon systems"		// Railguns, missile launcher.
#define MECH_SOFTWARE_ENGINEERING			"advanced engineering systems"	// RCD.

// EMP damage points before various effects occur.
#define EMP_HUD_DISRUPT 					5								// 2 ion rifle shots //1 ion rifle shot == 4.5ish emp_damage w/ combat armor.
#define EMP_MOVE_DISRUPT 					10								// 3 shots.
#define EMP_STRAFE_DISABLE					10								// 3 shots.
#define EMP_ATTACK_DISRUPT 					20								// 5 shots.

//About components
#define MECH_COMPONENT_DAMAGE_UNDAMAGED		1
#define MECH_COMPONENT_DAMAGE_DAMAGED		2
#define MECH_COMPONENT_DAMAGE_DAMAGED_BAD	3
#define MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL	4

//Construction
#define FRAME_REINFORCED					1
#define FRAME_REINFORCED_SECURE				2
#define FRAME_REINFORCED_WELDED				3

#define FRAME_WIRED							1
#define FRAME_WIRED_ADJUSTED				2

#define MECH_WEAPON_POWER_COST				50

GLOBAL_DATUM_INIT(default_hardpoint_background,	/image,	null)
GLOBAL_DATUM_INIT(hardpoint_error_icon,			/image,	null)
GLOBAL_DATUM_INIT(hardpoint_bar_empty,			/image,	null)

GLOBAL_LIST_INIT(hardpoint_bar_cache,			new)
GLOBAL_LIST_INIT(mech_damage_overlay_cache,		new)
GLOBAL_LIST_INIT(mech_image_cache,				new)
GLOBAL_LIST_INIT(mech_icon_cache,				new)
GLOBAL_LIST_INIT(mech_weapon_overlays,			icon_states(MECH_WEAPON_OVERLAYS_ICON))

#define MECH_POWER_OFF 0
#define MECH_POWER_TRANSITION 1
#define MECH_POWER_ON 2

/// Strafing types
#define MECH_STRAFING_NONE 0
/// Can only strafe backwards
#define MECH_STRAFING_BACK 1
/// Can strafe in all directions
#define MECH_STRAFING_OMNI 2
/// It will make update_icon be called on the equipment after every move
#define EQUIPFLAG_UPDTMOVE 1
/// It will have pretick() called on it before the mech checks wheter or not is powered
#define EQUIPFLAG_PRETICK 2
///Any module with this flag will have their Process() called via exosuit/Life()
#define EQUIPFLAG_PROCESS 4
