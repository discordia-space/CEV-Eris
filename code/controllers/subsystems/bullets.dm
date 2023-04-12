#define LEVEL_BELOW 0
#define LEVEL_TURF 1
#define LEVEL_LYING 2
#define LEVEL_LOWWALL 3
#define LEVEL_TABLE 4
#define LEVEL_STANDING 5
#define LEVEL_ABOVE 6
SUBSYSTEM_DEF(bullets)
	name = "Bullets"
	wait = 1
	priority = SS_PRIORITY_BULLETS
	init_order = INIT_ORDER_BULLETS

	var/list/current_queue = list()
	var/list/hitscans = list()
	var/list/datum/bullet_data/bullet_queue = list()

/datum/bullet_data
	var/obj/item/projectile/referencedBullet = null
	var/aimedZone = ""
	var/atom/firer = null
	var/turf/firedTurf = null
	var/firedLevel = 0
	var/atom/target = null
	var/turf/targetTurf = null
	var/list/targetCoords = list(0,0)
	var/turf/currentTurf = null
	var/currentCoords = list(0,0)
	var/targetLevel = 0
	var/turfsPerTick = 0
	var/projectileAccuracy = 0
	var/lifetime = 10
	var/bulletLevel = 0

/datum/bullet_data/New(atom/referencedBullet, aimedZone, atom/firer, atom/target, list/targetCoords, turfsPerTick, projectileAccuracy, lifetime)
	src.referencedBullet = referencedBullet
	src.currentTurf = get_turf(referencedBullet)
	src.currentCoords = list(referencedBullet.pixel_x, referencedBullet.pixel_y)
	src.aimedZone = aimedZone
	src.firer = firer
	src.firedTurf = get_turf(firer)
	src.target = target
	src.targetTurf = get_turf(target)
	src.targetCoords = targetCoords
	src.turfsPerTick = turfsPerTick
	src.projectileAccuracy = projectileAccuracy
	src.lifetime = lifetime
	if(ismob(firer))
		if(iscarbon(firer))
			if(firer:lying)
				src.firedLevel = LEVEL_LYING
			else
				src.firedLevel = LEVEL_STANDING
		else
			src.firedLevel = LEVEL_STANDING
	else
		src.firedLevel = LEVEL_STANDING
	if(ismob(target))
		if(iscarbon(target))
			if(target:lying)
				src.targetLevel = LEVEL_LYING
			else
				src.targetLevel = LEVEL_STANDING
		else
			src.targetLevel = LEVEL_STANDING
	else if(istype(target, /obj/structure/low_wall))
		src.targetLevel = LEVEL_LOWWALL
	else if(istype(target, /obj/structure/window))
		src.targetLevel = LEVEL_STANDING
	else if(istype(target, /obj/structure/table))
		src.targetLevel = LEVEL_TABLE
	else if(iswall(target))
		src.targetLevel = LEVEL_STANDING
	else if(isturf(target))
		src.targetLevel = LEVEL_TURF
	else if(isitem(target))
		src.targetLevel = LEVEL_TURF
	bullet_queue += src

/datum/bullet_data/proc/getShootingAngle()
	return ATAN2(firedTurf.x - targetTurf.x, firedTurf.y - targetTurf.y)

/datum/controller/subsystem/bullets/fire(resumed)
	. = ..()

#undef LEVEL_BELOW
#undef LEVEL_TURF
#undef LEVEL_LYING
#undef LEVEL_LOWWALL
#undef LEVEL_TABLE
#undef LEVEL_STANDING
#undef LEVEL_ABOVE

