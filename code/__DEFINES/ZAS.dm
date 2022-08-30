//#define ZASDBG
#define MULTIZAS

#define AIR_BLOCKED 1
#define ZONE_BLOCKED 2
#define BLOCKED 3

#define ZONE_MIN_SIZE 14 //zones with less than this many turfs will always merge, even if the connection is not direct

#define CANPASS_ALWAYS 1
#define CANPASS_DENSITY 2
#define CANPASS_PROC 3
#define CANPASS_NEVER 4

#define NORTHUP (NORTH|UP)
#define EASTUP (EAST|UP)
#define SOUTHUP (SOUTH|UP)
#define WESTUP (WEST|UP)
#define NORTHDOWN (NORTH|DOWN)
#define EASTDOWN (EAST|DOWN)
#define SOUTHDOWN (SOUTH|DOWN)
#define WESTDOWN (WEST|DOWN)

#define TURF_HAS_VALID_ZONE(T) (istype(T, /turf/simulated) && T:zone && !T:zone:invalid)

#ifdef MULTIZAS

GLOBAL_LIST_INIT(gzn_check, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	UP,
	DOWN
))

GLOBAL_LIST_INIT(csrfz_check, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST,
	NORTHUP,
	EASTUP,
	WESTUP,
	SOUTHUP,
	NORTHDOWN,
	EASTDOWN,
	WESTDOWN,
	SOUTHDOWN
))
// this proc was adapted to work with eris from bay
// they have flags to define tile interaction between z-levels
// we dont(because its really unnecesarry)
// They  have this flag called ZM_ALLOW_ATMOS,  which is only used for open-space.
// If you want to permit more types of turfs to move air , just make the check a function
// and check each type in order of commonality.
#define ATMOS_CANPASS_TURF(ret,A,B) \
	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED) { \
		ret = BLOCKED; \
	} \
	else if (B.z != A.z) { \
		if (B.z < A.z) { \
			ret = istype(A, /turf/simulated/open) ? ZONE_BLOCKED : BLOCKED; \
		} \
		else { \
			ret = istype(B, /turf/simulated/open) ? ZONE_BLOCKED : BLOCKED; \
		} \
	} \
	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED) { \
		ret = (A.z == B.z) ? ZONE_BLOCKED : AIR_BLOCKED; \
	} \
	else if (A.contents.len) { \
		ret = 0;\
		for (var/thing in A) { \
			var/atom/movable/AM = thing; \
			switch (AM.atmos_canpass) { \
				if (CANPASS_ALWAYS) { \
					continue; \
				} \
				if (CANPASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED; \
					} \
				} \
				if (CANPASS_PROC) { \
					ret |= AM.c_airblock(B); \
				} \
				if (CANPASS_NEVER) { \
					ret = BLOCKED; \
				} \
			} \
			if (ret == BLOCKED) { \
				break;\
			}\
		}\
	}
#else

GLOBAL_LIST_INIT(csrfz_check, list(
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST
))

GLOBAL_LIST_INIT(gzn_check, list(
	NORTH,
	SOUTH,
	EAST,
	WEST
))

#define ATMOS_CANPASS_TURF(ret,A,B) \
	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED) { \
		ret = BLOCKED; \
	} \
	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED) { \
		ret = ZONE_BLOCKED; \
	} \
	else if (A.contents.len) { \
		ret = 0;\
		for (var/thing in A) { \
			var/atom/movable/AM = thing; \
			switch (AM.atmos_canpass) { \
				if (CANPASS_ALWAYS) { \
					continue; \
				} \
				if (CANPASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED; \
					} \
				} \
				if (CANPASS_PROC) { \
					ret |= AM.c_airblock(B); \
				} \
				if (CANPASS_NEVER) { \
					ret = BLOCKED; \
				} \
			} \
			if (ret == BLOCKED) { \
				break;\
			}\
		}\
	}

#endif
