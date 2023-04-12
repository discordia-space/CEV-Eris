
SUBSYSTEM_DEF(bullets)
	name = "Bullets"
	wait = 1
	priority = SS_PRIORITY_BULLETS
	init_order = INIT_ORDER_BULLETS

	var/list/current_queue = list()
	var/list/hitscans = list()
	var/list/bullet_queue = list()

/datum/bullet_data
	var/obj/item/projectile/referencedBullet = null
	var/aimedZone = ""
	var/atom/firer = null
	var/turf/firedTurf = null
	var/atom/target = null
	var/turf/targetTurf = null
	var/list/targetCoords = list(0,0)
	var/turfsPerTick = 0
	var/projectileAccuracy = 0
	var/lifetime = 1 MINUTE



/datum/controller/subsystem/bullets/fire(resumed)
	. = ..()
	if(length(hitscans))

