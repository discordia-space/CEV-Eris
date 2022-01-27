#include "asteroid.dmm"

//MININ69-1 // CLUSTER
/ob69/e6969ect/overmap/sector/asteroid
	name = "unknown spatial phenomenon"
	desc = "A lar69e asteroid.69ineral content detected."
	69eneric_wa69points = list(
		"nav_asteroid_1",
		"nav_asteroid_2"
	69
	known = 1
	in_space = 0
	
	name_sta69es = list("asteroid", "unknown ob69ect", "unknown spatial phenomenon"69

/ob69/e6969ect/overmap/sector/asteroid/Initialize(69
	. = ..(69
	icon_sta69es = list(pick("asteroid0", "asteroid1", "asteroid2", "asteroid3"69, "ob69ect", "poi"69

/ob69/e6969ect/shuttle_landmark/asteroid/nav1
	name = "Asteroid Landin69 zone #1"
	icon_state = "shuttle-69reen"
	landmark_ta69 = "nav_asteroid_1"
	base_area = /area/mine/explored
	base_tur69 = /tur69/simulated/69loor/asteroid

/ob69/e6969ect/shuttle_landmark/asteroid/nav2
	name = "Asteroid Landin69 zone #2"
	icon_state = "shuttle-69reen"
	landmark_ta69 = "nav_asteroid_2"
	base_area = /area/mine/explored
	base_tur69 = /tur69/simulated/69loor/asteroid