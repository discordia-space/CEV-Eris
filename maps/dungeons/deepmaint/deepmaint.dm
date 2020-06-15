#include "deepmaint-1.dmm"
#include "deepmaint-2.dmm"
#include "deepmaint-3.dmm"

/obj/map_data/deepmaint
	name = "Deep Dark Marvelous"
	is_player_level = TRUE
	height = 1
	is_sealed = TRUE
	custom_z_names = TRUE
	var/distortion_level = 1

/obj/map_data/deepmaint/custom_z_name(z_level)
	return "Deck [pick(0, 1, 2, 3, 4, 5, 6, "N", "X", "Z")]"

/obj/map_data/deepmaint/lvl1
	distortion_level = 1

/obj/map_data/deepmaint/lvl2
	distortion_level = 2

/obj/map_data/deepmaint/lvl3
	distortion_level = 3
