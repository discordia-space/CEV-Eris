// Make ANGEL processes out of mobs
/mob/proc/daemonize()
	if(key)
		var/mob/angel/daemon = new(src)	//Transfer safety to observer spawning proc.
		daemon.key = key
		return daemon