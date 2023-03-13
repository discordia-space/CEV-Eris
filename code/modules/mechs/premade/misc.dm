/obj/item/mech_component/propulsion/quad
	name = "quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "Specialized quadlegs designed to minimize time wasted reorienting the mech."
	icon_state = "spiderlegs"
	max_damage = 90
	move_delay = 3
	turn_delay = 1
	power_use = 75
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 10, MATERIAL_SILVER = 3)

/obj/item/mech_component/propulsion/tracks
	name = "tracks"
	exosuit_desc_string = "armored tracks"
	desc = "A true classic, these tracks are fast and durable, although turning with them is a nightmare."
	icon_state = "tracks"
	max_damage = 180
	move_delay = 1.5
	turn_delay = 7
	power_use = 150
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 10)
	mech_step_sound = 'sound/mechs/tanktread.ogg'
	can_strafe = FALSE

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	hatch_descriptor = "hatch"
	pilot_coverage = 100
	hide_pilot = TRUE //Sprite too small, legs clip through, so for now hide pilot
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 150
	mech_health = 350 //Default is 300, so 50 more HP then the power loader. Worse then the combat chassis as it requires sensors.
	power_use = 5
	climb_time = 30
	matter = list(MATERIAL_STEEL = 25, MATERIAL_PLASTEEL = 7, MATERIAL_GLASS = 12)
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "A rugged design originally intended for space pods, this chassis has been refitted for exosuit usage. It's relatively spacious interior allows it to carry up to 3 pilots."

/obj/item/mech_component/chassis/pod/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 4),
			"[SOUTH]" = list("x" = 8,  "y" = 4),
			"[EAST]"  = list("x" = 12,  "y" = 4),
			"[WEST]"  = list("x" = 4,  "y" = 4)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 10,  "y" = 8),
			"[WEST]"  = list("x" = 6, "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 12),
			"[SOUTH]" = list("x" = 8,  "y" = 12),
			"[EAST]"  = list("x" = 10,  "y" = 12),
			"[WEST]"  = list("x" = 6, "y" = 12)
		)
	)
	. = ..()
