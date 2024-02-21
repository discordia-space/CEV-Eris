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
	var/list/firedPos = list(0,0,0)
	var/firedLevel = 0
	var/atom/target = null
	var/turf/targetTurf = null
	var/list/targetCoords = list(0,0,0)
	var/list/targetPos = list(0,0,0)
	var/turf/currentTurf = null
	var/currentCoords = list(0,0,0)
	var/movementRatios = list(0,0,0,0)
	var/list/turf/coloreds = list()
	var/targetLevel = 0
	var/currentLevel = 0
	var/turfsPerTick = 0
	var/projectileAccuracy = 0
	var/lifetime = 30
	var/bulletLevel = 0

/datum/bullet_data/New(atom/referencedBullet, aimedZone, atom/firer, atom/target, list/targetCoords, turfsPerTick, projectileAccuracy, lifetime)
	if(!target)
		message_admins("Created bullet without target , [referencedBullet]")
		return
	if(!firer)
		message_admins("Created bullet without firer, [referencedBullet]")
		return
	src.referencedBullet = referencedBullet
	src.currentTurf = get_turf(referencedBullet)
	src.currentCoords = list(referencedBullet.pixel_x, referencedBullet.pixel_y, 0)
	src.aimedZone = aimedZone
	src.firer = firer
	src.firedTurf = get_turf(firer)
	src.firedPos = list(firer.x , firer.y , firer.z)
	src.target = target
	src.targetTurf = get_turf(target)
	src.targetCoords = targetCoords
	src.targetPos = list(target.x, target.y , target.z)
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
	var/list/coordinates = list(0,0,0,0)
	coordinates[1] = ((targetPos[1] - firedPos[1]) * PPT + targetCoords[1] - firedCoordinates[1])
	coordinates[2] = ((targetPos[2] - firedPos[2]) * PPT + targetCoords[2] - firedCoordinates[2])
	coordinates[3] = ((targetPos[3] - firedPos[3]) + targetLevel - firedLevel) + 1 >> 23
	var/matrix/rotation = matrix()
	var/distance = 0
	if(coordinates[1] == 0)
		movementRatios = list(0, 1, coordinates[3]/coordinates[2], coordinates[2] > 0 ? 90 : 270)
		rotation.Turn(movementRatios[4])
		referencedBullet.transform = rotation
		return
	if(coordinates[2] == 0)
		movementRatios = list(1, 0, coordinates[3]/coordinates[1], coordinates[1] > 0 ? 0 : 180)
		rotation.Turn(movementRatios[4])
		referencedBullet.transform = rotation
		return
	coordinates[1] /= PPT
	coordinates[2] /= PPT
	var/r = sqrt(coordinates[1] ** 2 + coordinates[2] ** 2)
	/// normalize to a representation of 360 degrees
	coordinates[4] = ATAN2(coordinates[1], coordinates[2])
	if(coordinates[4] < 0)
		coordinates[4] = 360 + coordinates[4]
	coordinates[1] /= r
	coordinates[2] /= r
	coordinates[3] /= r

	// [1] is X ratio , [2] is Y ratio,  [3] is Z-ratio
	// we get the angle of the trajectory by incrementing it.
	rotation.Turn(coordinates[4])
	referencedBullet.transform = rotation
	movementRatios = coordinates

