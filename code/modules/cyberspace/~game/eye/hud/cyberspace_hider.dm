/datum/global_hud
	var/obj/screen/cyberspace_background

/datum/global_hud/New()
	cyberspace_background = new/obj/screen/fullscreen/tile{color = "#eeaaaa"; blend_mode = BLEND_SUBTRACT;}("noise")
	. = ..()

/client/proc/AddCyberspaceBackground()
	screen |= global_hud.cyberspace_background
/client/proc/RemoveCyberspaceBackground()
	screen -= global_hud.cyberspace_background
