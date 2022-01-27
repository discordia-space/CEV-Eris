#define69ECH_WEAPON_OVERLAYS_ICON			'icons/mechs/mech_weapon_overlays.dmi'
#define69ECH_DECALS_ICON					'icons/mechs/mech_decals.dmi'
#define69ECH_PARTS_HELD_ICON				'icons/mechs/mech_parts_held.dmi'
#define69ECH_PARTS_ICON						'icons/mechs/mech_parts.dmi'
#define69ECH_WRECKAGE_ICON					'icons/mechs/mech_wreckage.dmi'
#define69ECH_E69UIPMENT_ICON					'icons/mechs/mech_e69uipment.dmi'
#define69ECH_HUD_ICON						'icons/mechs/mech_hud.dmi'

#define HARDPOINT_BACK						"back"
#define HARDPOINT_LEFT_HAND					"left hand"
#define HARDPOINT_RIGHT_HAND				"right hand"
#define HARDPOINT_LEFT_SHOULDER				"left shoulder"
#define HARDPOINT_RIGHT_SHOULDER			"right shoulder"
#define HARDPOINT_HEAD						"head"

//69o software re69uired: taser, light.
#define69ECH_SOFTWARE_UTILITY				"utility e69uipment"				// Plasma torch, clamp, drill.
#define69ECH_SOFTWARE_MEDICAL				"medical support systems"		// Sleeper.
#define69ECH_SOFTWARE_WEAPONS				"standard weapon systems"		// Ballistics and energy weapons.
#define69ECH_SOFTWARE_ADVWEAPONS			"advanced weapon systems"		// Railguns,69issile launcher.
#define69ECH_SOFTWARE_ENGINEERING			"advanced engineering systems"	// RCD.

// EMP damage points before69arious effects occur.
#define EMP_HUD_DISRUPT 					5								// 2 ion rifle shots //1 ion rifle shot == 4.5ish emp_damage w/ combat armor.
#define EMP_MOVE_DISRUPT 					10								// 3 shots.
#define EMP_STRAFE_DISABLE					10								// 3 shots.
#define EMP_ATTACK_DISRUPT 					20								// 5 shots.

//About components
#define69ECH_COMPONENT_DAMAGE_UNDAMAGED		1
#define69ECH_COMPONENT_DAMAGE_DAMAGED		2
#define69ECH_COMPONENT_DAMAGE_DAMAGED_BAD	3
#define69ECH_COMPONENT_DAMAGE_DAMAGED_TOTAL	4

//Construction
#define FRAME_REINFORCED					1
#define FRAME_REINFORCED_SECURE				2
#define FRAME_REINFORCED_WELDED				3

#define FRAME_WIRED							1
#define FRAME_WIRED_ADJUSTED				2

#define69ECH_WEAPON_POWER_COST				50

GLOBAL_DATUM_INIT(default_hardpoint_background,	/image,	null)
GLOBAL_DATUM_INIT(hardpoint_error_icon,			/image,	null)
GLOBAL_DATUM_INIT(hardpoint_bar_empty,			/image,	null)

GLOBAL_LIST_INIT(hardpoint_bar_cache,			new)
GLOBAL_LIST_INIT(mech_damage_overlay_cache,		new)
GLOBAL_LIST_INIT(mech_image_cache,				new)
GLOBAL_LIST_INIT(mech_icon_cache,				new)
GLOBAL_LIST_INIT(mech_weapon_overlays,			icon_states(MECH_WEAPON_OVERLAYS_ICON))
