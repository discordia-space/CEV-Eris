#define LEVEL_BELOW 0
#define LEVEL_TURF 0.2
#define LEVEL_LYING 0.3
#define LEVEL_LOWWALL 0.5
#define LEVEL_TABLE 0.6
#define LEVEL_STANDING 0.8
#define LEVEL_ABOVE 1

/// Pixels per turf
#define PPT 32
#define HPPT (PPT/2)
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
	var/lastChanges = list(0,0,0)

/datum/bullet_data/New(obj/item/projectile/referencedBullet, aimedZone, atom/firer, atom/target, list/targetCoords, turfsPerTick, projectileAccuracy, lifetime)
	/*
	if(!target)
		message_admins("Created bullet without target , [referencedBullet]")
		return
	if(!firer)
		message_admins("Created bullet without firer, [referencedBullet]")
		return
	*/
	referencedBullet.dataRef = src
	src.referencedBullet = referencedBullet
	src.currentTurf = get_turf(referencedBullet)
	src.currentCoords = list(referencedBullet.pixel_x, referencedBullet.pixel_y, referencedBullet.z)
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
	src.firedCoordinates = list(0,0, referencedBullet.z)
	src.currentCoords[3] += firedLevel
	updateCoordinateRatio()
	SSbullets.bullet_queue += src

/datum/bullet_data/proc/redirect(list/targetCoordinates, list/firingCoordinates)
	src.firedTurf = get_turf(referencedBullet)
	src.firedPos = firingCoordinates
	src.targetCoords = targetCoordinates
	updateCoordinateRatio()

/datum/bullet_data/proc/updateCoordinateRatio()
	var/list/coordinates = list(0,0,0,0)
	var/matrix/rotation = matrix()
	coordinates[1] = ((targetPos[1] - firedPos[1]) * PPT + targetCoords[1] - firedCoordinates[1] - HPPT)
	coordinates[2] = ((targetPos[2] - firedPos[2]) * PPT + targetCoords[2] - firedCoordinates[2] - HPPT)
	coordinates[3] = ((targetPos[3] - firedPos[3]) + targetLevel - firedLevel)
	coordinates[4] = ATAN2(coordinates[2], coordinates[1])
	coordinates[1] = sin(coordinates[4])
	coordinates[2] = cos(coordinates[4])
	// [1] is X ratio , [2] is Y ratio,  [3] is Z-ratio
	//message_admins("[referencedBullet] -/- [coordinates[4]] , x: [coordinates[1]], y:[coordinates[2]]")
	rotation.Turn(coordinates[4] + 180)
	referencedBullet.transform = rotation
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
	/// Prevent random dealocations and reallocations , just have em up initialized once.
	var/list/bulletRatios
	var/list/bulletCoords
	var/obj/item/projectile/projectile
	var/x_change
	var/y_change
	var/z_change
	var/tx_change
	var/ty_change
	var/sx_change
	var/sy_change
	var/turf/moveTurf = null
	for(var/datum/bullet_data/bullet in current_queue)
		current_queue -= bullet
		bullet.lastChanges[1] = 0
		bullet.lastChanges[2] = 0
		bullet.lastChanges[3] = 0
		if(!istype(bullet.referencedBullet, /obj/item/projectile/bullet) || QDELETED(bullet.referencedBullet))
			bullet_queue -= bullet
			continue
		bulletRatios = bullet.movementRatios
		bulletCoords = bullet.currentCoords
		projectile = bullet.referencedBullet
		bulletCoords[1] += (bulletRatios[1] * bullet.turfsPerTick)
		bulletCoords[2] += (bulletRatios[2] * bullet.turfsPerTick)
		bulletCoords[3] += (bulletRatios[3] * bullet.turfsPerTick)
		x_change = round(abs(bulletCoords[1]) / HPPT) * sign(bulletCoords[1])
		y_change = round(abs(bulletCoords[2]) / HPPT) * sign(bulletCoords[2])
		z_change = round(abs(bulletCoords[3]) / HPPT) * sign(bulletCoords[3])
		tx_change = 0
		ty_change = 0
		sx_change = 0
		sy_change = 0
		while(x_change || y_change)
			if(QDELETED(projectile))
				bullet_queue -= bullet
				break
			tx_change = 0
			ty_change = 0
			if(x_change)
				tx_change = x_change/abs(x_change)
			if(y_change)
				ty_change = y_change/abs(y_change)
			moveTurf = locate(projectile.x + tx_change, projectile.y + ty_change, projectile.z)
			x_change -= tx_change
			y_change -= ty_change
			lastChanges[1] += tx_change
			lastChanges[2] += ty_change
			bulletCoords[1] -= PPT * tx_change
			bulletCoords[2] -= PPT * ty_change
			projectile.pixel_x -= PPT * tx_change
			projectile.pixel_y -= PPT * ty_change
			bullet.lifetime--
			if(bullet.lifetime < 0)
				bullet_queue -= bullet
				break
			bullet.updateLevel()
			if(moveTurf)
				projectile.Move(moveTurf)
				bullet.coloreds |= moveTurf
				moveTurf.color = "#2fff05ee"
			moveTurf = null
			if(sx_change)
				x_change = sx_change
				sx_change = 0
			if(sy_change)
				y_change = sy_change
				sy_change = 0

		animate(projectile, 1, pixel_x =(abs(bulletCoords[1]))%HPPT * sign(bulletCoords[1]) - 1, pixel_y = (abs(bulletCoords[2]))%HPPT * sign(bulletCoords[2]) - 1, flags = ANIMATION_END_NOW)
		bullet.currentCoords = bulletCoords

		if(QDELETED(projectile))
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

