#define MECHA_WEAPON_OVERLAYS_ICON			'icons/mecha2/mech_weapon_overlays.dmi'
#define MECHA_DECALS_ICON					'icons/mecha2/mech_decals.dmi'
#define MECHA_PARTS_HELD_ICON				'icons/mecha2/mech_parts_held.dmi'
#define MECHA_PARTS_ICON					'icons/mecha2/mech_parts.dmi'
#define MECHA_WRECKAGE_ICON					'icons/mecha2/mech_wreckage.dmi'
#define MECHA_EQUIPMENT_ICON				'icons/mecha2/mech_equipment.dmi'
#define MECHA_HUD_ICON						'icons/mecha2/mech_hud.dmi'

#define HARDPOINT_BACK						"back"
#define HARDPOINT_LEFT_HAND					"left hand"
#define HARDPOINT_RIGHT_HAND				"right hand"
#define HARDPOINT_LEFT_SHOULDER				"left shoulder"
#define HARDPOINT_RIGHT_SHOULDER			"right shoulder"
#define HARDPOINT_HEAD						"head"

// No software required: taser. light, radio.
#define MECH_SOFTWARE_UTILITY				"utility equipment"				// Plasma torch, clamp, drill.
#define MECH_SOFTWARE_MEDICAL				"medical support systems"		// Sleeper.
#define MECH_SOFTWARE_WEAPONS				"standard weapon systems"		// Ballistics and energy weapons.
#define MECH_SOFTWARE_ADVWEAPONS			"advanced weapon systems"		// Railguns, missile launcher.
#define MECH_SOFTWARE_ENGINEERING			"advanced engineering systems"	// RCD.

// EMP damage points before various effects occur.
#define EMP_HUD_DISRUPT 					5								// 1 ion rifle shot == 8.
#define EMP_MOVE_DISRUPT 					10								// 2 shots.
#define EMP_ATTACK_DISRUPT 					20								// 3 shots.

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

GLOBAL_DATUM_INIT(default_hardpoint_background,	/image,	null)
GLOBAL_DATUM_INIT(hardpoint_error_icon,			/image,	null)
GLOBAL_DATUM_INIT(hardpoint_bar_empty,			/image,	null)

GLOBAL_LIST_INIT(hardpoint_bar_cache,			new)
GLOBAL_LIST_INIT(mech_damage_overlay_cache,		new)
GLOBAL_LIST_INIT(mech_image_cache,				new)
GLOBAL_LIST_INIT(mech_icon_cache,				new)
GLOBAL_LIST_INIT(mech_weapon_overlays,			icon_states(MECHA_WEAPON_OVERLAYS_ICON))

	#include "mech.dm"
	#include "mech_construction.dm"
	#include "mech_damage.dm"
	#include "mech_damage_immunity.dm"
	#include "mech_icon.dm"
	#include "mech_interaction.dm"
	#include "mech_life.dm"
	#include "mech_movement.dm"
	#include "mech_misc.dm"
	#include "mech_recharger.dm"
	#include "mech_wreckage.dm"
	//#include "mech_skins.dm"

#include "components/_components.dm"
	#include "components/armour.dm"
	#include "components/arms.dm"
	#include "components/body.dm"
	#include "components/frame.dm"
	#include "components/head.dm"
	#include "components/legs.dm"
	#include "components/software.dm"

#include "equipment/_equipment.dm"
	#include "equipment/combat.dm"
	//#include "ai_holding.dm"
	#include "equipment/engineering.dm"
	#include "equipment/medical.dm"
	#include "equipment/utility.dm"

#include "interface/_mech_HUD.dm"
	#include "interface/screen_objects.dm"
	#include "interface/datum_HUD.dm"

#include "premade/_premade.dm"
	#include "premade/combat.dm"
	#include "premade/heavy.dm"
	#include "premade/light.dm"
	#include "premade/powerloader.dm"

#undef MECHA_WEAPON_OVERLAYS_ICON
#undef MECHA_DECALS_ICON
#undef MECHA_PARTS_HELD_ICON
#undef MECHA_PARTS_ICON
#undef MECHA_WRECKAGE_ICON
#undef MECHA_EQUIPMENT_ICON
#undef MECHA_HUD_ICON

#undef HARDPOINT_BACK
#undef HARDPOINT_LEFT_HAND
#undef HARDPOINT_RIGHT_HAND
#undef HARDPOINT_LEFT_SHOULDER
#undef HARDPOINT_RIGHT_SHOULDER
#undef HARDPOINT_HEAD

#undef MECH_SOFTWARE_UTILITY
#undef MECH_SOFTWARE_MEDICAL
#undef MECH_SOFTWARE_WEAPONS
#undef MECH_SOFTWARE_ADVWEAPONS
#undef MECH_SOFTWARE_ENGINEERING

#undef EMP_HUD_DISRUPT
#undef EMP_MOVE_DISRUPT
#undef EMP_ATTACK_DISRUPT 

#undef MECH_COMPONENT_DAMAGE_UNDAMAGED
#undef MECH_COMPONENT_DAMAGE_DAMAGED
#undef MECH_COMPONENT_DAMAGE_DAMAGED_BAD
#undef MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL

#undef FRAME_REINFORCED
#undef FRAME_REINFORCED_SECURE
#undef FRAME_REINFORCED_WELDED

#undef FRAME_WIRED
#undef FRAME_WIRED_ADJUSTED