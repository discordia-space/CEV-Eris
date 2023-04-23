/hook/startup/proc/InitTgs()
	world.TgsNew()
	return TRUE

/world/New()
	. = ..()
	world.TgsInitializationComplete()

/world/Reboot()
	TgsReboot()
	..()

/world/Topic()
	TGS_TOPIC
	..()
