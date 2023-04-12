
SUBSYSTEM_DEF(Bullets)
	name = "Bullets"
	wait = 1
	priority = SS_PRIORITY_BULLETS
	init_order = INIT_ORDER_BULLETS

	var/list/current_queue = list()
	var/list/bullet_queue = list()
