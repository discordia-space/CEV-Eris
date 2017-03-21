// Make ANGEL processes out of mobs
/mob/proc/daemonize()
	if(key)
		var/mob/observer/angel/daemon = new(src)	//Transfer safety to observer spawning proc.
		daemon.timeofdeath = src.stat == DEAD ? src.timeofdeath : world.time
		daemon.key = key
		return daemon