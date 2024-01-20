#define LEVEL_BELOW 0
#define LEVEL_TURF 0.2
#define LEVEL_LYING 0.3
#define LEVEL_LOWWALL 0.5
#define LEVEL_TABLE 0.6
#define LEVEL_STANDING 0.8
#define LEVEL_ABOVE 1

/// Pixels per turf
#define PPT 32
SUBSYSTEM_DEF(bullets)
	name = "Bullets"
	wait = 1
	priority = SS_PRIORITY_BULLETS
	init_order = INIT_ORDER_BULLETS

	var/list/datum/bullet_data/current_queue = list()
	var/list/datum/bullet_data/bullet_queue = list()



/// You might ask why use a bullet data datum, and not store all the vars on the bullet itself, honestly its to keep track and initialize firing relevant vars only when needed
/// This data is guaranteed to be of temporary use spanning 15-30 seconds or how long the bullet moves for. Putting them on the bullet makes each one take up more ram
/// And ram is not a worry , but its better to initialize less and do the lifting on fire.
/datum/bullet_data
	var/obj/item/projectile/referencedBullet = null
	var/aimedZone = ""
	var/atom/firer = null
	var/turf/firedTurf = null
	var/list/firedCoordinates = list(0,0,0)
	var/firedLevel = 0
	var/atom/target = null
	var/turf/targetTurf = null
	var/list/targetCoords = list(0,0,0)
	var/turf/currentTurf = null
	var/currentCoords = list(0,0,0)
	var/movementRatios = list(0,0,0,0)
	var/list/turf/coloreds = list()
	var/targetLevel = 0
	var/currentLevel = 0
	var/turfsPerTick = 0
	var/projectileAccuracy = 0
	var/lifetime = 10
	var/bulletLevel = 0

/datum/bullet_data/New(atom/referencedBullet, aimedZone, atom/firer, atom/target, list/targetCoords, turfsPerTick, projectileAccuracy, lifetime)
	src.referencedBullet = referencedBullet
	src.currentTurf = get_turf(referencedBullet)
	src.currentCoords = list(referencedBullet.pixel_x, referencedBullet.pixel_y, 0)
	src.aimedZone = aimedZone
	src.firer = firer
	src.firedTurf = get_turf(firer)
	src.target = target
	src.targetTurf = get_turf(target)
	src.targetCoords = targetCoords
	//src.targetCoords = list(8,8, targetTurf.z)
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
	src.firedCoordinates = list(8,8, referencedBullet.z)
	src.currentCoords[3] += firedLevel
	updateCoordinateRatio()
	SSbullets.bullet_queue += src

/// I hate trigonometry, but i hate ATAN2 more.
/datum/bullet_data/proc/updateCoordinateRatio()
	var/list/coordinates = list(0,0,0)
	// These add 0.0001 so in the case we are firing straight we don't have to handle special cases(division by 0)
	// The 0.0001 are meaningless overall considering the scale of calculation.
	coordinates[1] = ((targetTurf.x - firedTurf.x) * PPT + targetCoords[1] - firedCoordinates[1]) / PPT + 0.0001
	coordinates[2] = ((targetTurf.y - firedTurf.y) * PPT + targetCoords[2] - firedCoordinates[2]) / PPT + 0.0001
	var/r = sqrt(coordinates[1] ** 2 + coordinates[2] ** 2)
	coordinates[3] = (targetCoords[3] - firedCoordinates[3] + targetLevel - firedLevel)/r
	coordinates[1] = coordinates[1]/r
	coordinates[2] = coordinates[2]/r
	// [1] is X ratio , [2] is Y ratio,  [3] is Z-ratio
	movementRatios = coordinates

/datum/bullet_data/proc/updateLevel()
	switch(currentCoords[3])
		if(-INFINITY to LEVEL_BELOW)
			currentLevel = LEVEL_BELOW
		if(LEVEL_BELOW to LEVEL_TURF)
			currentLevel = LEVEL_TURF
		if(LEVEL_TURF to LEVEL_LYING)
			currentLevel = LEVEL_LYING
		if(LEVEL_LYING to LEVEL_LOWWALL)
			currentLevel = LEVEL_LOWWALL
		if(LEVEL_LOWWALL to LEVEL_TABLE)
			currentLevel = LEVEL_TABLE
		if(LEVEL_TABLE to LEVEL_STANDING)
			currentLevel = LEVEL_STANDING
		if(LEVEL_STANDING to INFINITY)
			currentLevel = LEVEL_ABOVE

/datum/bullet_data/proc/getLevel(height)
	switch(height)
		if(-INFINITY to LEVEL_BELOW)
			return LEVEL_BELOW
		if(LEVEL_BELOW to LEVEL_TURF)
			return LEVEL_TURF
		if(LEVEL_TURF to LEVEL_LYING)
			return LEVEL_LYING
		if(LEVEL_LYING to LEVEL_LOWWALL)
			return LEVEL_LOWWALL
		if(LEVEL_LOWWALL to LEVEL_TABLE)
			return LEVEL_TABLE
		if(LEVEL_TABLE to LEVEL_STANDING)
			return LEVEL_STANDING
		if(LEVEL_STANDING to INFINITY)
			return LEVEL_ABOVE

/datum/controller/subsystem/bullets/proc/reset()
	current_queue = list()
	bullet_queue = list()

