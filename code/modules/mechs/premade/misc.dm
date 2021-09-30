//This file is for loose, specialized parts that don't fit into the typical mechs.
//The idea is to encourage more experimentation with swapping parts by providing more specialized options to players.
//Sprites taken from bay, as with rest of the mech stuff.
/obj/item/mech_component/propulsion/quad
	name = "quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "Specialized quadlegs designed to minimize time wasted reorienting the mech."
	icon_state = "spiderlegs"
	max_damage = 80
	move_delay = 4
	turn_delay = 1
	power_use = 75
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 5)

/obj/item/mech_component/propulsion/tracks
	name = "tracks"
	exosuit_desc_string = "armored tracks"
	desc = "A true classic, these tracks are fast and durable, although turning with them is a nightmare."
	icon_state = "tracks"
	max_damage = 150
	move_delay = 2
	turn_delay = 7
	power_use = 150
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 5)
	mech_step_sound = 'sound/mechs/tanktread.ogg'

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	hatch_descriptor = "hatch"
	pilot_coverage = 100
	hide_pilot = TRUE //Sprite too small, legs clip through, so for now hide pilot
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 100
	mech_health = 350 //Default is 300, so 50 more HP then the power loader. Worse then the combat chassis as it requires sensors.

	power_use = 5
	climb_time = 30 // Awkward to get in/out of as it's intended for spacepod use
	matter = list(MATERIAL_STEEL = 25, MATERIAL_PLASTEEL = 5, MATERIAL_GLASS = 10)
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "A rugged design originally intended for light EVA crafts, this chassis has been refitted for exosuit usage. It's surprisingly durable for its cost"
