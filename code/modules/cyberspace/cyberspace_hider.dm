/datum/global_hud
	var/obj/screen/cyberspace_background

/datum/global_hud/New()
	cyberspace_background = new /obj/screen/fullscreen/tile("black")
	. = ..()

/client/proc/AddCyberHider()
	screen |= global_hud.holomap