/datum/controller/subsystem/bullets/fire(resumed)
	if(!resumed)
		current_queue = bullet_queue.Copy()
	for(var/datum/bullet_data/bullet in current_queue)
		current_queue -= bullet
		if(!istype(bullet.referencedBullet, /obj/item/projectile/bullet))
			bullet_queue -= bullet
			continue
		var/px = bullet.movementRatios[1] * bullet.turfsPerTick + bullet.currentCoords[1]
		var/py = bullet.movementRatios[2] * bullet.turfsPerTick + bullet.currentCoords[2]
		var/pz = bullet.movementRatios[3] + bullet.currentCoords[3]
		var/x_change = 0
		var/y_change = 0
		var/z_change = 0
		var/turf/target_turf
		while(px >= PPT/2 || py >= PPT/2 || px <= -PPT/2 || py <= -PPT/2 || pz > 1 || pz < 0)
			message_admins("Moving [bullet.referencedBullet], y = [round(py/PPT)], py = [py], x = [round(px/PPT)], px = [px], pz = [pz]")
			if(QDELETED(bullet.referencedBullet))
				break
			x_change = px >= PPT/2 ? 1 : px <= -PPT/2 ? -1 : 0
			y_change = py >= PPT/2 ? 1 : py <= -PPT/2 ? -1 : 0
			if(round(pz) > 1)
				z_change = 1
			else if(round(pz) < 0)
				z_change = -1
			px += -1 * x_change * PPT/2
			py += -1 * y_change * PPT/2
			pz += -1 * z_change
			target_turf = locate(bullet.referencedBullet.x + x_change, bullet.referencedBullet.y + y_change, bullet.referencedBullet.z + z_change)
			if(!target_turf)
				bullet_queue -= bullet
				break
			//if(iswall(target_turf) && target_turf:projectileBounceCheck())
			bullet.updateLevel()
			if(iswall(target_turf))
				var/turf/simulated/wall/the_rock = target_turf
				/// Calculate coefficients for movement
				var/dist_x = (the_rock.x - bullet.firedTurf.x) * PPT/2
				var/dist_y = (the_rock.y - bullet.firedTurf.y) * PPT/2
				if(!dist_x) dist_x++
				if(!dist_y) dist_y++
				/// Adjust for the actual point of contact
				var/angle
				if(abs(dist_y) > abs(dist_x))
					// Bullet offset
					dist_y += bullet.firedCoordinates[2]
					// Edge offset
					dist_x += dist_x/abs(dist_x) * PPT/2
					// Get the angle , necesarry geometry evil.
					angle = arcsin(dist_x/(sqrt(dist_x**2+dist_y**2)))
				else
					// Bullet offset
					dist_x += bullet.firedCoordinates[1]
					// Edge offset
					dist_y += dist_y/abs(dist_y) * PPT/2
					// Get the angle , necesarry geometry evil..
					angle = arcsin(dist_y/(sqrt(dist_x**2+dist_y**2)))
				message_admins("calculated angle is [angle]")
				/*
				var/x_ratio = the_rock.x - bullet.firedTurf.x
				var/y_ratio = the_rock.y - bullet.firedTurf.y
				x_ratio += x_ratio != 0 ? x_ratio/abs(x_ratio) : 1
				y_ratio += y_ratio != 0 ? y_ratio/abs(y_ratio) : 1
				x_ratio = x_ratio * 16 + 8 * x_ratio/abs(x_ratio) - bullet.currentCoords[1]
				y_ratio = y_ratio * 16 + 8 * y_ratio/abs(y_ratio) - bullet.currentCoords[2]
				// This covers anything below 45 to 0 , 135 to 180, -45 to 0 , and -135 to -180
				// (Just take a look at tangent tables)
				message_admins("x-ratio : [x_ratio] ,   y-ratio : [y_ratio]")
				var/c_ratio = abs(x_ratio)/abs(y_ratio)
				var/s_ratio = abs(y_ratio/abs(x_ratio))
				if(c_ratio > 1.3 && c_ratio < 4 || c_ratio < 0.4 && c_ratio > 0)
					if(abs(x_ratio) < abs(y_ratio))
						bullet.movementRatios[1] = -bullet.movementRatios[1]
						px = -px
					else
						bullet.movementRatios[2] = -bullet.movementRatios[2]
						py = -py
					target_turf = null
				*/

				/*
				var/angle = TODEGREES(ATAN2(the_rock.x - bullet.referencedBullet.x, the_rock.y - bullet.referencedBullet.y))
				// third quadrant is a lil silly
				if(the_rock.x - bullet.referencedBullet.x < 0 && the_rock.y - bullet.referencedBullet.y < 0)
					angle = -(180+angle)
				if(abs(angle) <= 45 || abs(angle) >= 135)
					var/opposite_angle
					if(angle > 0)
						opposite_angle = 180 - angle
					else
						opposite_angle = -(angle + 180)
				*/



			if(target_turf)
				bullet.referencedBullet.Move(target_turf)
				bullet.coloreds |= target_turf
				target_turf.color = "#2fff05ee"


		bullet.currentCoords[1] = px
		bullet.currentCoords[2] = py
		bullet.currentCoords[3] = pz
		bullet.referencedBullet.pixel_x = round(bullet.currentCoords[1])
		bullet.referencedBullet.pixel_y = round(bullet.currentCoords[2])
		if(QDELETED(bullet.referencedBullet))
			bullet_queue -= bullet
			for(var/turf/thing in bullet.coloreds)
				thing.color = initial(thing.color)
#undef LEVEL_BELOW
#undef LEVEL_TURF
#undef LEVEL_LYING
#undef LEVEL_LOWWALL
#undef LEVEL_TABLE
#undef LEVEL_STANDING
#undef LEVEL_ABOVE

