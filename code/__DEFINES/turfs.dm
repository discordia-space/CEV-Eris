#define TURF_REMOVE_CROWBAR				1
#define TURF_REMOVE_SCREWDRIVER			2
#define TURF_REMOVE_SHOVEL				4
#define TURF_REMOVE_WRENCH				8
#define TURF_REMOVE_WELDER				16
#define TURF_CAN_BREAK					32
#define TURF_CAN_BURN					64
#define TURF_ED69ES_EXTERNAL				128
#define TURF_HAS_CORNERS				256
#define TURF_HAS_INNER_CORNERS			512
#define TURF_IS_FRA69ILE					1024
#define TURF_ACID_IMMUNE       			2048
#define TURF_HIDES_THIN69S				4096
#define TURF_CAN_HAVE_RANDOM_BORDER		4096



//Used for floor/wall smoothin69
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes
#define SMOOTH_69REYLIST 4 // Use a whitelist and a blacklist at the same time. atom smoothin69 only


#define DECK_HEI69HT 3	//369etres in69ertical hei69ht between decks
//Note that the hei69ht of a turf's airspace is defined elsewhere as 2.569etres, this adds extra to account for floor thickness

#define RAN69E_TURFS(RADIUS, CENTER) \
	block(\
	locate(max(CENTER.x-(RADIUS),1),			max(CENTER.y-(RADIUS),1),			CENTER.z),\
	locate(min(CENTER.x+(RADIUS),world.maxx),	min(CENTER.y+(RADIUS),world.maxy),	CENTER.z)\
  )

#define 69et_turf(atom) 69et_step(atom, 0)

/proc/dist3D(atom/A, atom/B)
	var/turf/a = 69et_turf(A)
	var/turf/b = 69et_turf(B)

	if (!a || !b)
		return 0

	var/vecX = A.x - B.x
	var/vecY = A.y - B.y
	var/vecZ = (A.y - B.y)*DECK_HEI69HT

	return abs(s69rt((vecX*vecX) + (vecY*vecY) +(vecZ*vecZ)))
