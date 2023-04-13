#define LEVEL_BELOW 0
#define LEVEL_TURF 1
#define LEVEL_LYING 2
#define LEVEL_LOWWALL 3
#define LEVEL_TABLE 4
#define LEVEL_STANDING 5
#define LEVEL_ABOVE 6

#define PIXELS_PER_TURF 32
SUBSYSTEM_DEF(bullets)
	name = "Bullets"
	wait = 1
	priority = SS_PRIORITY_BULLETS
	init_order = INIT_ORDER_BULLETS

	var/list/datum/bullet_data/current_queue = list()
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
	SSbullets.bullet_queue += src

/datum/bullet_data/proc/getShootingAngle()
	return ATAN2(firedTurf.x - targetTurf.x, firedTurf.y - targetTurf.y)

/datum/bullet_data/proc/getCoordinateRatio()
	var/x = abs(firedTurf.x - targetTurf.x) * PIXELS_PER_TURF + targetCoords[1]
	var/y = abs(firedTurf.y - targetTurf.y) * PIXELS_PER_TURF + targetCoords[2]
	var/r = sqrt(x ? x**2 : 0 + y ? y**2 : 0)
	var/diff = x ? x/r : 0 - y ? y/r : 0
	if(x && y)
		// rounded down to 0.05 to keep it sane
		return diff > 0 ? list(round(x * (1 - diff)/100, 0.01), round((y * diff)/100, 0.05)) : list(round((x * abs(diff))/100, 0.05), round(y * (1 - abs(diff))/100, 0.01))
	else if(x)
		return list(1,0)
	else if(y)
		return list(0,1)

/datum/controller/subsystem/bullets/fire(resumed)
	if(!resumed)
		current_queue = bullet_queue.Copy()
	for(var/datum/bullet_data/bullet in current_queue)
		current_queue -= bullet
		if(!istype(bullet.referencedBullet, /obj/item/projectile/bullet))
			bullet_queue -= bullet
			continue
		var/list/ratios = bullet.getCoordinateRatio()
		var/list/coordinates = list(round(PIXELS_PER_TURF * ratios[1]) + bullet.currentCoords[1], round(PIXELS_PER_TURF * ratios[2]) + bullet.currentCoords[2])
		if(coordinates[1] > 32 || coordinates[2] > 32)
			var/newpx = coordinates[1] > PIXELS_PER_TURF ? PIXELS_PER_TURF : coordinates[1]
			var/newpy = coordinates[2] > PIXELS_PER_TURF ? PIXELS_PER_TURF : coordinates[2]
			animate(bullet.referencedBullet, pixel_x = newpx, pixel_y = newpy, time = 0.5)
			bullet.referencedBullet.Move(locate(round(coordinates[1]/PIXELS_PER_TURF), round(coordinates[2]/PIXELS_PER_TURF), bullet.referencedBullet.z))
			bullet.referencedBullet.pixel_x = coordinates[1] > PIXELS_PER_TURF ? PIXELS_PER_TURF - coordinates[1] : coordinates[1]
			bullet.referencedBullet.pixel_y = coordinates[2] > PIXELS_PER_TURF ? PIXELS_PER_TURF - coordinates[2] : coordinates[2]
			animate(bullet.referencedBullet, pixel_x = newpx, pixel_y = newpy, time = 0.5)
			bullet.currentCoords[1] = bullet.referencedBullet.pixel_x
			bullet.currentCoords[2] = bullet.referencedBullet.pixel_y
		else
			var/newpx = coordinates[1]
			var/newpy = coordinates[2]
			animate(bullet.referencedBullet, pixel_x = newpx, pixel_y = newpy, time = 1)
			bullet.currentCoords[1] = bullet.referencedBullet.pixel_x
			bullet.currentCoords[2] = bullet.referencedBullet.pixel_y




		//animate(bullet.referencedBullet, pixel_x = coordinates[1]%PIXELS_PER_TURF, pixel_y = coordinates[2]%PIXELS_PER_TURF, x = bullet.referencedBullet.x + round(coordinates[1]/32), y = bullet.referencedBullet.y + round(coordinates[2]/32), time = 1)
		current_queue -= bullet


#undef LEVEL_BELOW
#undef LEVEL_TURF
#undef LEVEL_LYING
#undef LEVEL_LOWWALL
#undef LEVEL_TABLE
#undef LEVEL_STANDING
#undef LEVEL_ABOVE