/datum/bullet_data/proc/ricochet(atom/wall, implementation)
	var/list/bCoords = list(referencedBullet.x, referencedBullet.y, referencedBullet.pixel_x, referencedBullet.pixel_y)
	var/list/wCoords = list(wall.x, wall.y)
	if(implementation == 1)
		var/list/cCoords = list(abs(bCoords[1] - wCoords[1] + 0.00001), abs(bCoords[2] - wCoords[2] + 0.00001))
		var/list/tCoords = list(0,0)
		var/ipothenuse = sqrt(cCoords[1]**2 + cCoords[2]**2)
		if(cCoords[1] > cCoords[2])
			var/s = cCoords[1]/ipothenuse
			s = 90 - arcsin(s)
			if(s < 30)
				cCoords[1] = -cCoords[1]
		else
			var/s = cCoords[2]/ipothenuse
			s = 90 - arcsin(s)
			if(s < 30)
				cCoords[2] = -cCoords[2]
		return cCoords
	else
		var/bSlope = (referencedBullet.y + referencedBullet.pixel_y )/(referencedBullet.x + referencedBullet.pixel_x)
		var/trueAngle = 0
		if(targetCoords[1] > targetCoords[2])
			trueAngle = arctan(bSlope)
		else
			trueAngle = 180 - arctan(bSlope)

		message_admins("TRUE ANGLE - [trueAngle]")




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
		if(!istype(bullet.referencedBullet, /obj/item/projectile/bullet) || QDELETED(bullet.referencedBullet))
			bullet_queue -= bullet
			continue
		var/px = bullet.movementRatios[1] * bullet.turfsPerTick + bullet.currentCoords[1]
		var/py = bullet.movementRatios[2] * bullet.turfsPerTick + bullet.currentCoords[2]
		var/pz = bullet.movementRatios[3] * bullet.turfsPerTick + bullet.currentCoords[3]
		var/x_change = 0
		var/y_change = 0
		var/z_change = 0
		var/turfsTraveled = 0
		var/turf/target_turf
		var/updateCoords = FALSE
		while(px >= PPT/2 || py >= PPT/2 || px <= -PPT/2 || py <= -PPT/2 || pz > 1 || pz < 0)
			//message_admins("Moving [bullet.referencedBullet], y = [round(py/PPT)], py = [py], x = [round(px/PPT)], px = [px], pz = [pz]")
			if(QDELETED(bullet.referencedBullet))
				bullet_queue -= bullet
				break
			x_change = (px >= PPT/2) ? 1 : (px <= -PPT/2 ? -1 : 0)
			y_change = (py >= PPT/2) ? 1 : (py <= -PPT/2 ? -1 : 0)
			z_change = (pz >= 1) ? 1 : (pz <= 0 ? -1 : 0)
			px += -1 * x_change * PPT/2
			py += -1 * y_change * PPT/2
			pz += -1 * z_change
			if(x_change && y_change)
				var/y_bias = 0
				var/x_bias = 0
				switch(bullet.movementRatios[4])
					if(0 to 45)
						x_bias = 1
						//y_bias = -1
					if(45 to 90)
						y_bias = 1
					if(90 to 135)
						y_bias = 1
					if(135 to 180)
						//y_bias = 0
						x_bias = -1
					if(180 to 225)
						x_bias = -1
						//y_bias = 1
					if(225 to 270)
						y_bias = -1
					if(270 to 315)
						y_bias = -1
					if(315 to 360)
						x_bias = 1
				message_admins("bias : [y_bias]")
				if(y_bias)
					y_change = 0
				if(x_bias)
					x_change = 0
				// bullet loop
				target_turf = locate(bullet.referencedBullet.x + x_bias, bullet.referencedBullet.y + y_bias, bullet.referencedBullet.z)
				bullet.lifetime--
				if(!target_turf || bullet.lifetime < 0)
					bullet_queue -= bullet
					break
				if(iswall(target_turf))
				message_admins("[bullet.movementRatios[4]]")
				var/yMod = 0
				var/xMod = 0
				switch(bullet.movementRatios[4])
					if(0 to 15)
						if(y_change)
							message_admins("deflection on the y-axis")
							//y_change *= -1
							//py *= -1
							yMod = -y_change
							bullet.targetPos[2] *= -1
							//bullet.updateCoordinateRatio()
					if(345 to 360)
						if(y_change)
							message_admins("deflection on the y-axis")
							//y_change *= -1
							//py *= -1
							yMod = -y_change
							bullet.targetPos[2] *= -1
							//bullet.updateCoordinateRatio()
					if(75 to 105)
						if(x_change)
							message_admins("deflection on the x-axis")
							//x_change *= -1
							//px *= -1
							xMod = -x_change
							bullet.targetPos[1] *= -1
							//bullet.updateCoordinateRatio()
					if(165 to 195)
						if(y_change)
							message_admins("deflection on the y-axis")
							//y_change *= -1
							//py *= -1
							yMod = -y_change
							bullet.targetPos[2] *= -1
							//bullet.updateCoordinateRatio()
					if(255 to 285)
						if(x_change)
							message_admins("deflection on the x-axis")
							//x_change *= -1
							//px *= -1
							xMod = -x_change
							bullet.targetPos[1] *= -1
							//bullet.updateCoordinateRatio()

				if(xMod || yMod)
					updateCoords = TRUE
				target_turf = locate(bullet.referencedBullet.x + xMod, bullet.referencedBullet.y + yMod, bullet.referencedBullet.z)

				bullet.updateLevel()
				if(target_turf)
					bullet.referencedBullet.Move(target_turf)
					bullet.coloreds |= target_turf
					target_turf.color = "#2fff05ee"
					turfsTraveled++
				//

			// bullet loop
			target_turf = locate(bullet.referencedBullet.x + x_change, bullet.referencedBullet.y + y_change, bullet.referencedBullet.z)
			bullet.lifetime--
			if(!target_turf || bullet.lifetime < 0)
				bullet_queue -= bullet
				break
			if(iswall(target_turf))
				message_admins("[bullet.movementRatios[4]]")
				var/yMod = 0
				var/xMod = 0
				switch(bullet.movementRatios[4])
					if(0 to 15)
						if(y_change)
							message_admins("deflection on the y-axis")
							//y_change *= -1
							//py *= -1
							yMod = -y_change
							bullet.targetPos[2] *= -1
							//bullet.updateCoordinateRatio()
					if(345 to 360)
						if(y_change)
							message_admins("deflection on the y-axis")
							//y_change *= -1
							//py *= -1
							yMod = -y_change
							bullet.targetPos[2] *= -1
							//bullet.updateCoordinateRatio()
					if(75 to 105)
						if(x_change)
							message_admins("deflection on the x-axis")
							//x_change *= -1
							//px *= -1
							xMod = -x_change
							bullet.targetPos[1] *= -1
							//bullet.updateCoordinateRatio()
					if(165 to 195)
						if(y_change)
							message_admins("deflection on the y-axis")
							//y_change *= -1
							//py *= -1
							yMod = -y_change
							bullet.targetPos[2] *= -1
							//bullet.updateCoordinateRatio()
					if(255 to 285)
						if(x_change)
							message_admins("deflection on the x-axis")
							//x_change *= -1
							//px *= -1
							xMod = -x_change
							bullet.targetPos[1] *= -1
							//bullet.updateCoordinateRatio()

				if(xMod || yMod)
					updateCoords = TRUE
				target_turf = locate(bullet.referencedBullet.x + xMod, bullet.referencedBullet.y + yMod, bullet.referencedBullet.z)


			bullet.updateLevel()

			if(target_turf)
				bullet.referencedBullet.Move(target_turf)
				bullet.coloreds |= target_turf
				target_turf.color = "#2fff05ee"
				turfsTraveled++
			//


		bullet.currentCoords[1] = px
		bullet.currentCoords[2] = py
		bullet.currentCoords[3] = pz
		bullet.referencedBullet.pixel_x = -round(turfsTraveled * bullet.movementRatios[1]) - PPT/2 * x_change
		bullet.referencedBullet.pixel_y = -round(turfsTraveled * bullet.movementRatios[2]) - PPT/2 * y_change
		if(updateCoords)
			bullet.updateCoordinateRatio()
		if(turfsTraveled < 1)
			turfsTraveled = 0.5
		animate(bullet.referencedBullet, 1/turfsTraveled,  pixel_x = round(bullet.currentCoords[1]), pixel_y = round(bullet.currentCoords[2]))
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

