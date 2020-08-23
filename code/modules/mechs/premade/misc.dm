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
