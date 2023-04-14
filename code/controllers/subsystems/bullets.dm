#define LEVEL_BELOW 0
#define LEVEL_TURF 1
#define LEVEL_LYING 2
#define LEVEL_LOWWALL 3
#define LEVEL_TABLE 4
#define LEVEL_STANDING 5
#define LEVEL_ABOVE 6

/// Pixels per turf
#define PPT 32
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
/*
/datum/bullet_data/proc/getShootingAngle()
	//return TODEGREES(ATAN2((firedTurf.x - targetTurf.x) * PPT - targetCoords[1], (firedTurf.y - targetTurf.y)*PPT - targetCoords[2]))
	var/list/coordinates = list(0,0)
	coordinates[1] = ((targetTurf.x -firedTurf.x) * PPT + targetCoords[1]) / PPT + 0.0001
	coordinates[2] = ((targetTurf.y - firedTurf.y) * PPT + targetCoords[2]) / PPT + 0.0001
	var/ipotenuse = sqrt(coordinates[1] ** 2 + coordinates[2] ** 2)
	var/angleX = arcsin(coordinates[1]/ipotenuse)
	var/angleY = arccos(coordinates[2]/ipotenuse)

	return 90
*/

/// I hate trigonometry
/datum/bullet_data/proc/getCoordinateRatio()
	var/list/coordinates = list(0,0)
	coordinates[1] = ((targetTurf.x -firedTurf.x) * PPT + targetCoords[1]) / PPT + 0.0001
	coordinates[2] = ((targetTurf.y - firedTurf.y) * PPT + targetCoords[2]) / PPT + 0.0001
	var/ipotenuse = sqrt(coordinates[1] ** 2 + coordinates[2] ** 2)
	var/coordonate_median = abs(coordinates[1]) + abs(coordinates[2])
	//message_admins("X-ratio [coordinates[1]/coordonate_median], Y-ratio [coordinates[2]/coordonate_median]")
	return list(coordinates[1]/coordonate_median, coordinates[2]/coordonate_median)

/datum/controller/subsystem/bullets/fire(resumed)
	if(!resumed)
		current_queue = bullet_queue.Copy()
	for(var/datum/bullet_data/bullet in current_queue)
		current_queue -= bullet
		if(!istype(bullet.referencedBullet, /obj/item/projectile/bullet))
			bullet_queue -= bullet
			continue
		var/list/ratios = bullet.getCoordinateRatio()
		var/px = round(ratios[1] * PPT) + bullet.currentCoords[1]
		var/py = round(ratios[2] * PPT) + bullet.currentCoords[2]
		if(px > PPT/2 || py > PPT/2 || px < PPT/2 || py < PPT/2)
			message_admins("Moving [bullet.referencedBullet], y = [round(py/PPT)], py = [py], x = [round(px/PPT)], px = [px]")
			var/x_change = px > PPT/2 ? 1 : px < -PPT/2 ? -1 : 0
			var/y_change = py > PPT/2 ? 1 : py < -PPT/2 ? -1 : 0
			bullet.referencedBullet.Move(locate(bullet.referencedBullet.x + x_change, bullet.referencedBullet.y + y_change, bullet.referencedBullet.z))
			bullet.currentCoords[1] = px
			bullet.currentCoords[2] = py
			if(bullet.currentCoords[1] > PPT/2)
				bullet.currentCoords[1] -= PPT/2
			else if(bullet.currentCoords[1] < -PPT/2)
				bullet.currentCoords[1] += PPT/2
			if(bullet.currentCoords[2] > PPT/2)
				bullet.currentCoords[2] -= PPT/2
			else if(bullet.currentCoords[2] < -PPT/2)
				bullet.currentCoords[2] += PPT/2
			bullet.referencedBullet.pixel_x = bullet.currentCoords[1]
			bullet.referencedBullet.pixel_y = bullet.currentCoords[2]

		else
			bullet.currentCoords[1] = px
			bullet.referencedBullet.pixel_x = px
			bullet.currentCoords[2] = py
			bullet.referencedBullet.pixel_y = py
		if(QDELETED(bullet.referencedBullet))
			bullet_queue -= bullet
#undef LEVEL_BELOW
#undef LEVEL_TURF
#undef LEVEL_LYING
#undef LEVEL_LOWWALL
#undef LEVEL_TABLE
#undef LEVEL_STANDING
#undef LEVEL_ABOVE

